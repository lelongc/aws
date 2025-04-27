import React, { useState } from 'react';
import { CardElement, useStripe, useElements, Elements } from '@stripe/react-stripe-js';
import { loadStripe } from '@stripe/stripe-js';
import { createPaymentIntent } from '@/services/api/payments';
import toast from 'react-hot-toast';

// Make sure to call `loadStripe` outside of a component's render to avoid recreating the Stripe object
// on every render.
const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!);

interface PaymentFormProps {
  amount: number;
  orderId: string;
  onSuccess: (paymentIntentId: string) => void;
  onError: (error: string) => void;
}

function PaymentForm({ amount, orderId, onSuccess, onError }: PaymentFormProps) {
  const stripe = useStripe();
  const elements = useElements();
  const [isProcessing, setIsProcessing] = useState(false);
  const [cardError, setCardError] = useState<string | null>(null);

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();

    if (!stripe || !elements) {
      // Stripe.js has not loaded yet
      return;
    }

    const cardElement = elements.getElement(CardElement);
    if (!cardElement) {
      return;
    }

    setIsProcessing(true);
    setCardError(null);

    try {
      // Create a payment intent on the server
      const { clientSecret, paymentIntentId } = await createPaymentIntent({
        amount,
        currency: 'usd',
        orderId
      });

      // Confirm the payment with the card details
      const { error, paymentIntent } = await stripe.confirmCardPayment(clientSecret, {
        payment_method: {
          card: cardElement,
        }
      });

      if (error) {
        setCardError(error.message || 'Có lỗi xảy ra trong quá trình thanh toán');
        onError(error.message || 'Payment failed');
      } else if (paymentIntent?.status === 'succeeded') {
        toast.success('Thanh toán thành công!');
        onSuccess(paymentIntentId);
      } else {
        setCardError('Thanh toán chưa hoàn tất. Vui lòng thử lại.');
        onError('Payment failed');
      }
    } catch (error: any) {
      setCardError(error.message || 'Có lỗi xảy ra trong quá trình thanh toán');
      onError(error.message || 'Payment failed');
    } finally {
      setIsProcessing(false);
    }
  };

  const cardElementOptions = {
    style: {
      base: {
        fontSize: '16px',
        color: '#32325d',
        '::placeholder': {
          color: '#aab7c4',
        },
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a',
      },
    },
    hidePostalCode: true,
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="border rounded-md p-4 bg-white">
        <label htmlFor="card-element" className="block text-sm font-medium text-gray-700 mb-2">
          Thông tin thẻ
        </label>
        <div className="border border-gray-300 rounded-md p-3">
          <CardElement
            id="card-element"
            options={cardElementOptions}
            onChange={(e) => {
              if (e.error) {
                setCardError(e.error.message);
              } else {
                setCardError(null);
              }
            }}
          />
        </div>
        {cardError && (
          <p className="mt-2 text-sm text-red-600">{cardError}</p>
        )}
        <div className="mt-2 text-xs text-gray-500">
          * Thông tin thẻ của bạn được bảo mật tuyệt đối bởi Stripe
        </div>
      </div>

      <button
        type="submit"
        disabled={!stripe || isProcessing}
        className="w-full bg-indigo-600 border border-transparent rounded-md shadow-sm py-3 px-4 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
      >
        {isProcessing ? 
          'Đang xử lý thanh toán...' : 
          `Thanh toán $${amount.toFixed(2)}`
        }
      </button>
    </form>
  );
}

export default function StripePaymentForm(props: Omit<PaymentFormProps, 'stripe' | 'elements'>) {
  return (
    <Elements stripe={stripePromise}>
      <PaymentForm {...props} />
    </Elements>
  );
}
