import React from 'react';
import { useRouter } from 'next/router';
import toast from 'react-hot-toast';
import { ScaleIcon } from '@heroicons/react/outline';

interface CompareButtonProps {
  productId: string;
}

export default function CompareButton({ productId }: CompareButtonProps) {
  const router = useRouter();
  
  // Function to get compare products array from localStorage
  const getCompareProducts = (): string[] => {
    if (typeof window === 'undefined') return [];
    
    const compareItems = localStorage.getItem('compareProducts');
    return compareItems ? JSON.parse(compareItems) : [];
  };
  
  // Function to add product to compare list
  const addToCompare = () => {
    const compareProducts = getCompareProducts();
    
    // Check if product is already in compare list
    if (compareProducts.includes(productId)) {
      toast('Sản phẩm đã có trong danh sách so sánh', {
        icon: '⚠️',
      });
      return;
    }
    
    // Limit to 4 products max
    if (compareProducts.length >= 4) {
      toast.error('Chỉ có thể so sánh tối đa 4 sản phẩm');
      return;
    }
    
    // Add product to compare list
    const updatedCompareProducts = [...compareProducts, productId];
    localStorage.setItem('compareProducts', JSON.stringify(updatedCompareProducts));
    
    toast.success('Đã thêm sản phẩm vào danh sách so sánh');
    
    // If there are at least 2 products, show compare now option
    if (updatedCompareProducts.length >= 2) {
      toast((t) => (
        <div className="flex flex-col">
          <span>Đã có {updatedCompareProducts.length} sản phẩm để so sánh</span>
          <button
            className="mt-2 bg-indigo-600 hover:bg-indigo-700 text-white py-1 px-3 rounded text-sm"
            onClick={() => {
              toast.dismiss(t.id);
              router.push(`/compare?ids=${updatedCompareProducts.join(',')}`);
            }}
          >
            So sánh ngay
          </button>
        </div>
      ), {
        duration: 5000,
      });
    }
  };
  
  const isInCompareList = () => {
    const compareProducts = getCompareProducts();
    return compareProducts.includes(productId);
  };
  
  return (
    <button
      onClick={addToCompare}
      className={`flex items-center justify-center p-2 rounded-md text-sm font-medium ${
        isInCompareList() ? 'bg-gray-100 text-gray-700' : 'text-gray-700 hover:bg-gray-100'
      }`}
      title="Thêm vào danh sách so sánh"
    >
      <ScaleIcon className="h-5 w-5 mr-1" />
      {isInCompareList() ? 'Đã thêm để so sánh' : 'So sánh'}
    </button>
  );
}
