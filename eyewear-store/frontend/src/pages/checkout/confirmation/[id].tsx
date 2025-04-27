import React, { useEffect, useState } from 'react';
import { GetServerSideProps } from 'next';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { CheckCircleIcon, XCircleIcon } from '@heroicons/react/24/outline';
import Layout from '@/components/layout/Layout';
import Button from '@/components/ui/Button';
import { getOrder } from '@/services/api/orders';
import { useAuthStore } from '@/store/authStore';

interface OrderConfirmationProps {
  order: any;
  status: string;
}

export default function OrderConfirmationPage({ order, status }: OrderConfirmationProps) {
  const router = useRouter();
  const { isAuthenticated } = useAuthStore();
  const [countdown, setCountdown] = useState(10);
  
  useEffect(() => {
    if (!isAuthenticated) {
      router.replace('/auth/login');
    }
  }, [isAuthenticated, router]);
  
  useEffect(() => {
    if (status === 'succeeded' && countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [countdown, status]);
  
  const isSuccess = status === 'succeeded';

  if (!order) {
    return (
      <Layout title="Order Not Found | Eyewear Store">
        <div className="container mx-auto px-4 py-16">
          <div className="max-w-lg mx-auto text-center">
            <XCircleIcon className="mx-auto h-16 w-16 text-red-500" />
            <h1 className="mt-4 text-2xl font-bold text-gray-900">Order Not Found</h1>
            <p className="mt-2 text-gray-600">
              We couldn't find the order you're looking for. It may have been removed or the link is invalid.
            </p>
            <div className="mt-6">
              <Link href="/products">
                <Button>Continue Shopping</Button>
              </Link>
            </div>
          </div>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title={`Order ${isSuccess ? 'Confirmed' : 'Processing'} | Eyewear Store`}>
      <div className="container mx-auto px-4 py-16">
        <div className="max-w-2xl mx-auto">
          {isSuccess ? (
            <div className="text-center">
              <CheckCircleIcon className="mx-auto h-16 w-16 text-green-500" />
              <h1 className="mt-4 text-2xl font-bold text-gray-900">Order Confirmed!</h1>
              <p className="mt-2 text-gray-600">
                Thank you for your purchase. Your order has been successfully placed.
              </p>
            </div>
          ) : (
            <div className="text-center">
              <div className="animate-pulse mx-auto h-16 w-16 text-blue-500">
                <svg className="w-full h-full" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              </div>
              <h1 className="mt-4 text-2xl font-bold text-gray-900">Processing Your Order</h1>
              <p className="mt-2 text-gray-600">
                Your payment is being processed. Please don't close this page.
              </p>
            </div>
          )}
          
          <div className="mt-8 border rounded-lg overflow-hidden">
            <div className="bg-gray-50 px-6 py-4 border-b">
              <h2 className="text-lg font-medium text-gray-900">Order Details</h2>
            </div>
            <div className="px-6 py-4">
              <dl className="divide-y divide-gray-200">
                <div className="py-3 flex justify-between">
                  <dt className="text-sm font-medium text-gray-500">Order number</dt>
                  <dd className="text-sm font-medium text-gray-900">{order.orderNumber}</dd>
                </div>
                <div className="py-3 flex justify-between">
                  <dt className="text-sm font-medium text-gray-500">Date</dt>
                  <dd className="text-sm font-medium text-gray-900">
                    {new Date(order.createdAt).toLocaleDateString()}
                  </dd>
                </div>
                <div className="py-3 flex justify-between">
                  <dt className="text-sm font-medium text-gray-500">Status</dt>
                  <dd className="text-sm font-medium">
                    <span className={`px-2 py-1 rounded-full text-xs ${
                      isSuccess ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                    }`}>
                      {order.status}
                    </span>
                  </dd>
                </div>
                <div className="py-3 flex justify-between">
                  <dt className="text-sm font-medium text-gray-500">Total</dt>
                  <dd className="text-sm font-medium text-gray-900">${order.total.toFixed(2)}</dd>
                </div>
              </dl>
            </div>
          </div>
          
          <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Shipping Address */}
            <div className="border rounded-lg overflow-hidden">
              <div className="bg-gray-50 px-4 py-3 border-b">
                <h3 className="text-sm font-medium text-gray-900">Shipping Address</h3>
              </div>
              <div className="px-4 py-3">
                <address className="text-sm not-italic text-gray-600">
                  {order.shippingAddress?.firstName} {order.shippingAddress?.lastName}<br />
                  {order.shippingAddress?.addressLine1}<br />
                  {order.shippingAddress?.addressLine2 && <>{order.shippingAddress.addressLine2}<br /></>}
                  {order.shippingAddress?.city}, {order.shippingAddress?.state} {order.shippingAddress?.postalCode}<br />
                  {order.shippingAddress?.country}<br />
                  {order.shippingAddress?.phoneNumber}
                </address>
              </div>
            </div>
            
            {/* Billing Address */}
            <div className="border rounded-lg overflow-hidden">
              <div className="bg-gray-50 px-4 py-3 border-b">
                <h3 className="text-sm font-medium text-gray-900">Billing Address</h3>
              </div>
              <div className="px-4 py-3">
                <address className="text-sm not-italic text-gray-600">
                  {order.billingAddress?.firstName} {order.billingAddress?.lastName}<br />
                  {order.billingAddress?.addressLine1}<br />
                  {order.billingAddress?.addressLine2 && <>{order.billingAddress.addressLine2}<br /></>}
                  {order.billingAddress?.city}, {order.billingAddress?.state} {order.billingAddress?.postalCode}<br />
                  {order.billingAddress?.country}<br />
                  {order.billingAddress?.phoneNumber}
                </address>
              </div>
            </div>
          </div>
          
          <div className="mt-8 border rounded-lg overflow-hidden">
            <div className="bg-gray-50 px-6 py-4 border-b">
              <h2 className="text-lg font-medium text-gray-900">Order Items</h2>
            </div>
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Product
                  </th>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Price
                  </th>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Quantity
                  </th>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Total
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {order.items.map((item: any) => (
                  <tr key={item.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {item.product.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      ${item.price.toFixed(2)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {item.quantity}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      ${item.total.toFixed(2)}
                    </td>
                  </tr>
                ))}
              </tbody>
              <tfoot>
                <tr className="bg-gray-50">
                  <td colSpan={3} className="px-6 py-4 text-sm font-medium text-gray-900 text-right">
                    Subtotal
                  </td>
                  <td className="px-6 py-4 text-sm text-gray-900 font-medium">
                    ${order.subtotal.toFixed(2)}
                  </td>
                </tr>
                <tr>
                  <td colSpan={3} className="px-6 py-4 text-sm font-medium text-gray-900 text-right">
                    Shipping
                  </td>
                  <td className="px-6 py-4 text-sm text-gray-900">
                    ${order.shipping.toFixed(2)}
                  </td>
                </tr>
                <tr>
                  <td colSpan={3} className="px-6 py-4 text-sm font-medium text-gray-900 text-right">
                    Total
                  </td>
                  <td className="px-6 py-4 text-sm font-semibold text-gray-900">
                    ${order.total.toFixed(2)}
                  </td>
                </tr>
              </tfoot>
            </table>
          </div>
          
          <div className="mt-8 flex justify-between">
            <Link href="/account/orders">
              <Button variant="outline">View All Orders</Button>
            </Link>
            
            <Link href="/products">
              <Button>
                {isSuccess 
                  ? countdown > 0 ? `Continue Shopping (${countdown})` : 'Continue Shopping' 
                  : 'Browse Products'
                }
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async (context) => {
  const { id, status = 'processing' } = context.params || {};
  
  try {
    if (typeof id !== 'string') {
      throw new Error('Invalid order ID');
    }
    
    const order = await getOrder(id);
    
    return {
      props: {
        order,
        status: status || order.status,
      },
    };
  } catch (error) {
    console.error('Error fetching order:', error);
    return {
      props: {
        order: null,
        status: 'error',
      },
    };
  }
};
