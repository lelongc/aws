import api from './index';
import { LoginRequest, RegisterRequest, LoginResponse } from '@eyewear-store/shared/types';
import Cookies from 'js-cookie';

export async function login(credentials: LoginRequest): Promise<LoginResponse> {
  const { data } = await api.post('/auth/login', credentials);
  
  // Store the token in a cookie (accessible only via HTTP)
  Cookies.set('auth_token', data.accessToken, { 
    expires: 7, // 7 days
    secure: process.env.NODE_ENV === 'production', 
    sameSite: 'strict'
  });
  
  return data;
}

export async function register(userData: RegisterRequest): Promise<LoginResponse> {
  const { data } = await api.post('/auth/register', userData);
  
  // Store the token in a cookie
  Cookies.set('auth_token', data.accessToken, { 
    expires: 7,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict'
  });
  
  return data;
}

export async function logout(): Promise<void> {
  try {
    // Optional: notify backend about logout
    await api.post('/auth/logout');
  } catch (error) {
    console.error('Error during logout:', error);
  } finally {
    // Always remove the cookie
    Cookies.remove('auth_token');
  }
}

export async function refreshToken(): Promise<LoginResponse> {
  const { data } = await api.post('/auth/refresh');
  
  // Update the token
  Cookies.set('auth_token', data.accessToken, { 
    expires: 7,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict'
  });
  
  return data;
}

export async function getProfile(): Promise<any> {
  const { data } = await api.get('/auth/profile');
  return data;
}
