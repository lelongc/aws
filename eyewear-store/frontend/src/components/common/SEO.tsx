import React from 'react';
import Head from 'next/head';

interface SEOProps {
  title: string;
  description?: string;
  canonical?: string;
  image?: string;
  ogType?: 'website' | 'article' | 'product'; 
  keywords?: string;
}

export default function SEO({
  title,
  description = 'Shop kính mắt cao cấp với nhiều mẫu mã đa dạng, chất lượng và giá cả hợp lý.',
  canonical,
  image = '/images/seo-image.jpg',
  ogType = 'website',
  keywords = 'kính mắt, kính râm, gọng kính, kính thời trang, mắt kính cao cấp',
}: SEOProps) {
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || 'https://eyewear-store.vn';
  const fullImageUrl = image.startsWith('http') ? image : `${siteUrl}${image}`;
  const fullCanonicalUrl = canonical ? `${siteUrl}${canonical}` : undefined;
  
  // Add brand name to title if not already included
  const fullTitle = title.includes('Eyewear Store') ? title : `${title} | Eyewear Store`;
  
  return (
    <Head>
      <title>{fullTitle}</title>
      <meta name="description" content={description} />
      <meta name="keywords" content={keywords} />
      
      {/* Open Graph / Facebook */}
      <meta property="og:type" content={ogType} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={fullImageUrl} />
      <meta property="og:url" content={fullCanonicalUrl || siteUrl} />
      <meta property="og:site_name" content="Eyewear Store" />
      
      {/* Twitter */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={fullImageUrl} />
      
      {/* Canonical URL */}
      {fullCanonicalUrl && <link rel="canonical" href={fullCanonicalUrl} />}
      
      {/* Additional tags for SEO */}
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta httpEquiv="Content-Type" content="text/html; charset=utf-8" />
      <meta name="robots" content="index, follow" />
    </Head>
  );
}
