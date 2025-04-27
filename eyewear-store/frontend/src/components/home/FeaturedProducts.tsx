import React from 'react';
import Link from 'next/link';
import ProductCard from '../product/ProductCard';
import { Product } from '@eyewear-store/shared/types';
import { ArrowRightIcon } from '@heroicons/react/24/outline';

interface FeaturedProductsProps {
  products: Product[];
}

export default function FeaturedProducts({ products }: FeaturedProductsProps) {
  if (!products || products.length === 0) {
    return null;
  }

  return (
    <section className="bg-white py-16">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl font-bold text-gray-900">Sản phẩm nổi bật</h2>
          <Link
            href="/products"
            className="text-indigo-600 hover:text-indigo-500 flex items-center"
          >
            Xem tất cả
            <ArrowRightIcon className="ml-2 h-5 w-5" aria-hidden="true" />
          </Link>
        </div>
        
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {products.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      </div>
    </section>
  );
}
