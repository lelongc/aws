export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  discountPrice?: number | null;
  isActive: boolean;
  stockQuantity: number;
  sku?: string | null;
  specs?: Record<string, any> | null;
  frameColor?: string | null;
  lensType?: string | null;
  frameMaterial?: string | null;
  gender?: string | null;
  brand?: Brand;
  categories?: Category[];
  images?: ProductImage[];
  createdAt: string;
  updatedAt: string;
}

export interface Brand {
  id: string;
  name: string;
  slug: string;
  description?: string | null;
  logoUrl?: string | null;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  description?: string | null;
}

export interface ProductImage {
  id: string;
  url: string;
  alt?: string | null;
  isPrimary: boolean;
}

export interface FilterProductParams {
  category?: string;
  brand?: string;
  minPrice?: number;
  maxPrice?: number;
  gender?: string;
  search?: string;
  sortBy?: string;
  sortOrder?: 'ASC' | 'DESC';
  page?: number;
  limit?: number;
  featured?: boolean;
}
