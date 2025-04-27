import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import { useForm } from 'react-hook-form';
import Layout from '@/components/layout/Layout';
import { useAuthStore } from '@/store/authStore';
import { updateUserProfile } from '@/services/api/users';
import toast from 'react-hot-toast';

interface ProfileFormData {
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string;
  currentPassword?: string;
  newPassword?: string;
  confirmPassword?: string;
}

export default function AccountPage() {
  const [isUpdatingProfile, setIsUpdatingProfile] = useState(false);
  const [isChangingPassword, setIsChangingPassword] = useState(false);
  
  const { user, isAuthenticated, updateUser } = useAuthStore();
  const router = useRouter();
  
  const { register, handleSubmit, watch, formState: { errors }, setValue } = useForm<ProfileFormData>();
  
  const newPassword = watch('newPassword');

  useEffect(() => {
    if (!isAuthenticated) {
      router.push('/auth/login?returnUrl=/account');
    } else if (user) {
      // Pre-fill form with user data
      setValue('firstName', user.firstName);
      setValue('lastName', user.lastName);
      setValue('email', user.email);
      setValue('phoneNumber', user.phoneNumber || '');
    }
  }, [isAuthenticated, user, router, setValue]);

  const handleProfileUpdate = async (data: ProfileFormData) => {
    try {
      setIsUpdatingProfile(true);
      
      // Convert form data to API request format
      const { currentPassword, newPassword, confirmPassword, ...profileData } = data;
      
      // Update profile via API
      const updatedUser = await updateUserProfile(profileData);
      
      // Update user in auth store
      updateUser(updatedUser);
      
      toast.success('Thông tin đã được cập nhật thành công');
    } catch (error) {
      console.error('Failed to update profile:', error);
      toast.error('Không thể cập nhật thông tin. Vui lòng thử lại sau.');
    } finally {
      setIsUpdatingProfile(false);
    }
  };

  const handlePasswordChange = async (data: ProfileFormData) => {
    try {
      setIsChangingPassword(true);
      
      if (!data.currentPassword || !data.newPassword) {
        toast.error('Vui lòng nhập mật khẩu hiện tại và mật khẩu mới');
        return;
      }
      
      if (data.newPassword !== data.confirmPassword) {
        toast.error('Mật khẩu mới và xác nhận mật khẩu không khớp');
        return;
      }
      
      // Call API to change password
      await updateUserProfile({
        currentPassword: data.currentPassword,
        newPassword: data.newPassword,
      });
      
      toast.success('Mật khẩu đã được thay đổi thành công');
      
      // Reset password fields
      setValue('currentPassword', '');
      setValue('newPassword', '');
      setValue('confirmPassword', '');
    } catch (error) {
      console.error('Failed to change password:', error);
      toast.error('Không thể thay đổi mật khẩu. Vui lòng kiểm tra mật khẩu hiện tại.');
    } finally {
      setIsChangingPassword(false);
    }
  };

  if (!isAuthenticated || !user) {
    return (
      <Layout title="Tài khoản | Eyewear Store">
        <div className="container mx-auto px-4 py-8">
          <p>Đang chuyển hướng...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title="Tài khoản | Eyewear Store">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Tài khoản của tôi</h1>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {/* Sidebar navigation */}
          <div className="md:col-span-1">
            <nav className="space-y-1">
              <a
                href="#profile"
                className="bg-indigo-50 border-indigo-500 text-indigo-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
              >
                Thông tin cá nhân
              </a>
              <a
                href="/account/orders"
                className="border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800 block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
              >
                Đơn hàng của tôi
              </a>
              <a
                href="#security"
                className="border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800 block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
              >
                Bảo mật
              </a>
            </nav>
          </div>

          {/* Main content */}
          <div className="md:col-span-2 space-y-8">
            {/* Profile information */}
            <section id="profile" className="bg-white p-6 rounded-lg shadow-sm">
              <h2 className="text-lg font-medium text-gray-900 mb-4">Thông tin cá nhân</h2>
              <form onSubmit={handleSubmit(handleProfileUpdate)}>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label htmlFor="firstName" className="block text-sm font-medium text-gray-700">
                      Họ
                    </label>
                    <input
                      type="text"
                      id="firstName"
                      {...register('firstName', { required: 'Vui lòng nhập họ' })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    {errors.firstName && (
                      <p className="mt-1 text-sm text-red-600">{errors.firstName.message}</p>
                    )}
                  </div>
                  
                  <div>
                    <label htmlFor="lastName" className="block text-sm font-medium text-gray-700">
                      Tên
                    </label>
                    <input
                      type="text"
                      id="lastName"
                      {...register('lastName', { required: 'Vui lòng nhập tên' })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    {errors.lastName && (
                      <p className="mt-1 text-sm text-red-600">{errors.lastName.message}</p>
                    )}
                  </div>
                </div>

                <div className="mt-4">
                  <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                    Email
                  </label>
                  <input
                    type="email"
                    id="email"
                    disabled
                    {...register('email')}
                    className="mt-1 block w-full rounded-md border-gray-300 bg-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                  <p className="mt-1 text-xs text-gray-500">Email không thể thay đổi</p>
                </div>

                <div className="mt-4">
                  <label htmlFor="phoneNumber" className="block text-sm font-medium text-gray-700">
                    Số điện thoại
                  </label>
                  <input
                    type="tel"
                    id="phoneNumber"
                    {...register('phoneNumber')}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                </div>

                <div className="mt-6">
                  <button
                    type="submit"
                    disabled={isUpdatingProfile}
                    className="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
                  >
                    {isUpdatingProfile ? 'Đang cập nhật...' : 'Cập nhật thông tin'}
                  </button>
                </div>
              </form>
            </section>

            {/* Security section */}
            <section id="security" className="bg-white p-6 rounded-lg shadow-sm">
              <h2 className="text-lg font-medium text-gray-900 mb-4">Thay đổi mật khẩu</h2>
              <form onSubmit={handleSubmit(handlePasswordChange)}>
                <div>
                  <label htmlFor="currentPassword" className="block text-sm font-medium text-gray-700">
                    Mật khẩu hiện tại
                  </label>
                  <input
                    type="password"
                    id="currentPassword"
                    {...register('currentPassword')}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                </div>

                <div className="mt-4">
                  <label htmlFor="newPassword" className="block text-sm font-medium text-gray-700">
                    Mật khẩu mới
                  </label>
                  <input
                    type="password"
                    id="newPassword"
                    {...register('newPassword', {
                      minLength: {
                        value: 6,
                        message: 'Mật khẩu phải có ít nhất 6 ký tự',
                      },
                    })}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                  {errors.newPassword && (
                    <p className="mt-1 text-sm text-red-600">{errors.newPassword.message}</p>
                  )}
                </div>

                <div className="mt-4">
                  <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700">
                    Xác nhận mật khẩu mới
                  </label>
                  <input
                    type="password"
                    id="confirmPassword"
                    {...register('confirmPassword', {
                      validate: (value) => value === newPassword || 'Mật khẩu không khớp',
                    })}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                  {errors.confirmPassword && (
                    <p className="mt-1 text-sm text-red-600">{errors.confirmPassword.message}</p>
                  )}
                </div>

                <div className="mt-6">
                  <button
                    type="submit"
                    disabled={isChangingPassword}
                    className="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400"
                  >
                    {isChangingPassword ? 'Đang xử lý...' : 'Thay đổi mật khẩu'}
                  </button>
                </div>
              </form>
            </section>
          </div>
        </div>
      </div>
    </Layout>
  );
}
