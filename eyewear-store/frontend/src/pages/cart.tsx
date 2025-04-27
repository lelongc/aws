import React from 'react';
import Link from 'next/link';
import Layout from '@/components/layout/Layout';
import CartItem from '@/components/cart/CartItem';
import { useCartStore } from '@/store/cartStore';
import { ShoppingBagIcon, ArrowRightIcon } from '@heroicons/react/24/outline';

export default function CartPage() {
  const { items, totalItems, totalPrice, updateItemQuantity, removeItem } = useCartStore();

  return (
    <Layout title="Shopping Cart | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Shopping Cart</h1>

        {items.length > 0 ? (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
            {/* Cart items */}
            <div className="lg:col-span-8">
              {items.map((item) => (
                <CartItem
                  key={item.id}
                  item={item}
                  updateQuantity={updateItemQuantity}
                  removeItem={removeItem}
                />
              ))}
            </div>

            {/* Order summary */}
            <div className="lg:col-span-4">
              <div className="bg-gray-50 rounded-lg p-6 shadow-sm">
                <h2 className="text-lg font-medium text-gray-900 mb-4">Order Summary</h2>
                <div className="space-y-4">
                  <div className="flex justify-between">
                    <p className="text-gray-600">Subtotal</p>
                    <p className="text-gray-900 font-medium">${totalPrice.toFixed(2)}</p>
                  </div>
                  <div className="flex justify-between">
                    <p className="text-gray-600">Shipping</p>
                    <p className="text-gray-900 font-medium">Calculated at checkout</p>
                  </div>
                  <div className="flex justify-between">
                    <p className="text-gray-600">Tax</p>
                    <p className="text-gray-900 font-medium">Calculated at checkout</p>
                  </div>
                  <div className="border-t border-gray-200 pt-4">
                    <div className="flex justify-between text-lg font-medium">
                      <p className="text-gray-900">Total</p>
                      <p className="text-gray-900">${totalPrice.toFixed(2)}</p>
                    </div>
                    <p className="text-gray-500 text-sm mt-1">Shipping and taxes calculated at checkout</p>
                  </div>
                </div>
                <div className="mt-6">
                  <Link 
                    href="/checkout" 
                    className="w-full bg-indigo-600 border border-transparent rounded-md py-3 px-8 flex items-center justify-center text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                  >
                    Proceed to Checkout
                    <ArrowRightIcon className="ml-2 h-5 w-5" />
                  </Link>
                </div>
                <div className="mt-4">
                  <Link 
                    href="/products" 
                    className="text-indigo-600 hover:text-indigo-500 flex items-center justify-center text-sm"
                  >
                    Continue Shopping
                  </Link>
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="text-center py-16">
            <ShoppingBagIcon className="mx-auto h-16 w-16 text-gray-400" />
            <h2 className="mt-4 text-2xl font-medium text-gray-900">Your cart is empty</h2>
            <p className="mt-2 text-gray-500">Looks like you haven't added any items to your cart yet.</p>
            <div className="mt-6">
              <Link
                href="/products"
                className="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Start Shopping
              </Link>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
