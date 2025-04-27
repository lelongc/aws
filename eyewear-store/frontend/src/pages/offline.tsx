import React from 'react';
import Link from 'next/link';
import Layout from '@/components/layout/Layout';
import { WifiOffIcon } from '@heroicons/react/outline';

export default function OfflinePage() {
  return (
    <Layout title="Offline | Eyewear Store">
      <div className="min-h-[70vh] flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-lg w-full space-y-8 text-center">
          <div>
            <WifiOffIcon className="mx-auto h-16 w-16 text-gray-400" />
            <h1 className="mt-6 text-3xl font-extrabold text-gray-900">
              Bạn đang ngoại tuyến
            </h1>
            <p className="mt-2 text-base text-gray-500">
              Có vẻ như bạn đã mất kết nối internet. Vui lòng kiểm tra lại kết nối và thử lại.
            </p>
          </div>
          <div className="flex justify-center">
            <button
              onClick={() => window.location.reload()}
              className="px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Thử lại
            </button>
          </div>
        </div>
      </div>
    </Layout>
  );
}
