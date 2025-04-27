import React from 'react';
import { GetServerSideProps } from 'next';
import Layout from '@/components/layout/Layout';
import HeroSection from '@/components/home/HeroSection';
import FeaturedProducts from '@/components/home/FeaturedProducts';
import CategorySection from '@/components/home/CategorySection';
import BrandsSection from '@/components/home/BrandsSection';
import TestimonialSection from '@/components/home/TestimonialSection';
import { Product } from '@eyewear-store/shared/types';
import { fetchFeaturedProducts } from '@/services/api/products';

interface HomePageProps {
  featuredProducts: Product[];
}

export default function HomePage({ featuredProducts }: HomePageProps) {
  return (
    <Layout title="Eyewear Store - Shop Stylish Glasses & Sunglasses">
      <HeroSection />
      <FeaturedProducts products={featuredProducts} />
      <CategorySection />
      <BrandsSection />
      <TestimonialSection />
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    // Fetch featured products for homepage
    const featuredProducts = await fetchFeaturedProducts();
    
    return {
      props: {
        featuredProducts,
      },
    };
  } catch (error) {
    console.error('Error fetching data for homepage:', error);
    return {
      props: {
        featuredProducts: [],
      },
    };
  }
};
