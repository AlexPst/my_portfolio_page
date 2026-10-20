/// Параметры сборки, которые отличаются между локальной разработкой и продом.
///
/// Передаются через `--dart-define`, например:
/// `jaspr build --dart-define=BASE_PATH=/my_portfolio_page/ --dart-define=SITE_URL=https://user.github.io`
abstract final class SiteConfig {
  /// Путь, по которому сайт опубликован. Для GitHub Pages репозитория проекта это `/<repo>/`.
  static const basePath = String.fromEnvironment('BASE_PATH', defaultValue: '/');

  /// Origin сайта без завершающего слеша. Нужен для canonical, Open Graph и sitemap.
  static const siteUrl = String.fromEnvironment('SITE_URL', defaultValue: 'http://localhost:8080');

  /// Ссылка на исходники сайта.
  static const sourceUrl = 'https://github.com/AlexPst/my_portfolio_page';

  /// Превращает внутренний маршрут (`/projects`) в href с учётом [basePath].
  static String href(String route) {
    final base = basePath.endsWith('/') ? basePath.substring(0, basePath.length - 1) : basePath;
    if (route == '/') return '$base/';
    return '$base$route';
  }

  /// Ссылка на файл из `web/` (например `images/me.webp`) с учётом [basePath].
  static String asset(String path) => href(path.startsWith('/') ? path : '/$path');
}
