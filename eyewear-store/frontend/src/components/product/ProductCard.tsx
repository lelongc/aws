import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { HeartIcon as HeartOutline } from '@heroicons/react/24/outline';
import { HeartIcon as HeartSolid } from '@heroicons/react/24/solid';
import { Product } from '@eyewear-store/shared/types';
import { useWishlistStore } from '@/store/wishlistStore';
import toast from 'react-hot-toast';

interface ProductCardProps {
  product: Product;
}

export default function ProductCard({ product }: ProductCardProps) {
  // Get primary image or fallback
  const imageUrl = product.images?.length > 0 
    ? product.images.find(img => img.isPrimary)?.url || product.images[0]?.url 
    : '/images/placeholder.jpg';
  
  // Calculate discount percentage
  const discount = product.discountPrice && product.price > product.discountPrice
    ? Math.round(((product.price - product.discountPrice) / product.price) * 100)
    : 0;
    
  // Wishlist functionality
  const { addItem, removeItem, isInWishlist } = useWishlistStore();
  const inWishlist = isInWishlist(product.id);
  
  const handleWishlistToggle = (e: React.MouseEvent) => {
    e.preventDefault(); // Prevent navigation to product detail
    e.stopPropagation();
    
    if (inWishlist) {
      removeItem(product.id);
      toast.success('Đã xóa khỏi danh sách yêu thích');
    } else {
      addItem(product);
      toast.success('Đã thêm vào danh sách yêu thích');
    }
  };
  
  return (
    <Link href={`/products/${product.id}`}>
      <div className="group relative border border-gray-200 rounded-lg overflow-hidden transition-all hover:shadow-lg">
        {/* Product Image */}
        <div className="aspect-square overflow-hidden bg-gray-100 relative">
          <Image
            src={imageUrl}
            alt={product.name}
            width={400}
            height={400}
            className="object-cover w-full h-full group-hover:scale-105 transition-transform duration-300"
          />
          
          {/* Wishlist button */}
          <button 
            onClick={handleWishlistToggle}
            className="absolute top-2 right-2 bg-white rounded-full p-1.5 shadow-sm hover:scale-110 transition-transform"
          >
            {inWishlist ? (
              <HeartSolid className="h-5 w-5 text-red-500" />
            ) : (
              <HeartOutline className="h-5 w-5 text-gray-400" />
            )}
          </button>
        </div>
        
        {/* Discount Badge */}
        {discount > 0 && (
          <div className="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 text-xs font-semibold rounded">
            {discount}% OFF
          </div>
        )}
        
        {/* Product Info */}
        <div className="p-4">
          {/* Brand */}
          {product.brand && (
            <p className="text-sm text-gray-500 mb-1">{product.brand.name}</p>
          )}
          
          {/* Product Name */}
          <h3 className="text-lg font-medium text-gray-900 truncate">
            {product.name}
          </h3>
          
          {/* Price */}
          <div className="mt-2 flex items-center">
            {product.discountPrice ? (
              <>
                <span className="text-lg font-semibold text-gray-900">${product.discountPrice.toFixed(2)}</span>
                <span className="ml-2 text-sm text-gray-500 line-through">${product.price.toFixed(2)}</span>
              </>
            ) : (
              <span className="text-lg font-semibold text-gray-900">${product.price.toFixed(2)}</span>
            )}
          </div>
        </div>
      </div>
    </Link>
  );
}
