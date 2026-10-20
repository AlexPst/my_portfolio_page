/// Точка входа для генерации страниц (выполняется только при сборке и в `jaspr serve`).
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'data/site_config.dart';
import 'l10n/app_locale.dart';
import 'main.server.options.dart';
import 'styles/fonts.dart';
import 'styles/theme_preference.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    Document(
      lang: AppLocale.fallback.code,
      base: SiteConfig.basePath,
      viewport: 'width=device-width, initial-scale=1',
      meta: const {'color-scheme': 'light dark'},
      head: [
        // Применяет сохранённую тему до первой отрисовки — без вспышки не той темы.
        const script(content: themeInitScript),
        const meta(name: 'theme-color', content: '#f6f8fb', attributes: {'media': '(prefers-color-scheme: light)'}),
        const meta(name: 'theme-color', content: '#0a101d', attributes: {'media': '(prefers-color-scheme: dark)'}),
        const link(rel: 'icon', href: 'favicon.ico', attributes: {'sizes': '48x48'}),
        const link(rel: 'icon', href: 'favicon.svg', type: 'image/svg+xml'),
        const link(rel: 'apple-touch-icon', href: 'apple-touch-icon.png'),
        // Шрифты первого экрана начинают грузиться сразу, не дожидаясь разбора CSS.
        for (final font in fontFiles)
          if (font.preload)
            link(
              rel: 'preload',
              href: font.file,
              as: 'font',
              type: 'font/woff2',
              attributes: {'crossorigin': ''},
            ),
      ],
      body: const App(),
    ),
  );
}
