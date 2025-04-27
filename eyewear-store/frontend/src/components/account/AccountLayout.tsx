import React, { ReactNode } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { ShoppingBagIcon, CreditCardIcon, UserIcon, HomeIcon } from '@heroicons/react/24/outline';

interface AccountLayoutProps {
  children: ReactNode;
}

export default function AccountLayout({ children }: AccountLayoutProps) {
  const router = useRouter();
  const currentPath = router.pathname;
  
  const menuItems = [
    {
      name: 'Account Overview',
      href: '/account',
      icon: <UserIcon className="w-5 h-5" />,
      exact: true,
    },
    {
      name: 'My Orders',
      href: '/account/orders',
      icon: <ShoppingBagIcon className="w-5 h-5" />,
      exact: false,
    },
    {
      name: 'Addresses',
      href: '/account/addresses',
      icon: <HomeIcon className="w-5 h-5" />,
      exact: false,
    },
    {
      name: 'Payment Methods',
      href: '/account/payment-methods',
      icon: <CreditCardIcon className="w-5 h-5" />,
      exact: false,
    }
  ];

  const isActive = (item: {href: string, exact: boolean}) => {
    if (item.exact) {
      return currentPath === item.href;
    }
    return currentPath.startsWith(item.href);
  };
  
  return (
    <div className="container mx-auto px-4 py-12">
      <div className="flex flex-col lg:flex-row gap-8">
        {/* Sidebar Navigation */}
        <div className="lg:w-1/4">
          <nav className="bg-white rounded-lg overflow-hidden shadow-sm">
            <div className="px-6 py-4 bg-gray-50 border-b">
              <h2 className="font-semibold text-gray-800">My Account</h2>
            </div>
            <div className="p-2">
              {menuItems.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center px-4 py-3 rounded-md mb-1 ${
                    isActive(item)
                      ? 'bg-blue-50 text-blue-700'
                      : 'text-gray-700 hover:bg-gray-50'
                  }`}
                >
                  <span className="mr-3">{item.icon}</span>
                  <span>{item.name}</span>
                </Link>
              ))}
            </div>
          </nav>
        </div>
        
        {/* Main Content */}
        <div className="lg:w-3/4">
          {children}
        </div>
      </div>
    </div>
  );
}
