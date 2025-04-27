import React, { useState } from 'react';
import toast from 'react-hot-toast';

interface CouponFormProps {
  onApply: (code: string) => Promise<boolean>;
  appliedCoupon: string | null;
}

export default function CouponForm({ onApply, appliedCoupon }: CouponFormProps) {
  const [couponCode, setCouponCode] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleApplyCoupon = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!couponCode.trim()) return;
    
    setIsLoading(true);
    try {
      const success = await onApply(couponCode);
      if (success) {
        toast.success('Mã giảm giá đã được áp dụng');
        setCouponCode('');
      } else {
        toast.error('Mã giảm giá không hợp lệ hoặc đã hết hạn');
      }
    } catch (error) {
      toast.error('Có lỗi xảy ra khi áp dụng mã giảm giá');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="mt-4">
      <h3 className="text-sm font-medium text-gray-900 mb-2">Mã giảm giá</h3>
      
      {appliedCoupon ? (
        <div className="flex items-center justify-between bg-green-50 border border-green-200 rounded-md p-3">
          <div className="flex items-center">
            <span className="inline-flex items-center justify-center h-6 w-6 rounded-full bg-green-100 text-green-500 mr-2">
              ✓
            </span>
            <span className="text-sm text-green-700">
              Đã áp dụng mã <span className="font-medium">{appliedCoupon}</span>
            </span>
          </div>
          <button
            type="button"
            onClick={() => onApply('')}
            className="text-sm text-gray-500 hover:text-gray-700"
          >
            Hủy
          </button>
        </div>
      ) : (
        <form onSubmit={handleApplyCoupon} className="flex space-x-2">
          <input
            type="text"
            value={couponCode}
            onChange={(e) => setCouponCode(e.target.value)}
            placeholder="Nhập mã giảm giá"
            className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          />
          <button
            type="submit"
            disabled={isLoading || !couponCode.trim()}
            className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
          >
            {isLoading ? 'Đang áp dụng...' : 'Áp dụng'}
          </button>
        </form>
      )}
    </div>
  );
}
