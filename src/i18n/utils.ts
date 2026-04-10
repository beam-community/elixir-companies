import { translations, defaultLocale, locales, type Locale } from './translations';

export function getLocaleFromUrl(url: URL): Locale {
  const [, lang] = url.pathname.split('/');
  if (locales.includes(lang as Locale)) return lang as Locale;
  return defaultLocale;
}

export function useTranslations(locale: Locale) {
  return function t(key: string): string {
    return translations[locale]?.[key] ?? translations[defaultLocale][key] ?? key;
  };
}

export function getLocalizedPath(path: string, locale: Locale): string {
  if (locale === defaultLocale) return path;
  return `/${locale}${path}`;
}

export { defaultLocale, locales, type Locale };
