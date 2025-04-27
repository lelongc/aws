import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Layout from '@/components/layout/Layout';
import ProductCard from '@/components/product/ProductCard';
import { searchProducts } from '@/services/api/products';
import { Product } from '@eyewear-store/shared/types';
import { MagnifyingGlassIcon } from '@heroicons/react/24/outline';

export default function SearchPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const router = useRouter();
  const { q } = router.query;

  useEffect(() => {
    if (q) {
      setSearchTerm(q as string);
      performSearch(q as string);
    }
  }, [q]);

  const performSearch = async (term: string) => {
    if (!term.trim()) return;

    setIsLoading(true);
    try {
      const results = await searchProducts(term);
      setProducts(results);
    } catch (error) {
      console.error('Error searching products:', error);
      setProducts([]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (!searchTerm.trim()) return;
    
    // Update URL with search query
    router.push({
      pathname: '/search',
      query: { q: searchTerm }
    }, undefined, { shallow: true });
    
    performSearch(searchTerm);
  };

  return (
    <Layout title="Tìm kiếm sản phẩm | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Tìm kiếm sản phẩm</h1>

        {/* Search form */}
        <div className="max-w-2xl mx-auto mb-12">
          <form onSubmit={handleSearch}>
            <label htmlFor="search" className="sr-only">
              Tìm kiếm
            </label>
            <div className="relative">
              <div className="pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center">
                <MagnifyingGlassIcon className="h-5 w-5 text-gray-400" aria-hidden="true" />
              </div>
              <input
                id="search"
                name="search"
                type="search"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="block w-full rounded-md border border-gray-300 bg-white py-2 pl-10 pr-3 text-sm placeholder-gray-500 focus:border-indigo-500 focus:text-gray-900 focus:placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="Tìm kiếm theo tên sản phẩm, thương hiệu..."
              />
              <div className="absolute inset-y-0 right-0 flex py-1.5 pr-1.5">
                <button
                  type="submit"
                  className="inline-flex items-center rounded border border-gray-200 px-4 font-sans text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                >
                  Tìm
                </button>
              </div>
            </div>
          </form>
        </div>

        {/* Results */}
        {isLoading ? (
          <div className="flex justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-500"></div>
          </div>
        ) : q ? (
          <>
            <p className="text-lg mb-6">
              {products.length > 0
                ? `Tìm thấy ${products.length} sản phẩm cho "${q}"`
                : `Không tìm thấy sản phẩm nào cho "${q}"`}
            </p>

            {products.length > 0 && (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                {products.map((product) => (
                  <ProductCard key={product.id} product={product} />
                ))}
              </div>
            )}
          </>
        ) : (
          <div className="text-center py-12">
            <p className="text-lg text-gray-600">
              Nhập từ khóa để tìm kiếm sản phẩm
            </p>
          </div>
        )}
      </div>
    </Layout>
  );
}
