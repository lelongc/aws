import { loadStripe } from '@stripe/stripe-js';
import api from './index';

// Load Stripe outside of components to avoid recreating Stripe object on every render
// Make sure you set your environment variable
const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!);

interface CreatePaymentIntentRequest {
  amount: number;
  currency?: string;
  orderId: string;
}

interface CreatePaymentIntentResponse {
  clientSecret: string;
  paymentIntentId: string;
}

export async function createPaymentIntent(data: CreatePaymentIntentRequest): Promise<CreatePaymentIntentResponse> {
  const response = await api.post('/payments/create-intent', data);
  return response.data;
}

export async function confirmPayment(clientSecret: string, paymentMethod: any) {
  const stripe = await stripePromise;
  if (!stripe) {
    throw new Error('Stripe failed to load');
  }
  
  return stripe.confirmCardPayment(clientSecret, {
    payment_method: paymentMethod
  });
}

export async function redirectToCheckout(sessionId: string) {
  const stripe = await stripePromise;
  if (!stripe) {
    throw new Error('Stripe failed to load');
  }
  
  return stripe.redirectToCheckout({ sessionId });
}
