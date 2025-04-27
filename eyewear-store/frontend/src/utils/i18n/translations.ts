export type Locale = 'vi' | 'en';

export interface Translation {
  common: {
    search: string;
    cart: string;
    login: string;
    register: string;
    logout: string;
    account: string;
    myOrders: string;
    wishlist: string;
    compare: string;
    menu: string;
    home: string;
    products: string;
    eyeglasses: string;
    sunglasses: string;
    lenses: string;
    accessories: string;
    blog: string;
    about: string;
    contact: string;
    copyright: string;
    currency: string;
  };
  product: {
    addToCart: string;
    buyNow: string;
    outOfStock: string;
    inStock: string;
    description: string;
    specifications: string;
    reviews: string;
    relatedProducts: string;
    filter: string;
    sort: string;
    price: string;
    brand: string;
    gender: string;
    frameMaterial: string;
    lensType: string;
    color: string;
  };
  cart: {
    yourCart: string;
    empty: string;
    continueShopping: string;
    subtotal: string;
    shipping: string;
    tax: string;
    total: string;
    checkout: string;
    remove: string;
    quantity: string;
  };
  checkout: {
    title: string;
    shippingInfo: string;
    paymentMethod: string;
    orderSummary: string;
    firstName: string;
    lastName: string;
    email: string;
    phone: string;
    address: string;
    city: string;
    postalCode: string;
    country: string;
    cardPayment: string;
    cashOnDelivery: string;
    placeOrder: string;
    processing: string;
  };
}

export const translations: Record<Locale, Translation> = {
  vi: {
    common: {
      search: 'Tìm kiếm',
      cart: 'Giỏ hàng',
      login: 'Đăng nhập',
      register: 'Đăng ký',
      logout: 'Đăng xuất',
      account: 'Tài khoản',
      myOrders: 'Đơn hàng của tôi',
      wishlist: 'Danh sách yêu thích',
      compare: 'So sánh',
      menu: 'Menu',
      home: 'Trang chủ',
      products: 'Sản phẩm',
      eyeglasses: 'Kính mắt',
      sunglasses: 'Kính râm',
      lenses: 'Tròng kính',
      accessories: 'Phụ kiện',
      blog: 'Blog',
      about: 'Về chúng tôi',
      contact: 'Liên hệ',
      copyright: '© 2023 Eyewear Store. Tất cả quyền được bảo lưu.',
      currency: 'VNĐ',
    },
    product: {
      addToCart: 'Thêm vào giỏ hàng',
      buyNow: 'Mua ngay',
      outOfStock: 'Hết hàng',
      inStock: 'Còn hàng',
      description: 'Mô tả',
      specifications: 'Thông số kỹ thuật',
      reviews: 'Đánh giá',
      relatedProducts: 'Sản phẩm liên quan',
      filter: 'Lọc',
      sort: 'Sắp xếp',
      price: 'Giá',
      brand: 'Thương hiệu',
      gender: 'Giới tính',
      frameMaterial: 'Chất liệu gọng',
      lensType: 'Loại tròng kính',
      color: 'Màu sắc',
    },
    cart: {
      yourCart: 'Giỏ hàng của bạn',
      empty: 'Giỏ hàng trống',
      continueShopping: 'Tiếp tục mua sắm',
      subtotal: 'Tạm tính',
      shipping: 'Phí vận chuyển',
      tax: 'Thuế',
      total: 'Tổng cộng',
      checkout: 'Thanh toán',
      remove: 'Xóa',
      quantity: 'Số lượng',
    },
    checkout: {
      title: 'Thanh toán',
      shippingInfo: 'Thông tin giao hàng',
      paymentMethod: 'Phương thức thanh toán',
      orderSummary: 'Thông tin đơn hàng',
      firstName: 'Họ',
      lastName: 'Tên',
      email: 'Email',
      phone: 'Số điện thoại',
      address: 'Địa chỉ',
      city: 'Thành phố',
      postalCode: 'Mã bưu điện',
      country: 'Quốc gia',
      cardPayment: 'Thẻ tín dụng/ghi nợ',
      cashOnDelivery: 'Thanh toán khi nhận hàng',
      placeOrder: 'Đặt hàng',
      processing: 'Đang xử lý...',
    },
  },
  en: {
    common: {
      search: 'Search',
      cart: 'Cart',
      login: 'Login',
      register: 'Register',
      logout: 'Logout',
      account: 'Account',
      myOrders: 'My Orders',
      wishlist: 'Wishlist',
      compare: 'Compare',
      menu: 'Menu',
      home: 'Home',
      products: 'Products',
      eyeglasses: 'Eyeglasses',
      sunglasses: 'Sunglasses',
      lenses: 'Lenses',
      accessories: 'Accessories',
      blog: 'Blog',
      about: 'About Us',
      contact: 'Contact',
      copyright: '© 2023 Eyewear Store. All rights reserved.',
      currency: 'USD',
    },
    product: {
      addToCart: 'Add to Cart',
      buyNow: 'Buy Now',
      outOfStock: 'Out of Stock',
      inStock: 'In Stock',
      description: 'Description',
      specifications: 'Specifications',
      reviews: 'Reviews',
      relatedProducts: 'Related Products',
      filter: 'Filter',
      sort: 'Sort',
      price: 'Price',
      brand: 'Brand',
      gender: 'Gender',
      frameMaterial: 'Frame Material',
      lensType: 'Lens Type',
      color: 'Color',
    },
    cart: {
      yourCart: 'Your Cart',
      empty: 'Your cart is empty',
      continueShopping: 'Continue Shopping',
      subtotal: 'Subtotal',
      shipping: 'Shipping',
      tax: 'Tax',
      total: 'Total',
      checkout: 'Checkout',
      remove: 'Remove',
      quantity: 'Quantity',
    },
    checkout: {
      title: 'Checkout',
      shippingInfo: 'Shipping Information',
      paymentMethod: 'Payment Method',
      orderSummary: 'Order Summary',
      firstName: 'First Name',
      lastName: 'Last Name',
      email: 'Email',
      phone: 'Phone',
      address: 'Address',
      city: 'City',
      postalCode: 'Postal Code',
      country: 'Country',
      cardPayment: 'Credit/Debit Card',
      cashOnDelivery: 'Cash on Delivery',
      placeOrder: 'Place Order',
      processing: 'Processing...',
    },
  },
};
