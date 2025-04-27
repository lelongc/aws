import api from './index';
import { CreateOrderRequest, Order, OrderSummary } from '@eyewear-store/shared/types';

export async function createOrder(orderData: CreateOrderRequest): Promise<Order> {
  const { data } = await api.post('/orders', orderData);
  return data;
}

export async function getOrders(): Promise<OrderSummary[]> {
  const { data } = await api.get('/orders');
  return data;
}

export async function getOrderById(id: string): Promise<Order> {
  const { data } = await api.get(`/orders/${id}`);
  return data;
}

export async function cancelOrder(id: string): Promise<Order> {
  const { data } = await api.post(`/orders/${id}/cancel`);
  return data;
}
