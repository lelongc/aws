import React from 'react';
import { GetServerSideProps } from 'next';
import Image from 'next/image';
import Link from 'next/link';
import Layout from '@/components/layout/Layout';
import { ArrowLeftIcon, ClockIcon, UserIcon } from '@heroicons/react/outline';

// Mock blog post data
const blogPosts = [
  {
    id: '1',
    title: 'Cách chọn kính phù hợp với khuôn mặt',
    content: `
      <p>Chọn một chiếc kính phù hợp với khuôn mặt là điều quan trọng không chỉ để bạn trông đẹp hơn mà còn để bạn cảm thấy tự tin khi đeo kính. Dưới đây là hướng dẫn chi tiết giúp bạn chọn được kiểu kính phù hợp nhất với hình dáng khuôn mặt của mình.</p>
      
      <h2>Xác định hình dáng khuôn mặt</h2>
      <p>Bước đầu tiên là xác định hình dáng khuôn mặt của bạn. Có 6 hình dáng khuôn mặt phổ biến:</p>
      <ul>
        <li><strong>Mặt trái xoan:</strong> Chiều dài khuôn mặt dài hơn chiều rộng, phần trán rộng và cằm thon.</li>
        <li><strong>Mặt tròn:</strong> Chiều dài và chiều rộng khuôn mặt gần bằng nhau, má đầy đặn.</li>
        <li><strong>Mặt vuông:</strong> Trán rộng, cằm vuông vắn, xương hàm nổi rõ.</li>
        <li><strong>Mặt trái tim:</strong> Trán rộng và cằm thon nhọn.</li>
        <li><strong>Mặt kim cương:</strong> Gò má cao, trán và cằm thon nhỏ.</li>
        <li><strong>Mặt dài:</strong> Khuôn mặt dài hơn rộng nhiều, trán cao.</li>
      </ul>
    `,
    image: '/images/blog/face-shape-guide.jpg',
    category: 'Hướng dẫn',
    date: '2023-10-01',
    author: 'Ngọc Anh',
    authorTitle: 'Chuyên gia thời trang kính mắt',
    readTime: 5,
    tags: ['kính mắt', 'khuôn mặt', 'hướng dẫn', 'thời trang'],
    relatedPosts: ['2', '3']
  },
  {
    id: '2',
    title: 'Xu hướng kính mắt 2023',
    content: `Nội dung bài viết về xu hướng kính mắt 2023...`,
    image: '/images/blog/trend-2023.jpg',
    category: 'Xu hướng',
    date: '2023-09-15',
    author: 'Minh Tuấn',
    authorTitle: 'Nhà thiết kế',
    readTime: 7,
    tags: ['xu hướng', 'kính mắt', '2023', 'thời trang'],
    relatedPosts: ['1', '5']
  },
];

// Related posts data
const allBlogPosts = [
  {
    id: '1',
    title: 'Cách chọn kính phù hợp với khuôn mặt',
    description: 'Hướng dẫn chi tiết giúp bạn chọn được mắt kính phù hợp nhất với hình dáng khuôn mặt của mình.',
    image: '/images/blog/face-shape-guide.jpg',
    category: 'Hướng dẫn',
    date: '2023-10-01',
  },
  {
    id: '2',
    title: 'Xu hướng kính mắt 2023',
    description: 'Những xu hướng kính mắt đang thịnh hành trong năm 2023 mà bạn không nên bỏ lỡ.',
    image: '/images/blog/trend-2023.jpg',
    category: 'Xu hướng',
    date: '2023-09-15',
  },
  {
    id: '3',
    title: 'Cách bảo quản kính mắt đúng cách',
    description: 'Những mẹo đơn giản nhưng hiệu quả giúp kính mắt của bạn luôn như mới và kéo dài tuổi thọ.',
    image: '/images/blog/eyewear-care.jpg',
    category: 'Chăm sóc',
    date: '2023-08-22',
  },
  {
    id: '5',
    title: 'Lịch sử phát triển của kính mắt qua các thời kỳ',
    description: 'Hành trình phát triển thú vị của kính mắt từ khi ra đời đến những thiết kế hiện đại ngày nay.',
    image: '/images/blog/glasses-history.jpg',
    category: 'Kiến thức',
    date: '2023-07-28',
  },
];

interface BlogPostDetailProps {
  post: typeof blogPosts[0];
  relatedPosts: typeof allBlogPosts;
}

