/// Точка входа для генерации страниц (выполняется только при сборке и в `jaspr serve`).
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'data/site_config.dart';
import 'l10n/app_locale.dart';
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    Document(
      lang: AppLocale.fallback.code,
      base: SiteConfig.basePath,
      viewport: 'width=device-width, initial-scale=1',
      meta: const {
        'theme-color': '#0a101d',
        'color-scheme': 'light dark',
      },
      head: [
        const link(rel: 'icon', href: 'favicon.ico'),
        const link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
        const link(rel: 'preconnect', href: 'https://fonts.gstatic.com', attributes: {'crossorigin': ''}),
        const link(
          rel: 'stylesheet',
          href:
              'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700'
              '&family=JetBrains+Mono:wght@400;500;700&display=swap',
        ),
      ],
      body: const App(),
    ),
  );
}
