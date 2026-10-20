/// Поддерживаемые языки сайта.
///
/// Русский живёт в корне (`/`, `/projects`), английский — под префиксом `/en`.
enum AppLocale {
  ru(code: 'ru', prefix: '', ogLocale: 'ru_RU'),
  en(code: 'en', prefix: '/en', ogLocale: 'en_US');

  const AppLocale({required this.code, required this.prefix, required this.ogLocale});

  /// Значение атрибута `lang` у `<html>`.
  final String code;

  /// Префикс маршрутов этого языка.
  final String prefix;

  /// Значение `og:locale`.
  final String ogLocale;

  /// Язык по умолчанию.
  static const fallback = AppLocale.ru;

  /// Маршрут [route] (например `/` или `/projects`) с префиксом языка.
  String path(String route) => switch ((prefix, route)) {
    ('', _) => route,
    (_, '/') => prefix,
    _ => '$prefix$route',
  };

  /// Определяет язык по URL текущей страницы.
  static AppLocale fromUrl(String url) {
    for (final locale in values) {
      if (locale.prefix.isNotEmpty && (url == locale.prefix || url.startsWith('${locale.prefix}/'))) {
        return locale;
      }
    }
    return fallback;
  }
}

/// Строка в двух языковых вариантах.
typedef Localized = ({String ru, String en});

extension LocalizedOf on Localized {
  String of(AppLocale locale) => switch (locale) {
    AppLocale.ru => ru,
    AppLocale.en => en,
  };
}
