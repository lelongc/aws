import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';
import { OrdersService } from '../orders/orders.service';
import { CreatePaymentIntentDto } from './dto/create-payment-intent.dto';
import { User } from '../users/entities/user.entity';
import { OrderStatus } from '../orders/enums/order-status.enum';

@Injectable()
export class PaymentsService {
  private stripe: Stripe;

  constructor(
    private configService: ConfigService,
    private ordersService: OrdersService,
  ) {
    this.stripe = new Stripe(this.configService.get('STRIPE_SECRET_KEY'), {
      apiVersion: '2023-08-16',
    });
  }

  async createPaymentIntent(createPaymentIntentDto: CreatePaymentIntentDto, user: User) {
    const { orderId, paymentMethodId } = createPaymentIntentDto;
    
    // Retrieve order
    const order = await this.ordersService.findOne(orderId);
    
    if (!order) {
      throw new NotFoundException(`Order with ID ${orderId} not found`);
    }
    
    if (order.user.id !== user.id) {
      throw new BadRequestException('You do not have permission to pay for this order');
    }
    
    if (order.status !== OrderStatus.PENDING) {
      throw new BadRequestException(`Order is in ${order.status} status and cannot be paid`);
    }
    
    try {
      // Create payment intent with Stripe
      const paymentIntent = await this.stripe.paymentIntents.create({
        amount: Math.round(order.total * 100), // Amount in cents
        currency: 'usd',
        payment_method: paymentMethodId,
        confirm: true,
        return_url: `${this.configService.get('FRONTEND_URL')}/orders/confirmation/${order.id}`,
        metadata: {
          orderId: order.id,
          orderNumber: order.orderNumber,
          userId: user.id,
        },
      });
      
      // Update order with payment intent
      await this.ordersService.updatePaymentStatus(
        order.id, 
        paymentIntent.id,
        paymentIntent.status === 'succeeded' ? OrderStatus.PAID : OrderStatus.PENDING,
      );
      
      return {
        clientSecret: paymentIntent.client_secret,
        status: paymentIntent.status,
      };
    } catch (error) {
      throw new BadRequestException(`Payment failed: ${error.message}`);
    }
  }

  async handleWebhook(signature: string, payload: Buffer) {
    const webhookSecret = this.configService.get('STRIPE_WEBHOOK_SECRET');
    
    try {
      const event = this.stripe.webhooks.constructEvent(
        payload,
        signature,
        webhookSecret,
      );
      
      switch (event.type) {
        case 'payment_intent.succeeded':
          const paymentIntent = event.data.object as Stripe.PaymentIntent;
          await this.handleSuccessfulPayment(paymentIntent);
          break;
          
        case 'payment_intent.payment_failed':
          const failedPaymentIntent = event.data.object as Stripe.PaymentIntent;
          await this.handleFailedPayment(failedPaymentIntent);
          break;
      }
      
      return { received: true };
    } catch (error) {
      throw new BadRequestException(`Webhook error: ${error.message}`);
    }
  }

  private async handleSuccessfulPayment(paymentIntent: Stripe.PaymentIntent) {
    const orderId = paymentIntent.metadata.orderId;
    await this.ordersService.updatePaymentStatus(
      orderId,
      paymentIntent.id,
      OrderStatus.PAID,
    );
  }

  private async handleFailedPayment(paymentIntent: Stripe.PaymentIntent) {
    const orderId = paymentIntent.metadata.orderId;
    // Handle failed payment - keep the order in pending status
    // You might want to notify the user or make other updates here
  }
}
