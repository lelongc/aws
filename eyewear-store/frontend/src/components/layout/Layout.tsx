import React, { ReactNode } from 'react';
import Navbar from './Navbar';
import Footer from './Footer';
import { Toaster } from 'react-hot-toast';
import LiveChat from '../chat/LiveChat';
import SEO from '../common/SEO';

interface LayoutProps {
  children: ReactNode;
  title?: string;
  description?: string;
  canonical?: string;
  image?: string;
  ogType?: 'website' | 'article' | 'product';
}

export default function Layout({ 
  children, 
  title = 'Eyewear Store', 
  description,
  canonical,
  image,
  ogType
}: LayoutProps) {
  return (
    <>
      <SEO 
        title={title} 
        description={description}
        canonical={canonical}
        image={image}
        ogType={ogType}
      />

      <div className="min-h-screen flex flex-col">
        <Navbar />
        
        <main className="flex-grow">
          {children}
        </main>
        
        <Footer />
      </div>
      
      {/* Live Chat component */}
      <LiveChat />
      
      {/* Toast notifications */}
      <Toaster position="bottom-right" />
    </>
  );
}
