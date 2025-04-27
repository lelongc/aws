import api from './index';
import { Product, FilterProductParams } from '@eyewear-store/shared/types';

export async function fetchProducts(params?: FilterProductParams): Promise<Product[]> {
  const { data } = await api.get('/products', { params });
  return data;
}

export async function fetchFeaturedProducts(): Promise<Product[]> {
  const { data } = await api.get('/products', { 
    params: { featured: true, limit: 8 } 
  });
  return data;
}

export async function fetchProductById(id: string): Promise<Product> {
  const { data } = await api.get(`/products/${id}`);
  return data;
}

export async function fetchRelatedProducts(id: string): Promise<Product[]> {
  const { data } = await api.get(`/products/${id}/related`);
  return data;
}

export async function searchProducts(query: string): Promise<Product[]> {
  const { data } = await api.get('/products', {
    params: { search: query }
  });
  return data;
}
