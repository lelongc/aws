import React, { useEffect } from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';
import Layout from '@/components/layout/Layout';
import { CheckCircleIcon } from '@heroicons/react/solid';
import { getOrderById } from '@/services/api/orders';
import { Order } from '@eyewear-store/shared/types';
import { useCartStore } from '@/store/cartStore';

export default function CheckoutSuccessPage() {
  const router = useRouter();
  const { orderId } = router.query;
  const [order, setOrder] = React.useState<Order | null>(null);
  const [isLoading, setIsLoading] = React.useState(true);
  const { clearCart } = useCartStore();

  useEffect(() => {
    // Clear cart when reaching this page
    clearCart();
    
    if (!orderId) return;

    const fetchOrder = async () => {
      try {
        setIsLoading(true);
        const data = await getOrderById(orderId as string);
        setOrder(data);
      } catch (error) {
        console.error('Error fetching order:', error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchOrder();
  }, [orderId, clearCart]);

  return (
    <Layout title="Đặt hàng thành công | Eyewear Store">
      <div className="bg-gray-50 min-h-[70vh] py-12">
        <div className="container mx-auto px-4 py-16 sm:py-24">
          <div className="max-w-3xl mx-auto bg-white rounded-lg shadow-sm p-8">
            <div className="text-center">
              <CheckCircleIcon className="mx-auto h-12 w-12 text-green-500" />
              <h1 className="mt-4 text-3xl font-bold text-gray-900">Cảm ơn bạn đã đặt hàng!</h1>
              <p className="mt-2 text-lg text-gray-600">
                Đơn hàng của bạn đã được xác nhận và đang được xử lý.
              </p>
              <p className="mt-1 text-gray-500">
                Chúng tôi đã gửi email xác nhận đơn hàng đến địa chỉ email của bạn.
              </p>
            </div>

            {isLoading ? (
              <div className="flex justify-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-indigo-500"></div>
              </div>
            ) : order ? (
              <div className="mt-8 border-t border-gray-200 pt-6">
                <div className="mb-6">
                  <h2 className="text-lg font-medium text-gray-900">Thông tin đơn hàng</h2>
                  <p className="mt-1 text-sm text-gray-600">
                    Mã đơn hàng: {order.id.substring(0, 8)}
                  </p>
                </div>

                <div className="border rounded-md p-4 mb-6">
                  <h3 className="font-medium text-gray-900 mb-2">Chi tiết đơn hàng</h3>
                  <ul className="space-y-3">
                    {order.items.map((item, index) => (
                      <li key={item.id || index} className="flex justify-between">
                        <div>
                          <p className="text-sm font-medium">
                            {item.name || `Sản phẩm #${index + 1}`}
                          </p>
                          <p className="text-sm text-gray-500">SL: {item.quantity}</p>
                        </div>
                        <p className="text-sm font-medium">${(item.price * item.quantity).toFixed(2)}</p>
                      </li>
                    ))}
                  </ul>
                  <div className="border-t border-gray-200 mt-4 pt-4 flex justify-between">
                    <p className="font-medium">Tổng cộng:</p>
                    <p className="font-medium">${order.totalAmount.toFixed(2)}</p>
                  </div>
                </div>

                <div className="border rounded-md p-4 mb-6">
                  <h3 className="font-medium text-gray-900 mb-2">Địa chỉ giao hàng</h3>
                  <address className="text-sm not-italic">
                    {order.shippingAddress.firstName} {order.shippingAddress.lastName}<br />
                    {order.shippingAddress.address}<br />
                    {order.shippingAddress.city}, {order.shippingAddress.postalCode}<br />
                    {order.shippingAddress.country}
                  </address>
                </div>

                <div className="border rounded-md p-4 mb-6">
                  <h3 className="font-medium text-gray-900 mb-2">Phương thức thanh toán</h3>
                  <p className="text-sm">
                    {order.paymentMethod === 'credit_card' ? 'Thẻ tín dụng/ghi nợ' : 
                     order.paymentMethod === 'cod' ? 'Thanh toán khi nhận hàng (COD)' :
                     order.paymentMethod}
                  </p>
                </div>
              </div>
            ) : (
              <div className="mt-8 border-t border-gray-200 pt-6 text-center text-gray-600">
                Không thể tải thông tin đơn hàng.
              </div>
            )}

            <div className="mt-8 flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4 justify-center">
              <Link
                href="/account/orders"
                className="inline-flex justify-center items-center px-5 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Xem đơn hàng của tôi
              </Link>
              <Link
                href="/products"
                className="inline-flex justify-center items-center px-5 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Tiếp tục mua sắm
              </Link>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
