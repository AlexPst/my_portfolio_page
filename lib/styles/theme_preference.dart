/// Выбор темы пользователем.
///
/// `system` — атрибута `data-theme` нет, работает `prefers-color-scheme`;
/// `light`/`dark` — `<html data-theme="...">` перекрывает системную настройку
/// (см. `themeStyles` в `theme.dart`).
enum ThemePreference {
  system,
  light,
  dark;

  /// Ключ в `localStorage`.
  static const storageKey = 'theme';

  /// Разбор сохранённого значения; неизвестное значение — `system`.
  static ThemePreference parse(String? value) => switch (value) {
    'light' => light,
    'dark' => dark,
    _ => system,
  };
}

/// Синхронный скрипт для `<head>`: применяет сохранённую тему до первой отрисовки.
///
/// Клиентский Dart-бандл загружается с `defer`, и без этого скрипта страница
/// сначала мелькнула бы системной темой. Это единственный JS, написанный вручную.
/// `try` нужен для режимов, где `localStorage` недоступен.
const themeInitScript =
    "(function(){try{var t=localStorage.getItem('${ThemePreference.storageKey}');"
    "if(t==='light'||t==='dark')document.documentElement.setAttribute('data-theme',t)}catch(e){}})();";
