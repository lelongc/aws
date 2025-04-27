import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import Layout from '@/components/layout/Layout';
import { useWishlistStore } from '@/store/wishlistStore';
import { useCartStore } from '@/store/cartStore';
import { HeartIcon, ShoppingBagIcon, TrashIcon } from '@heroicons/react/24/outline';
import toast from 'react-hot-toast';

export default function WishlistPage() {
  const { items, removeItem, clearWishlist } = useWishlistStore();
  const { addItem } = useCartStore();
  
  const handleAddToCart = (item: any) => {
    addItem({
      id: item.id,
      name: item.name,
      price: item.price,
      image: item.image,
      quantity: 1,
    });
    toast.success('Sản phẩm đã được thêm vào giỏ hàng');
  };
  
  const handleRemoveFromWishlist = (id: string) => {
    removeItem(id);
    toast.success('Đã xóa khỏi danh sách yêu thích');
  };

  return (
    <Layout title="Danh sách yêu thích | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Danh sách yêu thích</h1>

        {items.length === 0 ? (
          <div className="text-center py-16 bg-white rounded-lg shadow-sm">
            <HeartIcon className="mx-auto h-16 w-16 text-gray-400" />
            <h2 className="mt-4 text-2xl font-medium text-gray-900">Chưa có sản phẩm yêu thích</h2>
            <p className="mt-2 text-gray-500">Hãy thêm các sản phẩm yêu thích để dễ dàng theo dõi và mua sắm sau này.</p>
            <div className="mt-6">
              <Link
                href="/products"
                className="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Tiếp tục mua sắm
              </Link>
            </div>
          </div>
        ) : (
          <>
            <div className="flex justify-end mb-4">
              <button
                onClick={() => clearWishlist()}
                className="text-sm text-gray-600 hover:text-red-600 flex items-center"
              >
                <TrashIcon className="h-4 w-4 mr-1" />
                Xóa tất cả
              </button>
            </div>

            <div className="bg-white shadow overflow-hidden sm:rounded-md">
              <ul className="divide-y divide-gray-200">
                {items.map((item) => (
                  <li key={item.id}>
                    <div className="px-4 py-4 flex items-center sm:px-6">
                      <div className="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
                        <div className="flex items-center">
                          <div className="h-20 w-20 flex-shrink-0 overflow-hidden rounded border border-gray-200 mr-4">
                            <Image
                              src={item.image}
                              alt={item.name}
                              width={80}
                              height={80}
                              className="h-full w-full object-cover object-center"
                            />
                          </div>
                          <div>
                            <Link href={`/products/${item.id}`} className="text-lg font-medium text-indigo-600 hover:text-indigo-700">
                              {item.name}
                            </Link>
                            <p className="mt-1 text-sm text-gray-500">${item.price.toFixed(2)}</p>
                          </div>
                        </div>
                      </div>
                      <div className="ml-5 flex flex-shrink-0 space-x-2">
                        <button
                          onClick={() => handleAddToCart(item)}
                          className="inline-flex items-center px-3 py-1 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        >
                          <ShoppingBagIcon className="h-4 w-4 mr-1" />
                          Thêm vào giỏ hàng
                        </button>
                        <button
                          onClick={() => handleRemoveFromWishlist(item.id)}
                          className="inline-flex items-center px-3 py-1 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none"
                        >
                          <TrashIcon className="h-4 w-4 mr-1" />
                          Xóa
                        </button>
                      </div>
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          </>
        )}
      </div>
    </Layout>
  );
}
