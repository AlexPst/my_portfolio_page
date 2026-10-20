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
  ///
  /// Страницы собираются в `<route>/index.html`, а GitHub Pages редиректит `/projects`
  /// на `/projects/`. Поэтому ссылки на страницы сразу заканчиваются слешем,
  /// а ссылки на файлы (`404.html`, `images/og.png`) — нет.
  static String href(String route) {
    final path = '${_base()}$route';
    final isFile = route.split('/').last.contains('.');
    return path.endsWith('/') || isFile ? path : '$path/';
  }

  /// Ссылка на файл из `web/` (например `images/me.webp`) с учётом [basePath].
  static String asset(String path) => '${_base()}${path.startsWith('/') ? path : '/$path'}';

  static String _base() => basePath.endsWith('/') ? basePath.substring(0, basePath.length - 1) : basePath;

  /// Абсолютный URL для canonical, hreflang и Open Graph.
  static String absolute(String route) => '$siteUrl${href(route)}';
}
