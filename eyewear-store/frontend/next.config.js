/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  output: 'standalone',
  images: {
    domains: [
      'localhost',
      'eyewear-store.vn',
      'images.unsplash.com',
      'via.placeholder.com',
    ],
  },
  // Chấp nhận tên host từ biến môi trường nếu có
  ...(process.env.NEXT_PUBLIC_HOST_URL
    ? {
        assetPrefix: process.env.NEXT_PUBLIC_HOST_URL,
      }
    : {}),
};

module.exports = nextConfig;
