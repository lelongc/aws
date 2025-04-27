import api from './index';
import { ApplyCouponRequest, ApplyCouponResponse } from '@eyewear-store/shared/types';

export async function applyCoupon(data: ApplyCouponRequest): Promise<ApplyCouponResponse> {
  const { data: response } = await api.post('/coupons/apply', data);
  return response;
}

export async function validateCoupon(code: string): Promise<boolean> {
  try {
    await api.get(`/coupons/validate/${code}`);
    return true;
  } catch (error) {
    return false;
  }
}
