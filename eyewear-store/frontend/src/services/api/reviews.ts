import api from './index';
import { Review, CreateReviewRequest, ProductWithReviews } from '@eyewear-store/shared/types';

export async function getProductReviews(productId: string): Promise<ProductWithReviews> {
  const { data } = await api.get(`/products/${productId}/reviews`);
  return data;
}

export async function addProductReview(reviewData: CreateReviewRequest): Promise<Review> {
  const { data } = await api.post('/reviews', reviewData);
  return data;
}

export async function getUserReviews(): Promise<Review[]> {
  const { data } = await api.get('/users/reviews');
  return data;
}

export async function deleteReview(reviewId: string): Promise<void> {
  await api.delete(`/reviews/${reviewId}`);
}
