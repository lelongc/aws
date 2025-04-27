export enum OrderStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  SHIPPED = 'shipped',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
}

export enum PaymentMethod {
  CREDIT_CARD = 'credit_card',
  COD = 'cod',
  BANK_TRANSFER = 'bank_transfer',
}

export enum PaymentStatus {
  PENDING = 'pending',
  PAID = 'paid',
  FAILED = 'failed',
  REFUNDED = 'refunded',
}

export interface Address {
  firstName: string;
  lastName: string;
  address: string;
  city: string;
  postalCode: string;
  country: string;
  phone: string;
}

export interface OrderItem {
  id?: string;
  productId: string;
  quantity: number;
  price: number;
  name?: string;
  image?: string;
}

export interface Order {
  id: string;
  userId?: string;
  items: OrderItem[];
  shippingAddress: Address;
  totalAmount: number;
  status: OrderStatus;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  createdAt: string;
  updatedAt: string;
}

export interface CreateOrderRequest {
  items: Omit<OrderItem, 'id' | 'name' | 'image'>[];
  shippingAddress: Address;
  paymentMethod: string;
}

export interface OrderSummary {
  id: string;
  totalAmount: number;
  status: OrderStatus;
  createdAt: string;
  itemCount: number;
}
