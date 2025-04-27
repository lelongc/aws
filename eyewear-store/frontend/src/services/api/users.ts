import api from './index';

interface UpdateProfileRequest {
  firstName?: string;
  lastName?: string;
  phoneNumber?: string;
  currentPassword?: string;
  newPassword?: string;
}

interface UserProfile {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phoneNumber?: string;
  role: string;
}

export async function getUserProfile(): Promise<UserProfile> {
  const { data } = await api.get('/users/profile');
  return data;
}

export async function updateUserProfile(profileData: UpdateProfileRequest): Promise<UserProfile> {
  const { data } = await api.patch('/users/profile', profileData);
  return data;
}

export async function changePassword(currentPassword: string, newPassword: string): Promise<void> {
  await api.post('/users/change-password', { currentPassword, newPassword });
}
