import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Product } from '@eyewear-store/shared/types';

interface WishlistItem {
  id: string;
  name: string;
  image: string;
  price: number;
}

interface WishlistState {
  items: WishlistItem[];
  addItem: (product: Product | WishlistItem) => void;
  removeItem: (id: string) => void;
  isInWishlist: (id: string) => boolean;
  clearWishlist: () => void;
}

export const useWishlistStore = create<WishlistState>()(
  persist(
    (set, get) => ({
      items: [],
      
      addItem: (product) => {
        const { items } = get();
        
        // Check if item already exists
        if (items.some(item => item.id === product.id)) return;
        
        const newItem: WishlistItem = {
          id: product.id,
          name: product.name,
          image: product.image || (product as Product).images?.[0]?.url || '/images/placeholder.jpg',
          price: product.price,
        };
        
        set({ items: [...items, newItem] });
      },
      
      removeItem: (id) => {
        set({ items: get().items.filter(item => item.id !== id) });
      },
      
      isInWishlist: (id) => {
        return get().items.some(item => item.id === id);
      },
      
      clearWishlist: () => {
        set({ items: [] });
      }
    }),
    {
      name: 'wishlist-storage',
    }
  )
);
