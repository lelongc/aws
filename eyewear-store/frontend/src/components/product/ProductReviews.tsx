import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { StarIcon } from '@heroicons/react/24/solid';
import { StarIcon as StarOutline } from '@heroicons/react/24/outline';
import { Review } from '@eyewear-store/shared/types';
import { useAuthStore } from '@/store/authStore';
import { format } from 'date-fns';
import toast from 'react-hot-toast';

interface ProductReviewsProps {
  productId: string;
  reviews: Review[];
  averageRating: number;
  totalReviews: number;
  onAddReview: (rating: number, comment: string) => Promise<void>;
}

interface ReviewFormData {
  rating: number;
  comment: string;
}

export default function ProductReviews({
  productId,
  reviews,
  averageRating,
  totalReviews,
  onAddReview
}: ProductReviewsProps) {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { register, handleSubmit, reset, formState: { errors } } = useForm<ReviewFormData>();
  const [selectedRating, setSelectedRating] = useState(0);
  const { user, isAuthenticated } = useAuthStore();

  const handleFormSubmit = async (data: ReviewFormData) => {
    if (!isAuthenticated) {
      toast.error('Bạn cần đăng nhập để đánh giá sản phẩm');
      return;
    }

    try {
      setIsSubmitting(true);
      await onAddReview(data.rating || selectedRating, data.comment);
      reset();
      setSelectedRating(0);
      toast.success('Cảm ơn bạn đã đánh giá sản phẩm!');
    } catch (error) {
      console.error('Error adding review:', error);
      toast.error('Không thể thêm đánh giá. Vui lòng thử lại sau.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="mt-10 border-t border-gray-200 pt-10">
      <h2 className="text-2xl font-bold mb-6">Đánh giá ({totalReviews})</h2>
      
      {/* Rating summary */}
      <div className="flex items-center mb-8">
        <div className="flex items-center">
          {[0, 1, 2, 3, 4].map((rating) => (
            <StarIcon
              key={rating}
              className={`${
                averageRating > rating ? 'text-yellow-400' : 'text-gray-300'
              } h-5 w-5 flex-shrink-0`}
            />
          ))}
        </div>
        <p className="ml-2 text-sm text-gray-700">
          {averageRating.toFixed(1)} trên 5 ({totalReviews} đánh giá)
        </p>
      </div>

      {/* Review list */}
      {reviews.length > 0 ? (
        <div className="space-y-8">
          {reviews.map((review) => (
            <div key={review.id} className="border-b border-gray-200 pb-6">
              <div className="flex items-center justify-between">
                <div className="flex items-center">
                  <div className="flex-shrink-0 mr-3">
                    <div className="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center">
                      <span className="text-xs font-medium text-indigo-800">
                        {review.userName.charAt(0)}
                      </span>
                    </div>
                  </div>
                  <div>
                    <h4 className="text-sm font-medium text-gray-900">{review.userName}</h4>
                    <div className="mt-1 flex items-center">
                      {[0, 1, 2, 3, 4].map((rating) => (
                        <StarIcon
                          key={rating}
                          className={`${
                            review.rating > rating ? 'text-yellow-400' : 'text-gray-300'
                          } h-4 w-4`}
                        />
                      ))}
                    </div>
                  </div>
                </div>
                <p className="text-sm text-gray-500">
                  {format(new Date(review.createdAt), 'dd/MM/yyyy')}
                </p>
              </div>
              <div className="mt-2 text-sm text-gray-600">
                <p>{review.comment}</p>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <p className="text-gray-500 mb-8">Chưa có đánh giá nào cho sản phẩm này</p>
      )}

      {/* Add review form */}
      <div className="mt-8 border-t border-gray-200 pt-8">
        <h3 className="text-lg font-medium text-gray-900 mb-4">Viết đánh giá</h3>
        
        {isAuthenticated ? (
          <form onSubmit={handleSubmit(handleFormSubmit)} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700">Đánh giá</label>
              <div className="flex items-center mt-1">
                {[1, 2, 3, 4, 5].map((rating) => (
                  <button
                    key={rating}
                    type="button"
                    onClick={() => setSelectedRating(rating)}
                    className="p-1"
                  >
                    {rating <= selectedRating ? (
                      <StarIcon className="h-6 w-6 text-yellow-400" />
                    ) : (
                      <StarOutline className="h-6 w-6 text-gray-400" />
                    )}
                  </button>
                ))}
                <input
                  type="hidden"
                  {...register('rating', { required: 'Vui lòng chọn số sao' })}
                  value={selectedRating}
                />
              </div>
              {errors.rating && (
                <p className="mt-1 text-sm text-red-600">{errors.rating.message}</p>
              )}
            </div>
            
            <div>
              <label htmlFor="comment" className="block text-sm font-medium text-gray-700">
                Nhận xét
              </label>
              <textarea
                id="comment"
                rows={4}
                {...register('comment', { required: 'Vui lòng nhập nhận xét' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                placeholder="Hãy chia sẻ trải nghiệm của bạn với sản phẩm này"
              />
              {errors.comment && (
                <p className="mt-1 text-sm text-red-600">{errors.comment.message}</p>
              )}
            </div>
            
            <button
              type="submit"
              disabled={isSubmitting}
              className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
            >
              {isSubmitting ? 'Đang gửi...' : 'Gửi đánh giá'}
            </button>
          </form>
        ) : (
          <div className="bg-gray-50 p-4 rounded-md">
            <p className="text-sm text-gray-700">
              Bạn cần <a href="/auth/login" className="text-indigo-600 font-medium">đăng nhập</a> để viết đánh giá.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
