import React, { createContext, useState, useContext, ReactNode } from 'react';
import { Locale, translations, Translation } from '@/utils/i18n/translations';

interface LocaleContextType {
  locale: Locale;
  t: Translation;
  changeLocale: (newLocale: Locale) => void;
}

const LocaleContext = createContext<LocaleContextType | undefined>(undefined);

interface LocaleProviderProps {
  children: ReactNode;
}

export function LocaleProvider({ children }: LocaleProviderProps) {
  const [locale, setLocale] = useState<Locale>('vi');

  const changeLocale = (newLocale: Locale) => {
    setLocale(newLocale);
    // Optionally save to localStorage for persistence
    localStorage.setItem('locale', newLocale);
  };

  // Get the translations for the current locale
  const t = translations[locale];

  return (
    <LocaleContext.Provider value={{ locale, t, changeLocale }}>
      {children}
    </LocaleContext.Provider>
  );
}

export function useLocale() {
  const context = useContext(LocaleContext);
  if (context === undefined) {
    throw new Error('useLocale must be used within a LocaleProvider');
  }
  return context;
}
