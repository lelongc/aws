import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import Layout from '@/components/layout/Layout';
import { SearchIcon } from '@heroicons/react/outline';

// Mock blog posts data (in a real app would come from API/CMS)
const blogPosts = [
  {
    id: '1',
    title: 'Cách chọn kính phù hợp với khuôn mặt',
    description: 'Hướng dẫn chi tiết giúp bạn chọn được mắt kính phù hợp nhất với hình dáng khuôn mặt của mình.',
    image: '/images/blog/face-shape-guide.jpg',
    category: 'Hướng dẫn',
    date: '2023-10-01',
    author: 'Ngọc Anh',
    readTime: 5
  },
  {
    id: '2',
    title: 'Xu hướng kính mắt 2023',
    description: 'Những xu hướng kính mắt đang thịnh hành trong năm 2023 mà bạn không nên bỏ lỡ.',
    image: '/images/blog/trend-2023.jpg',
    category: 'Xu hướng',
    date: '2023-09-15',
    author: 'Minh Tuấn',
    readTime: 7
  },
  {
    id: '3',
    title: 'Cách bảo quản kính mắt đúng cách',
    description: 'Những mẹo đơn giản nhưng hiệu quả giúp kính mắt của bạn luôn như mới và kéo dài tuổi thọ.',
    image: '/images/blog/eyewear-care.jpg',
    category: 'Chăm sóc',
    date: '2023-08-22',
    author: 'Thanh Tâm',
    readTime: 4
  },
  {
    id: '4',
    title: 'Kính râm: Không chỉ là thời trang mà còn bảo vệ mắt',
    description: 'Tìm hiểu về tầm quan trọng của kính râm trong việc bảo vệ mắt khỏi tia UV và các tác hại từ ánh nắng mặt trời.',
    image: '/images/blog/sunglasses-protection.jpg',
    category: 'Sức khỏe',
    date: '2023-08-10',
    author: 'Bác sĩ Hoàng Nam',
    readTime: 6
  },
  {
    id: '5',
    title: 'Lịch sử phát triển của kính mắt qua các thời kỳ',
    description: 'Hành trình phát triển thú vị của kính mắt từ khi ra đời đến những thiết kế hiện đại ngày nay.',
    image: '/images/blog/glasses-history.jpg',
    category: 'Kiến thức',
    date: '2023-07-28',
    author: 'Hà Linh',
    readTime: 8
  },
  {
    id: '6',
    title: 'Kính đa tròng - Giải pháp cho người cận thị và lão thị',
    description: 'Tìm hiểu về ưu điểm và nhược điểm của kính đa tròng, ai nên sử dụng và cách làm quen với loại kính này.',
    image: '/images/blog/multifocal-glasses.jpg',
    category: 'Sức khỏe',
    date: '2023-07-15',
    author: 'Bác sĩ Minh Đức',
    readTime: 5
  },
];

// Categories for filtering
const categories = [
  'Tất cả',
  'Hướng dẫn',
  'Xu hướng',
  'Chăm sóc',
  'Sức khỏe',
  'Kiến thức',
];

export default function BlogPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('Tất cả');

  const filteredPosts = blogPosts.filter((post) => {
    const matchesSearch = post.title.toLowerCase().includes(searchTerm.toLowerCase()) || 
                         post.description.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesCategory = selectedCategory === 'Tất cả' || post.category === selectedCategory;
    
    return matchesSearch && matchesCategory;
  });

  return (
    <Layout title="Blog - Eyewear Store">
      <div className="bg-white">
        <div className="container mx-auto px-4 py-16">
          <h1 className="text-3xl font-bold text-center text-gray-900 mb-4">Blog</h1>
          <p className="text-lg text-center text-gray-600 max-w-2xl mx-auto mb-12">
            Khám phá những bài viết, hướng dẫn và mẹo hữu ích về kính mắt, chăm sóc mắt và xu hướng thời trang.
          </p>

          <div className="flex flex-col md:flex-row gap-8 mb-12">
            {/* Search and filter */}
            <div className="md:w-1/3 space-y-6">
              {/* Search */}
              <div>
                <h2 className="text-lg font-medium text-gray-900 mb-4">Tìm kiếm</h2>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <SearchIcon className="h-5 w-5 text-gray-400" />
                  </div>
                  <input
                    type="text"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    placeholder="Tìm kiếm bài viết..."
                    className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  />
                </div>
              </div>

              {/* Categories */}
              <div>
                <h2 className="text-lg font-medium text-gray-900 mb-4">Danh mục</h2>
                <div className="space-y-2">
                  {categories.map((category) => (
                    <button
                      key={category}
                      onClick={() => setSelectedCategory(category)}
                      className={`block w-full text-left px-3 py-2 rounded-md ${
                        selectedCategory === category
                          ? 'bg-indigo-100 text-indigo-800'
                          : 'text-gray-700 hover:bg-gray-100'
                      }`}
                    >
                      {category}
                    </button>
                  ))}
                </div>
              </div>

              {/* Recent posts (for mobile, shown at bottom) */}
              <div className="md:block">
                <h2 className="text-lg font-medium text-gray-900 mb-4">Bài viết gần đây</h2>
                <div className="space-y-4">
                  {blogPosts.slice(0, 3).map((post) => (
                    <Link key={post.id} href={`/blog/${post.id}`}>
                      <div className="group flex items-start space-x-3">
                        <div className="flex-shrink-0 relative w-16 h-16">
                          <Image
                            src={post.image}
                            alt={post.title}
                            fill
                            className="object-cover rounded-md"
                          />
                        </div>
                        <div>
                          <h3 className="text-sm font-medium text-gray-900 group-hover:text-indigo-600">
                            {post.title}
                          </h3>
                          <p className="text-xs text-gray-500 mt-1">
                            {post.date}
                          </p>
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              </div>
            </div>

            {/* Blog posts */}
            <div className="md:w-2/3">
              {filteredPosts.length === 0 ? (
                <div className="text-center py-12 bg-gray-50 rounded-lg">
                  <p className="text-lg text-gray-600">Không tìm thấy bài viết phù hợp.</p>
                  <button
                    onClick={() => {
                      setSearchTerm('');
                      setSelectedCategory('Tất cả');
                    }}
                    className="mt-4 text-indigo-600 hover:text-indigo-800"
                  >
                    Xóa bộ lọc
                  </button>
                </div>
              ) : (
                <div className="grid md:grid-cols-2 gap-8">
                  {filteredPosts.map((post) => (
                    <Link key={post.id} href={`/blog/${post.id}`}>
                      <div className="group flex flex-col bg-white rounded-lg overflow-hidden shadow-sm border border-gray-200 hover:shadow-md transition-shadow">
                        <div className="relative h-48 w-full">
                          <Image
                            src={post.image}
                            alt={post.title}
                            fill
                            className="object-cover"
                          />
                          <div className="absolute top-4 left-4 bg-white py-1 px-2 rounded text-xs font-medium text-indigo-600">
                            {post.category}
                          </div>
                        </div>
                        <div className="p-4 flex-1 flex flex-col">
                          <h2 className="text-lg font-semibold text-gray-900 group-hover:text-indigo-600">
                            {post.title}
                          </h2>
                          <p className="mt-2 text-sm text-gray-600 flex-grow">
                            {post.description}
                          </p>
                          <div className="mt-4 flex justify-between items-center text-sm text-gray-500">
                            <span>{post.date}</span>
                            <span>{post.readTime} phút đọc</span>
                          </div>
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
