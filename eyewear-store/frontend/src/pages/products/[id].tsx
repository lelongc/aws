import React, { useState } from 'react';
import { GetServerSideProps } from 'next';
import Image from 'next/image';
import Layout from '@/components/layout/Layout';
import { Product } from '@eyewear-store/shared/types';
import { fetchProductById, fetchRelatedProducts } from '@/services/api/products';
import ProductGallery from '@/components/product/ProductGallery';
import ProductInfo from '@/components/product/ProductInfo';
import RelatedProducts from '@/components/product/RelatedProducts';
import { useCartStore } from '@/store/cartStore';
import toast from 'react-hot-toast';
import JsonLd from '@/components/common/JsonLd';

interface ProductPageProps {
  product: Product;
  relatedProducts: Product[];
}

export default function ProductPage({ product, relatedProducts }: ProductPageProps) {
  const [quantity, setQuantity] = useState(1);
  const addToCart = useCartStore((state) => state.addItem);

  const handleAddToCart = () => {
    addToCart({
      id: product.id,
      name: product.name,
      price: product.discountPrice || product.price,
      image: product.images[0]?.url || '/images/placeholder.jpg',
      quantity,
    });
    toast.success('Added to cart!');
  };

  const generateProductJsonLd = (product: Product) => {
    const productImage = product.images?.[0]?.url || '/images/placeholder.jpg';
    const baseUrl = process.env.NEXT_PUBLIC_SITE_URL || 'https://eyewear-store.vn';
    
    return {
      "@context": "https://schema.org/",
      "@type": "Product",
      "name": product.name,
      "image": [
        productImage.startsWith('http') ? productImage : `${baseUrl}${productImage}`
      ],
      "description": product.description,
      "sku": product.sku || '',
      "mpn": product.id,
      "brand": {
        "@type": "Brand",
        "name": product.brand?.name || "Eyewear Store"
      },
      "offers": {
        "@type": "Offer",
        "url": `${baseUrl}/products/${product.id}`,
        "priceCurrency": "VND",
        "price": product.discountPrice || product.price,
        "priceValidUntil": new Date(new Date().setFullYear(new Date().getFullYear() + 1)).toISOString().split('T')[0],
        "availability": product.stockQuantity > 0 ? "https://schema.org/InStock" : "https://schema.org/OutOfStock",
        "seller": {
          "@type": "Organization",
          "name": "Eyewear Store"
        }
      }
    };
  };

  if (!product) {
    return (
      <Layout title="Product Not Found">
        <div className="container mx-auto px-4 py-16">
          <h1 className="text-2xl font-bold">Product not found</h1>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title={`${product.name} | Eyewear Store`}>
      <JsonLd data={generateProductJsonLd(product)} />
      <div className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Product Gallery */}
          <ProductGallery images={product.images} />
          
          {/* Product Info */}
          <ProductInfo 
            product={product} 
            quantity={quantity}
            setQuantity={setQuantity}
            onAddToCart={handleAddToCart}
          />
        </div>
        
        {/* Product Description */}
        <div className="mt-16">
          <h2 className="text-2xl font-semibold mb-4">Description</h2>
          <div className="prose max-w-none">
            <p>{product.description}</p>
          </div>
        </div>
        
        {/* Product Specifications */}
        <div className="mt-12">
          <h2 className="text-2xl font-semibold mb-4">Specifications</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="border rounded p-4">
              <h3 className="font-medium text-gray-900">Frame Details</h3>
              <ul className="mt-2 space-y-2">
                {product.frameMaterial && (
                  <li className="text-gray-600 flex justify-between">
                    <span>Material:</span>
                    <span>{product.frameMaterial}</span>
                  </li>
                )}
                {product.frameColor && (
                  <li className="text-gray-600 flex justify-between">
                    <span>Color:</span>
                    <span>{product.frameColor}</span>
                  </li>
                )}
                {/* Other specs */}
              </ul>
            </div>
            
            <div className="border rounded p-4">
              <h3 className="font-medium text-gray-900">Lens Details</h3>
              <ul className="mt-2 space-y-2">
                {product.lensType && (
                  <li className="text-gray-600 flex justify-between">
                    <span>Type:</span>
                    <span>{product.lensType}</span>
                  </li>
                )}
                {/* Other lens details */}
              </ul>
            </div>
          </div>
        </div>
        
        {/* Related Products */}
        <RelatedProducts products={relatedProducts} />
      </div>
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async ({ params }) => {
  try {
    const id = params?.id as string;
    const product = await fetchProductById(id);
    const relatedProducts = await fetchRelatedProducts(id);
    
    return {
      props: {
        product,
        relatedProducts,
      },
    };
  } catch (error) {
    console.error('Error fetching product data:', error);
    return {
      notFound: true,
    };
  }
};
