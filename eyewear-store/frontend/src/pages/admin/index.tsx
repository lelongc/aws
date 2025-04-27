import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';
import Layout from '@/components/admin/AdminLayout';
import { useAuthStore } from '@/store/authStore';
import { 
  ShoppingBagIcon, 
  UsersIcon, 
  CurrencyDollarIcon, 
  ChartBarIcon 
} from '@heroicons/react/24/outline';

// Mock dashboard data - in a real app, fetch this from API
const dashboardData = {
  totalSales: 45890.75,
  totalOrders: 267,
  totalUsers: 589,
  conversionRate: 3.2,
  recentOrders: [
    { id: 'ORD1234', customer: 'Nguyễn Văn A', date: '2023-10-15', total: 289.99, status: 'completed' },
    { id: 'ORD1235', customer: 'Trần Thị B', date: '2023-10-15', total: 129.50, status: 'processing' },
    { id: 'ORD1236', customer: 'Lê Văn C', date: '2023-10-14', total: 459.99, status: 'completed' },
    { id: 'ORD1237', customer: 'Phạm Thị D', date: '2023-10-14', total: 59.99, status: 'pending' },
    { id: 'ORD1238', customer: 'Hoàng Văn E', date: '2023-10-13', total: 199.99, status: 'shipped' },
  ],
  topProducts: [
    { id: 'P1', name: 'Kính Ray-Ban Aviator', sales: 42, revenue: 7580 },
    { id: 'P2', name: 'Kính Gucci GG0341S', sales: 38, revenue: 9500 },
    { id: 'P3', name: 'Kính Oakley Holbrook', sales: 35, revenue: 5250 },
    { id: 'P4', name: 'Kính Polaroid PLD 6762/G/CS', sales: 30, revenue: 3750 },
    { id: 'P5', name: 'Kính Dolce & Gabbana DG2220', sales: 25, revenue: 6875 },
  ]
};

export default function AdminDashboard() {
  const router = useRouter();
  const { user, isAuthenticated } = useAuthStore();
  
  useEffect(() => {
    // Check if user is admin
    if (!isAuthenticated) {
      router.push('/auth/login?returnUrl=/admin');
    } else if (user?.role !== 'admin') {
      router.push('/');
    }
  }, [isAuthenticated, user, router]);

  if (!isAuthenticated || user?.role !== 'admin') {
    return (
      <Layout title="Admin Dashboard">
        <div className="flex justify-center items-center h-screen">
          <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-500"></div>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title="Admin Dashboard">
      <div className="py-6">
        <h1 className="text-2xl font-semibold text-gray-900">Dashboard</h1>
        
        {/* Stats cards */}
        <div className="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0 bg-indigo-500 rounded-md p-3">
                  <CurrencyDollarIcon className="h-6 w-6 text-white" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Doanh thu
                    </dt>
                    <dd>
                      <div className="text-lg font-medium text-gray-900">
                        ${dashboardData.totalSales.toLocaleString()}
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div className="bg-gray-50 px-5 py-3">
              <div className="text-sm">
                <Link href="/admin/sales" className="font-medium text-indigo-600 hover:text-indigo-500">
                  Xem chi tiết
                </Link>
              </div>
            </div>
          </div>

          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0 bg-green-500 rounded-md p-3">
                  <ShoppingBagIcon className="h-6 w-6 text-white" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Đơn hàng
                    </dt>
                    <dd>
                      <div className="text-lg font-medium text-gray-900">
                        {dashboardData.totalOrders}
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div className="bg-gray-50 px-5 py-3">
              <div className="text-sm">
                <Link href="/admin/orders" className="font-medium text-indigo-600 hover:text-indigo-500">
                  Xem chi tiết
                </Link>
              </div>
            </div>
          </div>

          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0 bg-yellow-500 rounded-md p-3">
                  <UsersIcon className="h-6 w-6 text-white" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Người dùng
                    </dt>
                    <dd>
                      <div className="text-lg font-medium text-gray-900">
                        {dashboardData.totalUsers}
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div className="bg-gray-50 px-5 py-3">
              <div className="text-sm">
                <Link href="/admin/users" className="font-medium text-indigo-600 hover:text-indigo-500">
                  Xem chi tiết
                </Link>
              </div>
            </div>
          </div>

          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0 bg-red-500 rounded-md p-3">
                  <ChartBarIcon className="h-6 w-6 text-white" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Tỷ lệ chuyển đổi
                    </dt>
                    <dd>
                      <div className="text-lg font-medium text-gray-900">
                        {dashboardData.conversionRate}%
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div className="bg-gray-50 px-5 py-3">
              <div className="text-sm">
                <Link href="/admin/analytics" className="font-medium text-indigo-600 hover:text-indigo-500">
                  Xem chi tiết
                </Link>
              </div>
            </div>
          </div>
        </div>

        {/* Recent Orders */}
        <div className="mt-8">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-medium text-gray-900">Đơn hàng gần đây</h2>
            <Link href="/admin/orders" className="text-sm font-medium text-indigo-600 hover:text-indigo-500">
              Xem tất cả
            </Link>
          </div>
          <div className="mt-4 bg-white shadow overflow-hidden sm:rounded-md">
            <ul className="divide-y divide-gray-200">
              {dashboardData.recentOrders.map((order) => (
                <li key={order.id}>
                  <Link href={`/admin/orders/${order.id}`} className="block hover:bg-gray-50">
                    <div className="px-4 py-4 flex items-center sm:px-6">
                      <div className="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
                        <div>
                          <div className="flex text-sm">
                            <p className="font-medium text-indigo-600 truncate">{order.id}</p>
                            <p className="ml-1 flex-shrink-0 font-normal text-gray-500">
                              từ {order.customer}
                            </p>
                          </div>
                          <div className="mt-2 flex">
                            <div className="flex items-center text-sm text-gray-500">
                              <p>
                                Đặt ngày <time dateTime={order.date}>{order.date}</time>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div className="mt-4 flex-shrink-0 sm:mt-0 sm:ml-5">
                          <div className="flex items-center justify-between">
                            <p className="text-sm font-medium text-gray-900 mr-6">${order.total}</p>
                            <div className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                              order.status === 'completed' ? 'bg-green-100 text-green-800' :
                              order.status === 'processing' ? 'bg-yellow-100 text-yellow-800' :
                              order.status === 'shipped' ? 'bg-blue-100 text-blue-800' :
                              'bg-gray-100 text-gray-800'
                            }`}>
                              {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Top Products */}
        <div className="mt-8">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-medium text-gray-900">Sản phẩm bán chạy</h2>
            <Link href="/admin/products" className="text-sm font-medium text-indigo-600 hover:text-indigo-500">
              Xem tất cả
            </Link>
          </div>
          <div className="mt-4 bg-white shadow overflow-hidden sm:rounded-md">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Sản phẩm
                  </th>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Đã bán
                  </th>
                  <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Doanh thu
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {dashboardData.topProducts.map((product) => (
                  <tr key={product.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      <Link href={`/admin/products/${product.id}`} className="text-indigo-600 hover:text-indigo-900">
                        {product.name}
                      </Link>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {product.sales} cái
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      ${product.revenue.toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </Layout>
  );
}
