import React from 'react';
import Link from 'next/link';
import Layout from '@/components/layout/Layout';

export default function NotFound() {
  return (
    <Layout title="Không tìm thấy trang | Eyewear Store">
      <div className="min-h-[70vh] flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-lg w-full space-y-8 text-center">
          <div>
            <h1 className="text-9xl font-extrabold text-indigo-600">404</h1>
            <h2 className="mt-6 text-3xl font-bold text-gray-900">
              Không tìm thấy trang
            </h2>
            <p className="mt-2 text-base text-gray-500">
              Xin lỗi, trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.
            </p>
          </div>
          <div className="flex flex-wrap justify-center gap-4">
            <Link
              href="/"
              className="px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Trở về trang chủ
            </Link>
            <Link
              href="/products"
              className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-base font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Xem sản phẩm
            </Link>
          </div>
          <div className="mt-6">
            <p className="text-sm text-gray-500">
              Nếu bạn tin rằng đây là lỗi, vui lòng{' '}
              <Link href="/contact" className="font-medium text-indigo-600 hover:text-indigo-500">
                liên hệ với chúng tôi
              </Link>
            </p>
          </div>
        </div>
      </div>
    </Layout>
  );
}