export default function BlogPostDetail({ post, relatedPosts }: BlogPostDetailProps) {
  if (!post) {
    return (
      <Layout title="Không tìm thấy bài viết">
        <div className="container mx-auto px-4 py-16 text-center">
          <h1 className="text-2xl font-bold text-gray-900">Bài viết không tồn tại</h1>
          <Link href="/blog" className="mt-6 inline-block text-indigo-600 hover:text-indigo-500">
            Quay lại trang blog
          </Link>
        </div>
      </Layout>
    );
  }

  return (
    <Layout 
      title={`${post.title} - Blog - Eyewear Store`}
      description={post.description || `Đọc bài viết ${post.title} trên Eyewear Store blog`}
      ogType="article"
      image={post.image}
    >
      <div className="bg-white py-8">
        <div className="container mx-auto px-4">
          <div className="mb-8">
            <Link href="/blog" className="flex items-center text-indigo-600 hover:text-indigo-500">
              <ArrowLeftIcon className="h-4 w-4 mr-1" />
              Quay lại Blog
            </Link>
          </div>

          {/* Featured image */}
          <div className="relative w-full h-80 md:h-96 rounded-lg overflow-hidden mb-8">
            <Image 
              src={post.image} 
              alt={post.title} 
              fill
              className="object-cover" 
            />
            <div className="absolute inset-0 bg-black bg-opacity-40"></div>
            <div className="absolute inset-0 flex items-center">
              <div className="w-full px-8">
                <span className="bg-indigo-600 text-white px-3 py-1 rounded-md text-sm font-medium">
                  {post.category}
                </span>
                <h1 className="text-3xl sm:text-4xl font-bold text-white mt-4 max-w-3xl">
                  {post.title}
                </h1>
                <div className="flex items-center mt-6 text-white">
                  <div className="flex items-center">
                    <UserIcon className="h-5 w-5 mr-1" />
                    <span>{post.author}</span>
                  </div>
                  <span className="mx-3">•</span>
                  <div className="flex items-center">
                    <ClockIcon className="h-5 w-5 mr-1" />
                    <span>{post.readTime} phút đọc</span>
                  </div>
                  <span className="mx-3">•</span>
                  <span>{post.date}</span>
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-4 gap-12">
            {/* Blog content */}
            <div className="lg:col-span-3">
              <div className="prose prose-lg max-w-none" dangerouslySetInnerHTML={{ __html: post.content }} />
              
              {post.tags && (
                <div className="mt-10 border-t border-gray-200 pt-8">
                  <div className="flex flex-wrap items-center">
                    <span className="text-gray-700 mr-4">Tags:</span>
                    {post.tags.map(tag => (
                      <Link 
                        key={tag} 
                        href={`/blog?tag=${tag}`}
                        className="bg-gray-100 hover:bg-gray-200 text-gray-800 text-sm px-3 py-1 rounded-full mr-2 mb-2"
                      >
                        {tag}
                      </Link>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Sidebar */}
            <div className="lg:col-span-1">
              {relatedPosts && relatedPosts.length > 0 && (
                <div className="sticky top-6">
                  <h2 className="text-lg font-medium text-gray-900 mb-4">Bài viết liên quan</h2>
                  <div className="space-y-6">
                    {relatedPosts.map((relatedPost) => (
                      <Link key={relatedPost.id} href={`/blog/${relatedPost.id}`}>
                        <div className="group flex flex-col space-y-2">
                          <div className="relative h-32 w-full rounded-md overflow-hidden mb-2">
                            <Image
                              src={relatedPost.image}
                              alt={relatedPost.title}
                              fill
                              className="object-cover group-hover:scale-105 transition-transform duration-300"
                            />
                          </div>
                          <h3 className="text-sm font-medium text-gray-900 group-hover:text-indigo-600">
                            {relatedPost.title}
                          </h3>
                          <p className="text-xs text-gray-500">
                            {relatedPost.date}
                          </p>
                        </div>
                      </Link>
                    ))}
                  </div>

                  <div className="mt-8">
                    <h2 className="text-lg font-medium text-gray-900 mb-4">Danh mục</h2>
                    <div className="space-y-2">
                      <Link href="/blog?category=Hướng dẫn" className="block text-sm text-gray-600 hover:text-indigo-600">
                        Hướng dẫn
                      </Link>
                      <Link href="/blog?category=Xu hướng" className="block text-sm text-gray-600 hover:text-indigo-600">
                        Xu hướng
                      </Link>
                      <Link href="/blog?category=Chăm sóc" className="block text-sm text-gray-600 hover:text-indigo-600">
                        Chăm sóc
                      </Link>
                      <Link href="/blog?category=Sức khỏe" className="block text-sm text-gray-600 hover:text-indigo-600">
                        Sức khỏe
                      </Link>
                      <Link href="/blog?category=Kiến thức" className="block text-sm text-gray-600 hover:text-indigo-600">
                        Kiến thức
                      </Link>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async ({ params }) => {
  const postId = params?.id as string;
  
  // Find the post with the matching ID
  const post = blogPosts.find((post) => post.id === postId);
  
  if (!post) {
    return {
      notFound: true,
    };
  }
  
  // Find related posts
  const related = post.relatedPosts
    .map((id) => allBlogPosts.find((post) => post.id === id))
    .filter(Boolean);
  
  return {
    props: {
      post,
      relatedPosts: related,
    },
  };
};