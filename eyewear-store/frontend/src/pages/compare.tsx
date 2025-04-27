import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Image from 'next/image';
import Link from 'next/link';
import Layout from '@/components/layout/Layout';
import { fetchProductById } from '@/services/api/products';
import { Product } from '@eyewear-store/shared/types';
import { useCartStore } from '@/store/cartStore';
import { XMarkIcon } from '@heroicons/react/24/outline';
import toast from 'react-hot-toast';

export default function ComparePage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const router = useRouter();
  const { ids } = router.query;
  const { addItem } = useCartStore();

  useEffect(() => {
    if (!ids) {
      setLoading(false);
      return;
    }

    const fetchProducts = async () => {
      try {
        setLoading(true);
        const productIds = Array.isArray(ids) ? ids : ids.split(',');
        
        // Get only up to 4 products to compare
        const limitedIds = productIds.slice(0, 4);
        
        const productsData = await Promise.all(
          limitedIds.map(id => fetchProductById(id))
        );
        
        setProducts(productsData);
      } catch (error) {
        console.error('Error fetching products to compare:', error);
        toast.error('Không thể tải thông tin sản phẩm để so sánh');
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, [ids]);

  const handleAddToCart = (product: Product) => {
    addItem({
      id: product.id,
      name: product.name,
      price: product.discountPrice || product.price,
      image: product.images?.[0]?.url || '/images/placeholder.jpg',
      quantity: 1,
    });
    toast.success(`Đã thêm ${product.name} vào giỏ hàng`);
  };

  const handleRemoveProduct = (productId: string) => {
    // Get current IDs from URL
    const productIds = Array.isArray(ids) ? ids : (ids || '').split(',');
    
    // Remove the selected product
    const updatedIds = productIds.filter(id => id !== productId);
    
    if (updatedIds.length === 0) {
      // Redirect to products page if no products left to compare
      router.push('/products');
    } else {
      // Update URL with new product IDs
      router.push({
        pathname: '/compare',
        query: { ids: updatedIds.join(',') }
      });
    }
  };

  return (
    <Layout title="So sánh sản phẩm | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">So sánh sản phẩm</h1>

        {loading ? (
          <div className="flex justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-500"></div>
          </div>
        ) : products.length === 0 ? (
          <div className="text-center py-16 bg-white rounded-lg shadow-sm">
            <h2 className="mt-4 text-2xl font-medium text-gray-900">Không có sản phẩm để so sánh</h2>
            <p className="mt-2 text-gray-500">Hãy chọn các sản phẩm để so sánh từ trang danh sách sản phẩm.</p>
            <div className="mt-6">
              <Link
                href="/products"
                className="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Xem sản phẩm
              </Link>
            </div>
          </div>
        ) : (
          <div className="bg-white shadow-sm rounded-lg overflow-hidden">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-1/5">
                      Thông tin
                    </th>
                    {products.map(product => (
                      <th key={product.id} scope="col" className="px-6 py-3 text-xs font-medium text-gray-500 relative">
                        <button
                          onClick={() => handleRemoveProduct(product.id)}
                          className="absolute right-2 top-2 text-gray-400 hover:text-gray-600"
                        >
                          <XMarkIcon className="h-5 w-5" />
                        </button>
                      </th>
                    ))}
                  </tr>
                </thead>
                
                <tbody className="bg-white divide-y divide-gray-200">
                  {/* Product image row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Hình ảnh
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <div className="h-40 w-40 mx-auto relative">
                          <Image
                            src={product.images?.[0]?.url || '/images/placeholder.jpg'}
                            alt={product.name}
                            fill
                            className="object-contain"
                          />
                        </div>
                      </td>
                    ))}
                  </tr>
                  
                  {/* Product name row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Tên sản phẩm
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        <Link href={`/products/${product.id}`} className="font-medium text-indigo-600 hover:text-indigo-500">
                          {product.name}
                        </Link>
                      </td>
                    ))}
                  </tr>
                  
                  {/* Price row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Giá
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {product.discountPrice ? (
                          <div>
                            <span className="font-medium">${product.discountPrice.toFixed(2)}</span>
                            <span className="ml-2 text-sm text-gray-500 line-through">${product.price.toFixed(2)}</span>
                          </div>
                        ) : (
                          <span className="font-medium">${product.price.toFixed(2)}</span>
                        )}
                      </td>
                    ))}
                  </tr>
                  
                  {/* Brand row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Thương hiệu
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.brand?.name || 'N/A'}
                      </td>
                    ))}
                  </tr>
                  
                  {/* Frame material row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Chất liệu khung
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.frameMaterial || 'N/A'}
                      </td>
                    ))}
                  </tr>
                  
                  {/* Frame color row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Màu sắc
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.frameColor || 'N/A'}
                      </td>
                    ))}
                  </tr>
                  
                  {/* Lens type row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Loại tròng kính
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.lensType || 'N/A'}
                      </td>
                    ))}
                  </tr>
                  
                  {/* Gender row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Giới tính
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.gender || 'Unisex'}
                      </td>
                    ))}
                  </tr>
                  
                  {/* Add to cart row */}
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Thao tác
                    </td>
                    {products.map(product => (
                      <td key={product.id} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <button
                          onClick={() => handleAddToCart(product)}
                          className="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        >
                          Thêm vào giỏ hàng
                        </button>
                      </td>
                    ))}
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
