// Simple analytics helpers for tracking events
// In a real app, you would integrate with Google Analytics, Mixpanel, etc.

export const trackPageView = (url: string) => {
  console.log('Page view tracked:', url);
  // In a real app:
  // window.gtag('config', 'UA-XXXXXXXX-X', { page_path: url })
};

export const trackEvent = (action: string, category: string, label?: string, value?: number) => {
  console.log('Event tracked:', { action, category, label, value });
  // In a real app:
  // window.gtag('event', action, {
  //   event_category: category,
  //   event_label: label,
  //   value: value
  // })
};

// E-commerce specific events
export interface ProductData {
  id: string;
  name: string;
  price: number;
  brand?: string;
  category?: string;
  variant?: string;
}

export const trackViewProduct = (product: ProductData) => {
  trackEvent('view_item', 'ecommerce', product.name);
  // In a real app:
  // window.gtag('event', 'view_item', {
  //   items: [
  //     {
  //       item_id: product.id,
  //       item_name: product.name,
  //       price: product.price,
  //       item_brand: product.brand,
  //       item_category: product.category,
  //       item_variant: product.variant,
  //     }
  //   ]
  // })
};

export const trackAddToCart = (product: ProductData, quantity: number) => {
  trackEvent('add_to_cart', 'ecommerce', product.name, quantity);
};

export const trackRemoveFromCart = (product: ProductData, quantity: number) => {
  trackEvent('remove_from_cart', 'ecommerce', product.name, quantity);
};

export const trackBeginCheckout = (value: number, items: ProductData[]) => {
  trackEvent('begin_checkout', 'ecommerce', undefined, value);
};

export const trackPurchase = (
  transactionId: string, 
  value: number, 
  tax: number, 
  shipping: number, 
  items: ProductData[]
) => {
  trackEvent('purchase', 'ecommerce', transactionId, value);
};
