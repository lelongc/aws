import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import { useForm } from 'react-hook-form';
import Layout from '@/components/layout/Layout';
import { useCartStore } from '@/store/cartStore';
import { useAuthStore } from '@/store/authStore';
import { createOrder } from '@/services/api/orders';
import toast from 'react-hot-toast';
import CouponForm from '@/components/checkout/CouponForm';
import { applyCoupon } from '@/services/api/coupons';

interface CheckoutFormData {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  address: string;
  city: string;
  postalCode: string;
  country: string;
  paymentMethod: 'card' | 'cod';
  saveInfo: boolean;
}

export default function CheckoutPage() {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { register, handleSubmit, setValue, formState: { errors } } = useForm<CheckoutFormData>();
  const { items, totalPrice, clearCart } = useCartStore();
  const { user, isAuthenticated } = useAuthStore();
  const router = useRouter();
  const [appliedCoupon, setAppliedCoupon] = useState<string | null>(null);
  const [discount, setDiscount] = useState(0);

  // Redirect to cart if cart is empty
  useEffect(() => {
    if (items.length === 0) {
      router.push('/cart');
    }
  }, [items, router]);

  // Pre-fill form with user data if logged in
  useEffect(() => {
    if (user) {
      setValue('firstName', user.firstName);
      setValue('lastName', user.lastName);
      setValue('email', user.email);
    }
  }, [user, setValue]);

  const onSubmit = async (data: CheckoutFormData) => {
    if (items.length === 0) return;

    setIsSubmitting(true);
    try {
      // Convert cart items to order items format
      const orderItems = items.map((item) => ({
        productId: item.id,
        quantity: item.quantity,
        price: item.price,
      }));

      // Create order via API
      const order = await createOrder({
        items: orderItems,
        shippingAddress: {
          firstName: data.firstName,
          lastName: data.lastName,
          address: data.address,
          city: data.city,
          postalCode: data.postalCode,
          country: data.country,
          phone: data.phone,
        },
        paymentMethod: data.paymentMethod,
      });

      // Clear cart after successful order
      clearCart();
      
      // Redirect to success page
      router.push({
        pathname: '/checkout/success',
        query: { orderId: order.id }
      });
    } catch (error) {
      toast.error('Có lỗi xảy ra. Vui lòng thử lại sau.');
      console.error('Checkout error:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleApplyCoupon = async (code: string) => {
    if (!code) {
      // Remove coupon
      setAppliedCoupon(null);
      setDiscount(0);
      return true;
    }
    
    try {
      const response = await applyCoupon({ code });
      setAppliedCoupon(code);
      setDiscount(response.discountAmount);
      return true;
    } catch (error) {
      console.error('Error applying coupon:', error);
      return false;
    }
  };

  if (items.length === 0) {
    return (
      <Layout title="Thanh toán | Eyewear Store">
        <div className="container mx-auto px-4 py-8">
          <p>Đang chuyển hướng...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title="Thanh toán | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Thanh toán</h1>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          {/* Checkout Form */}
          <div className="lg:col-span-8">
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
              {/* Shipping Information Section */}
              <div className="bg-white p-6 rounded-lg shadow-sm">
                <h2 className="text-lg font-medium text-gray-900 mb-4">Thông tin giao hàng</h2>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label htmlFor="firstName" className="block text-sm font-medium text-gray-700">Họ</label>
                    <input
                      type="text"
                      id="firstName"
                      {...register('firstName', { required: 'Vui lòng nhập họ' })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    {errors.firstName && (
                      <p className="mt-1 text-sm text-red-600">{errors.firstName.message}</p>
                    )}
                  </div>
                  <div>
                    <label htmlFor="lastName" className="block text-sm font-medium text-gray-700">Tên</label>
                    <input
                      type="text"
                      id="lastName"
                      {...register('lastName', { required: 'Vui lòng nhập tên' })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    {errors.lastName && (
                      <p className="mt-1 text-sm text-red-600">{errors.lastName.message}</p>
                    )}
                  </div>
                </div>

                <div className="mt-4">
                  <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email</label>
                  <input
                    type="email"
                    id="email"
                    {...register('email', { 
                      required: 'Vui lòng nhập email',
                      pattern: {
                        value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                        message: 'Email không hợp lệ'
                      } 
                    })}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                  {errors.email && (
                    <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
                  )}
                </div>

                <div className="mt-4">
                  <label htmlFor="phone" className="block text-sm font-medium text-gray-700">Số điện thoại</label>
                  <input
                    type="tel"
                    id="phone"
                    {...register('phone', { required: 'Vui lòng nhập số điện thoại' })}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                  {errors.phone && (
                    <p className="mt-1 text-sm text-red-600">{errors.phone.message}</p>
                  )}
                </div>

                <div className="mt-4">
                  <label htmlFor="address" className="block text-sm font-medium text-gray-700">Địa chỉ</label>
                  <input
                    type="text"
                    id="address"
                    {...register('address', { required: 'Vui lòng nhập địa chỉ' })}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                  {errors.address && (
                    <p className="mt-1 text-sm text-red-600">{errors.address.message}</p>
                  )}
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                  <div>
                    <label htmlFor="city" className="block text-sm font-medium text-gray-700">Thành phố</label>
                    <input
                      type="text"
                      id="city"
                      {...register('city', { required: 'Vui lòng nhập thành phố' })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    {errors.city && (
                      <p className="mt-1 text-sm text-red-600">{errors.city.message}</p>
                    )}
                  </div>
                  <div>
                    <label htmlFor="postalCode" className="block text-sm font-medium text-gray-700">Mã bưu điện</label>
                    <input
                      type="text"
                      id="postalCode"
                      {...register('postalCode', { required: 'Vui lòng nhập mã bưu điện' })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    {errors.postalCode && (
                      <p className="mt-1 text-sm text-red-600">{errors.postalCode.message}</p>
                    )}
                  </div>
                </div>

                <div className="mt-4">
                  <label htmlFor="country" className="block text-sm font-medium text-gray-700">Quốc gia</label>
                  <select
                    id="country"
                    {...register('country', { required: 'Vui lòng chọn quốc gia' })}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  >
                    <option value="">Chọn quốc gia</option>
                    <option value="VN">Việt Nam</option>
                    <option value="US">United States</option>
                    <option value="CA">Canada</option>
                    <option value="UK">United Kingdom</option>
                  </select>
                  {errors.country && (
                    <p className="mt-1 text-sm text-red-600">{errors.country.message}</p>
                  )}
                </div>

                <div className="mt-4">
                  <div className="flex items-start">
                    <input
                      type="checkbox"
                      id="saveInfo"
                      {...register('saveInfo')}
                      className="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 mt-1"
                    />
                    <label htmlFor="saveInfo" className="ml-2 block text-sm text-gray-700">
                      Lưu thông tin cho lần sau
                    </label>
                  </div>
                </div>
              </div>

              {/* Payment Method Section */}
              <div className="bg-white p-6 rounded-lg shadow-sm">
                <h2 className="text-lg font-medium text-gray-900 mb-4">Phương thức thanh toán</h2>
                
                <div className="space-y-4">
                  <div className="flex items-center">
                    <input
                      id="payment-card"
                      name="paymentMethod"
                      type="radio"
                      value="card"
                      {...register('paymentMethod', { required: 'Vui lòng chọn phương thức thanh toán' })}
                      className="h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500"
                    />
                    <label htmlFor="payment-card" className="ml-3 block text-sm font-medium text-gray-700">
                      Thẻ tín dụng/ghi nợ
                    </label>
                  </div>
                  <div className="flex items-center">
                    <input
                      id="payment-cod"
                      name="paymentMethod"
                      type="radio"
                      value="cod"
                      {...register('paymentMethod', { required: 'Vui lòng chọn phương thức thanh toán' })}
                      className="h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500"
                    />
                    <label htmlFor="payment-cod" className="ml-3 block text-sm font-medium text-gray-700">
                      Thanh toán khi nhận hàng (COD)
                    </label>
                  </div>
                </div>
                {errors.paymentMethod && (
                  <p className="mt-1 text-sm text-red-600">{errors.paymentMethod.message}</p>
                )}
              </div>

              {/* Submit Button */}
              <div className="lg:hidden">
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full bg-indigo-600 border border-transparent rounded-md shadow-sm py-3 px-4 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
                >
                  {isSubmitting ? 'Đang xử lý...' : 'Hoàn tất đơn hàng'}
                </button>
              </div>
            </form>
          </div>

          {/* Order Summary */}
          <div className="lg:col-span-4">
            <div className="bg-gray-50 rounded-lg p-6 shadow-sm">
              <h2 className="text-lg font-medium text-gray-900 mb-4">Đơn hàng của bạn</h2>
              
              {/* Item List */}
              <div className="divide-y divide-gray-200">
                {items.map((item) => (
                  <div key={item.id} className="py-2 flex justify-between">
                    <div>
                      <p className="text-sm font-medium text-gray-900">{item.name}</p>
                      <p className="text-sm text-gray-500">SL: {item.quantity}</p>
                    </div>
                    <p className="text-sm font-medium text-gray-900">${(item.price * item.quantity).toFixed(2)}</p>
                  </div>
                ))}
              </div>

              {/* Apply coupon code */}
              <div className="border-t border-gray-200 mt-4 pt-4">
                <CouponForm onApply={handleApplyCoupon} appliedCoupon={appliedCoupon} />
              </div>

              {/* Totals */}
              <div className="border-t border-gray-200 mt-4 pt-4">
                <div className="flex justify-between">
                  <p className="text-sm text-gray-600">Tạm tính</p>
                  <p className="text-sm font-medium text-gray-900">${totalPrice.toFixed(2)}</p>
                </div>
                
                {discount > 0 && (
                  <div className="flex justify-between mt-1 text-green-600">
                    <p className="text-sm">Giảm giá</p>
                    <p className="text-sm font-medium">-${discount.toFixed(2)}</p>
                  </div>
                )}
                
                <div className="flex justify-between mt-1">
                  <p className="text-sm text-gray-600">Phí vận chuyển</p>
                  <p className="text-sm font-medium text-gray-900">$0.00</p>
                </div>
                
                <div className="flex justify-between mt-1">
                  <p className="text-sm text-gray-600">Thuế</p>
                  <p className="text-sm font-medium text-gray-900">${((totalPrice - discount) * 0.1).toFixed(2)}</p>
                </div>
                
                <div className="flex justify-between mt-4 pt-4 border-t border-gray-200">
                  <p className="text-base font-medium text-gray-900">Tổng cộng</p>
                  <p className="text-base font-medium text-gray-900">
                    ${((totalPrice - discount) * 1.1).toFixed(2)}
                  </p>
                </div>
              </div>

              {/* Submit Order Button (Desktop) */}
              <div className="mt-6 hidden lg:block">
                <button
                  type="submit"
                  form="checkout-form"
                  disabled={isSubmitting}
                  className="w-full bg-indigo-600 border border-transparent rounded-md shadow-sm py-3 px-4 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
                >
                  {isSubmitting ? 'Đang xử lý...' : 'Hoàn tất đơn hàng'}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
