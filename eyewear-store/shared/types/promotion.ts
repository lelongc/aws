export enum DiscountType {
  PERCENTAGE = 'percentage',
  FIXED_AMOUNT = 'fixed_amount',
}

export interface Coupon {
  id: string;
  code: string;
  discountType: DiscountType;
  discountValue: number; // percentage or fixed amount
  minimumOrderAmount?: number;
  expiryDate?: string;
  isActive: boolean;
}

export interface ApplyCouponRequest {
  code: string;
}

export interface ApplyCouponResponse {
  coupon: Coupon;
  discountAmount: number;
  subtotal: number;
  total: number;
}
