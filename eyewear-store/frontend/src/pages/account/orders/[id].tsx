import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import Image from 'next/image';
import Link from 'next/link';
import { format } from 'date-fns';
import { getOrderById, cancelOrder } from '@/services/api/orders';
import { Order, OrderStatus, PaymentStatus } from '@eyewear-store/shared/types';
import Layout from '@/components/layout/Layout';
import { useAuthStore } from '@/store/authStore';
import { Badge } from '@/components/ui/Badge';
import toast from 'react-hot-toast';

export default function OrderDetailPage() {
  const [order, setOrder] = useState<Order | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isCancelling, setIsCancelling] = useState(false);
  const { isAuthenticated } = useAuthStore();
  const router = useRouter();
  const { id } = router.query;

  useEffect(() => {
    if (!isAuthenticated) {
      router.push({
        pathname: '/auth/login',
        query: { returnUrl: router.asPath }
      });
      return;
    }

    if (!id) return;

    const loadOrder = async () => {
      try {
        setIsLoading(true);
        const orderData = await getOrderById(id as string);
        setOrder(orderData);
      } catch (error) {
        console.error('Failed to load order:', error);
        toast.error('Không thể tải thông tin đơn hàng');
      } finally {
        setIsLoading(false);
      }
    };

    loadOrder();
  }, [id, isAuthenticated, router]);

  const handleCancelOrder = async () => {
    if (!order) return;
    
    if (window.confirm('Bạn có chắc muốn hủy đơn hàng này không?')) {
      try {
        setIsCancelling(true);
        const updatedOrder = await cancelOrder(order.id);
        setOrder(updatedOrder);
        toast.success('Đơn hàng đã được hủy thành công');
      } catch (error) {
        console.error('Failed to cancel order:', error);
        toast.error('Không thể hủy đơn hàng');
      } finally {
        setIsCancelling(false);
      }
    }
  };

  const getStatusColor = (status: OrderStatus) => {
    switch (status) {
      case OrderStatus.PENDING:
        return 'bg-yellow-100 text-yellow-800';
      case OrderStatus.PROCESSING:
        return 'bg-blue-100 text-blue-800';
      case OrderStatus.SHIPPED:
        return 'bg-indigo-100 text-indigo-800';
      case OrderStatus.DELIVERED:
        return 'bg-green-100 text-green-800';
      case OrderStatus.CANCELLED:
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const getPaymentStatusColor = (status: PaymentStatus) => {
    switch (status) {
      case PaymentStatus.PAID:
        return 'bg-green-100 text-green-800';
      case PaymentStatus.PENDING:
        return 'bg-yellow-100 text-yellow-800';
      case PaymentStatus.FAILED:
        return 'bg-red-100 text-red-800';
      case PaymentStatus.REFUNDED:
        return 'bg-purple-100 text-purple-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  return (
    <Layout title="Chi tiết đơn hàng | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <div className="flex items-center mb-6">
          <Link
            href="/account/orders"
            className="text-indigo-600 hover:text-indigo-500 mr-4"
          >
            ← Quay lại
          </Link>
          <h1 className="text-2xl font-bold">Chi tiết đơn hàng</h1>
        </div>

        {isLoading ? (
          <div className="flex justify-center py-8">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-500"></div>
          </div>
        ) : !order ? (
          <div className="bg-white p-6 rounded-lg shadow-sm text-center py-12">
            <h2 className="text-xl font-medium text-gray-900 mb-4">Không tìm thấy đơn hàng</h2>
            <p className="text-gray-500 mb-6">Đơn hàng này không tồn tại hoặc bạn không có quyền truy cập</p>
            <Link
              href="/account/orders"
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
            >
              Quay lại danh sách đơn hàng
            </Link>
          </div>
        ) : (
          <>
            {/* Order summary */}
            <div className="bg-white p-6 rounded-lg shadow-sm mb-8">
              <div className="flex flex-col md:flex-row md:justify-between md:items-center">
                <div>
                  <h2 className="text-lg font-medium text-gray-900">
                    Đơn hàng #{order.id.substring(0, 8)}
                  </h2>
                  <p className="mt-1 text-sm text-gray-500">
                    Đặt ngày {format(new Date(order.createdAt), 'dd/MM/yyyy HH:mm')}
                  </p>
                </div>
                <div className="mt-4 md:mt-0 flex flex-col md:items-end">
                  <div className="flex space-x-2 mb-2">
                    <Badge className={getStatusColor(order.status)}>
                      {order.status}
                    </Badge>
                    <Badge className={getPaymentStatusColor(order.paymentStatus)}>
                      {order.paymentStatus}
                    </Badge>
                  </div>
                  {order.status === OrderStatus.PENDING && (
                    <button
                      onClick={handleCancelOrder}
                      disabled={isCancelling}
                      className="mt-2 inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 disabled:bg-red-300"
                    >
                      {isCancelling ? 'Đang hủy...' : 'Hủy đơn hàng'}
                    </button>
                  )}
                </div>
              </div>
            </div>

            {/* Order items */}
            <div className="bg-white p-6 rounded-lg shadow-sm mb-8">
              <h3 className="text-lg font-medium text-gray-900 mb-4">Sản phẩm</h3>
              <div className="border-t border-gray-200 pt-4">
                <ul className="divide-y divide-gray-200">
                  {order.items.map((item, index) => (
                    <li key={item.id || index} className="py-4 flex">
                      {item.image && (
                        <div className="h-20 w-20 flex-shrink-0 overflow-hidden rounded-md border border-gray-200 mr-4">
                          <Image
                            src={item.image}
                            alt={item.name || 'Product image'}
                            width={80}
                            height={80}
                            className="h-full w-full object-cover object-center"
                          />
                        </div>
                      )}
                      <div className="flex flex-1 flex-col">
                        <div>
                          <div className="flex justify-between text-base font-medium text-gray-900">
                            <h4>
                              {item.name || `Sản phẩm #${item.productId.substring(0, 8)}`}
                            </h4>
                            <p className="ml-4">${item.price.toFixed(2)}</p>
                          </div>
                        </div>
                        <div className="flex flex-1 items-end justify-between text-sm">
                          <p className="text-gray-500">SL: {item.quantity}</p>
                          <p className="text-gray-500">
                            Tổng: ${(item.price * item.quantity).toFixed(2)}
                          </p>
                        </div>
                      </div>
                    </li>
                  ))}
                </ul>
                <div className="border-t border-gray-200 pt-4 mt-4">
                  <div className="flex justify-between text-base font-medium text-gray-900">
                    <p>Tổng cộng</p>
                    <p>${order.totalAmount.toFixed(2)}</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Shipping address */}
            <div className="bg-white p-6 rounded-lg shadow-sm mb-8">
              <h3 className="text-lg font-medium text-gray-900 mb-4">Thông tin giao hàng</h3>
              <div className="border-t border-gray-200 pt-4">
                <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
                  <div>
                    <dt className="text-sm font-medium text-gray-500">Tên người nhận</dt>
                    <dd className="mt-1 text-sm text-gray-900">
                      {order.shippingAddress.firstName} {order.shippingAddress.lastName}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-sm font-medium text-gray-500">Số điện thoại</dt>
                    <dd className="mt-1 text-sm text-gray-900">
                      {order.shippingAddress.phone}
                    </dd>
                  </div>
                  <div className="sm:col-span-2">
                    <dt className="text-sm font-medium text-gray-500">Địa chỉ</dt>
                    <dd className="mt-1 text-sm text-gray-900">
                      {order.shippingAddress.address}, {order.shippingAddress.city}, {order.shippingAddress.postalCode}, {order.shippingAddress.country}
                    </dd>
                  </div>
                </dl>
              </div>
            </div>

            {/* Payment information */}
            <div className="bg-white p-6 rounded-lg shadow-sm">
              <h3 className="text-lg font-medium text-gray-900 mb-4">Thông tin thanh toán</h3>
              <div className="border-t border-gray-200 pt-4">
                <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
                  <div>
                    <dt className="text-sm font-medium text-gray-500">Phương thức thanh toán</dt>
                    <dd className="mt-1 text-sm text-gray-900">
                      {order.paymentMethod === 'credit_card' ? 'Thẻ tín dụng/ghi nợ' : 
                       order.paymentMethod === 'cod' ? 'Thanh toán khi nhận hàng' :
                       order.paymentMethod === 'bank_transfer' ? 'Chuyển khoản ngân hàng' :
                       order.paymentMethod}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-sm font-medium text-gray-500">Trạng thái thanh toán</dt>
                    <dd className="mt-1 text-sm text-gray-900">
                      <Badge className={getPaymentStatusColor(order.paymentStatus)}>
                        {order.paymentStatus}
                      </Badge>
                    </dd>
                  </div>
                </dl>
              </div>
            </div>
          </>
        )}
      </div>
    </Layout>
  );
}
