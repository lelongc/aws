import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export interface CartItem {
  id: string;
  name: string;
  price: number;
  image: string;
  quantity: number;
}

interface CartState {
  items: CartItem[];
  totalItems: number;
  totalPrice: number;
  addItem: (item: CartItem) => void;
  removeItem: (id: string) => void;
  updateItemQuantity: (id: string, quantity: number) => void;
  clearCart: () => void;
}

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      totalItems: 0,
      totalPrice: 0,
      
      addItem: (item) => {
        const currentItems = get().items;
        const existingItem = currentItems.find((i) => i.id === item.id);
        
        if (existingItem) {
          // Update quantity if item already exists
          return get().updateItemQuantity(
            item.id, 
            existingItem.quantity + item.quantity
          );
        }
        
        // Add new item
        set((state) => {
          const newItems = [...state.items, item];
          return {
            items: newItems,
            totalItems: state.totalItems + item.quantity,
            totalPrice: state.totalPrice + (item.price * item.quantity),
          };
        });
      },
      
      removeItem: (id) => {
        const itemToRemove = get().items.find((item) => item.id === id);
        
        if (!itemToRemove) return;
        
        set((state) => ({
          items: state.items.filter((item) => item.id !== id),
          totalItems: state.totalItems - itemToRemove.quantity,
          totalPrice: state.totalPrice - (itemToRemove.price * itemToRemove.quantity),
        }));
      },
      
      updateItemQuantity: (id, quantity) => {
        if (quantity <= 0) {
          return get().removeItem(id);
        }
        
        set((state) => {
          const items = state.items.map((item) => {
            if (item.id !== id) return item;
            
            // Calculate quantity difference
            const quantityDiff = quantity - item.quantity;
            
            return {
              ...item,
              quantity,
            };
          });
          
          const updatedItem = items.find((item) => item.id === id)!;
          const quantityDiff = quantity - (state.items.find((item) => item.id === id)?.quantity || 0);
          
          return {
            items,
            totalItems: state.totalItems + quantityDiff,
            totalPrice: state.totalPrice + (updatedItem.price * quantityDiff),
          };
        });
      },
      
      clearCart: () => {
        set({
          items: [],
          totalItems: 0,
          totalPrice: 0,
        });
      },
    }),
    {
      name: 'cart-storage',
    }
  )
);
