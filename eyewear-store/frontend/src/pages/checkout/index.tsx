import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Layout from '@/components/layout/Layout';
import { useCartStore } from '@/store/cartStore';
import { useAuthStore } from '@/store/authStore';
import AddressForm from '@/components/checkout/AddressForm';
import OrderSummary from '@/components/checkout/OrderSummary';
import PaymentMethod from '@/components/checkout/PaymentMethod';
import { createOrder, getShippingMethods } from '@/services/api/orders';
import { createPaymentIntent } from '@/services/api/payments';
import { loadStripe } from '@stripe/stripe-js';
import { Elements } from '@stripe/react-stripe-js';

// Initialize Stripe
const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!);

// Steps in checkout process
type CheckoutStep = 'shipping' | 'payment' | 'confirmation';

export default function CheckoutPage() {
  const router = useRouter();
  const { items, totalPrice, clearCart } = useCartStore();
  const { isAuthenticated, user } = useAuthStore();
  const [currentStep, setCurrentStep] = useState<CheckoutStep>('shipping');
  const [shippingAddress, setShippingAddress] = useState(null);
  const [billingAddress, setBillingAddress] = useState(null);
  const [sameAsShipping, setSameAsShipping] = useState(true);
  const [shippingMethod, setShippingMethod] = useState('');
  const [shippingMethods, setShippingMethods] = useState([]);
  const [shippingCost, setShippingCost] = useState(0);
  const [isLoading, setIsLoading] = useState(false);
  const [orderId, setOrderId] = useState<string | null>(null);

  // Ensure user is authenticated
  useEffect(() => {
    if (!isAuthenticated && typeof window !== 'undefined') {
      router.replace('/auth/login?redirect=/checkout');
    }
  }, [isAuthenticated, router]);

  // Fetch shipping methods
  useEffect(() => {
    async function fetchShippingMethods() {
      try {
        const methods = await getShippingMethods();
        setShippingMethods(methods);
        if (methods.length > 0) {
          setShippingMethod(methods[0].id);
          setShippingCost(methods[0].cost);
        }
      } catch (error) {
        console.error('Error fetching shipping methods:', error);
      }
    }
    
    fetchShippingMethods();
  }, []);

  // If cart is empty, redirect to cart page
  useEffect(() => {
    if (items.length === 0 && typeof window !== 'undefined') {
      router.replace('/cart');
    }
  }, [items, router]);

  const handleShippingSubmit = (address) => {
    setShippingAddress(address);
    if (sameAsShipping) {
      setBillingAddress(address);
    }
    setCurrentStep('payment');
  };

  const handleBillingSubmit = (address) => {
    setBillingAddress(address);
  };

  const handlePaymentSubmit = async (paymentMethodId) => {
    setIsLoading(true);
    
    try {
      // Create order
      const orderData = {
        items: items.map(item => ({
          productId: item.id,
          quantity: item.quantity,
          price: item.price
        })),
        shippingAddress,
        billingAddress: sameAsShipping ? shippingAddress : billingAddress,
        shippingMethod,
        shippingCost,
        subtotal: totalPrice,
        total: totalPrice + shippingCost
      };
      
      const order = await createOrder(orderData);
      setOrderId(order.id);
      
      // Process payment
      const paymentResult = await createPaymentIntent({
        orderId: order.id,
        paymentMethodId
      });
      
      if (paymentResult.status === 'succeeded') {
        clearCart();
        router.push(`/checkout/confirmation/${order.id}`);
      } else if (paymentResult.status === 'processing') {
        // Redirect to confirmation page with processing status
        router.push(`/checkout/confirmation/${order.id}?status=processing`);
      } else {
        // Handle other payment statuses
        router.push(`/checkout/confirmation/${order.id}?status=${paymentResult.status}`);
      }
    } catch (error) {
      console.error('Payment error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  if (!isAuthenticated || items.length === 0) {
    return (
      <Layout title="Checkout | Eyewear Store">
        <div className="container mx-auto px-4 py-12">
          <p>Loading...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title="Checkout | Eyewear Store">
      <div className="container mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-8">Checkout</h1>
        
        <div className="flex flex-col lg:flex-row gap-8">
          {/* Main checkout flow */}
          <div className="flex-1">
            {/* Checkout steps */}
            <div className="mb-8">
              <div className="flex items-center">
                <div className={`flex items-center justify-center w-8 h-8 rounded-full ${currentStep === 'shipping' ? 'bg-blue-600 text-white' : 'bg-gray-200'}`}>
                  1
                </div>
                <div className="mx-4 flex-1 h-px bg-gray-300"></div>
                <div className={`flex items-center justify-center w-8 h-8 rounded-full ${currentStep === 'payment' ? 'bg-blue-600 text-white' : 'bg-gray-200'}`}>
                  2
                </div>
              </div>
              <div className="flex justify-between mt-2">
                <span className="text-sm font-medium">Shipping</span>
                <span className="text-sm font-medium">Payment</span>
              </div>
            </div>
            
            {/* Step content */}
            {currentStep === 'shipping' && (
              <div>
                <h2 className="text-xl font-semibold mb-4">Shipping Address</h2>
                <AddressForm 
                  onSubmit={handleShippingSubmit} 
                  initialAddress={shippingAddress}
                  isLoading={isLoading}
                />
                
                {/* Billing address checkbox */}
                <div className="mt-6">
                  <label className="flex items-center">
                    <input 
                      type="checkbox" 
                      checked={sameAsShipping}
                      onChange={(e) => setSameAsShipping(e.target.checked)}
                      className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                    />
                    <span className="ml-2 text-gray-700">Billing address same as shipping</span>
                  </label>
                </div>
                
                {/* Billing address form if different */}
                {!sameAsShipping && (
                  <div className="mt-6">
                    <h2 className="text-xl font-semibold mb-4">Billing Address</h2>
                    <AddressForm 
                      onSubmit={handleBillingSubmit} 
                      initialAddress={billingAddress}
                      isLoading={isLoading}
                    />
                  </div>
                )}
                
                {/* Shipping method selection */}
                <div className="mt-6">
                  <h2 className="text-xl font-semibold mb-4">Shipping Method</h2>
                  <div className="space-y-4">
                    {shippingMethods.map((method) => (
                      <label 
                        key={method.id} 
                        className={`flex items-center justify-between border p-4 rounded-md cursor-pointer ${shippingMethod === method.id ? 'border-blue-600 bg-blue-50' : 'border-gray-200'}`}
                      >
                        <div className="flex items-center">
                          <input 
                            type="radio" 
                            name="shippingMethod"
                            value={method.id}
                            checked={shippingMethod === method.id}
                            onChange={() => {
                              setShippingMethod(method.id);
                              setShippingCost(method.cost);
                            }}
                            className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300"
                          />
                          <div className="ml-3">
                            <p className="text-sm font-medium text-gray-900">{method.name}</p>
                            <p className="text-sm text-gray-500">{method.description}</p>
                          </div>
                        </div>
                        <p className="text-sm font-medium text-gray-900">${method.cost.toFixed(2)}</p>
                      </label>
                    ))}
                  </div>
                </div>
              </div>
            )}
            
            {currentStep === 'payment' && (
              <div>
                <h2 className="text-xl font-semibold mb-4">Payment Method</h2>
                <Elements stripe={stripePromise}>
                  <PaymentMethod
                    onSubmit={handlePaymentSubmit}
                    isLoading={isLoading}
                    onBack={() => setCurrentStep('shipping')}
                  />
                </Elements>
              </div>
            )}
          </div>
          
          {/* Order summary sidebar */}
          <div className="lg:w-1/3">
            <OrderSummary 
              items={items}
              subtotal={totalPrice}
              shippingCost={shippingCost}
              total={totalPrice + shippingCost}
            />
          </div>
        </div>
      </div>
    </Layout>
  );
}
