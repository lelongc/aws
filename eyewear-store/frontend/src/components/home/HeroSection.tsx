import React from 'react';
import Link from 'next/link';
import Image from 'next/image';

export default function HeroSection() {
  return (
    <div className="relative bg-gray-900">
      {/* Background image */}
      <div className="absolute inset-0 overflow-hidden">
        <Image
          src="/images/hero-bg.jpg"
          alt="Stylish glasses collection"
          fill
          priority
          className="object-cover w-full h-full opacity-60"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-gray-900 via-gray-900/70 to-transparent" />
      </div>
      
      {/* Hero content */}
      <div className="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8">
        <div className="max-w-lg">
          <h1 className="text-4xl font-bold tracking-tight text-white sm:text-5xl lg:text-6xl">
            Nhìn thế giới qua góc nhìn mới
          </h1>
          <p className="mt-6 text-xl text-gray-300">
            Khám phá bộ sưu tập kính mắt cao cấp với thiết kế hiện đại và công nghệ bảo vệ mắt tiên tiến.
          </p>
          <div className="mt-10 flex flex-col sm:flex-row gap-4">
            <Link
              href="/products?category=eyeglasses"
              className="inline-block bg-indigo-600 border border-transparent rounded-md py-3 px-8 font-medium text-white hover:bg-indigo-700 text-center"
            >
              Kính mắt
            </Link>
            <Link
              href="/products?category=sunglasses"
              className="inline-block bg-white border border-transparent rounded-md py-3 px-8 font-medium text-indigo-600 hover:bg-gray-100 text-center"
            >
              Kính râm
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
