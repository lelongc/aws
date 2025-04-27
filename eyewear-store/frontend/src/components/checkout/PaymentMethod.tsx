import React, { useState } from 'react';
import { CardElement, useStripe, useElements } from '@stripe/react-stripe-js';
import Button from '@/components/ui/Button';

interface PaymentMethodProps {
  onSubmit: (paymentMethodId: string) => Promise<void>;
  onBack: () => void;
  isLoading: boolean;
}

export default function PaymentMethod({ onSubmit, onBack, isLoading }: PaymentMethodProps) {
  const stripe = useStripe();
  const elements = useElements();
  const [error, setError] = useState<string | null>(null);
  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!stripe || !elements) {
      // Stripe.js has not loaded yet. Make sure to disable form submission until Stripe.js has loaded.
      return;
    }
    
    setError(null);
    
    const cardElement = elements.getElement(CardElement);
    if (!cardElement) {
      return;
    }
    
    try {
      const { error, paymentMethod } = await stripe.createPaymentMethod({
        type: 'card',
        card: cardElement,
      });
      
      if (error) {
        setError(error.message || 'An error occurred with your payment');
        return;
      }
      
      await onSubmit(paymentMethod.id);
    } catch (err) {
      setError('An unexpected error occurred. Please try again.');
      console.error('Payment error:', err);
    }
  };
  
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="mb-6">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Card Details
          </label>
          <div className="border border-gray-300 rounded-md p-4 focus-within:ring-2 focus-within:ring-blue-500 focus-within:border-blue-500">
            <CardElement
              options={{
                style: {
                  base: {
                    fontSize: '16px',
                    color: '#424770',
                    '::placeholder': {
                      color: '#aab7c4',
                    },
                  },
                  invalid: {
                    color: '#9e2146',
                  },
                },
              }}
            />
          </div>
          {error && (
            <p className="mt-2 text-sm text-red-600">{error}</p>
          )}
        </div>
        
        <div className="flex items-center justify-between mt-8">
          <Button
            type="button"
            variant="outline"
            onClick={onBack}
            disabled={isLoading}
          >
            Back to Shipping
          </Button>
          
          <Button
            type="submit"
            disabled={!stripe || isLoading}
            isLoading={isLoading}
          >
            {isLoading ? 'Processing...' : 'Pay Now'}
          </Button>
        </div>
      </form>
    </div>
  );
}
