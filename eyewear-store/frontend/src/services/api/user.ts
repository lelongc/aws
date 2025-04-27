import api from './index';

export async function fetchUserProfile(context?: any) {
  try {
    // If context is provided, we're on server side
    let response;
    if (context) {
      // Server-side request - forward cookies
      const { req } = context;
      const headers = req.headers.cookie ? { Cookie: req.headers.cookie } : undefined;
      response = await api.get('/auth/me', { headers });
    } else {
      // Client-side request
      response = await api.get('/auth/me');
    }
    return response.data;
  } catch (error) {
    console.error('Error fetching user profile:', error);
    throw error;
  }
}

export async function updateUserProfile(data: any) {
  const response = await api.patch('/users/profile', data);
  return response.data;
}

export async function changePassword(data: { currentPassword: string; newPassword: string }) {
  const response = await api.post('/users/change-password', data);
  return response.data;
}

export async function fetchUserAddresses() {
  const response = await api.get('/users/addresses');
  return response.data;
}

export async function addUserAddress(data: any) {
  const response = await api.post('/users/addresses', data);
  return response.data;
}

export async function updateUserAddress(addressId: string, data: any) {
  const response = await api.put(`/users/addresses/${addressId}`, data);
  return response.data;
}

export async function deleteUserAddress(addressId: string) {
  const response = await api.delete(`/users/addresses/${addressId}`);
  return response.data;
}

export async function setDefaultAddress(addressId: string) {
  const response = await api.patch(`/users/addresses/${addressId}/set-default`);
  return response.data;
}
