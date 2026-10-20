import 'package:jaspr/dom.dart';

/// Шрифты лежат в `web/fonts` (Fontsource, SIL OFL 1.1) — без запросов к Google Fonts.
///
/// Используются вариативные woff2 по подмножествам: браузер скачивает файл,
/// только если на странице есть символы из его `unicode-range`.
typedef FontFile = ({String family, String file, String unicodeRange, bool preload});

const _latin =
    'U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, '
    'U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD';
const _cyrillic = 'U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116';

const fontFiles = <FontFile>[
  // Основной текст: нужен на первом экране любой страницы — предзагружаем.
  (family: 'Inter', file: 'fonts/inter-latin-wght-normal.woff2', unicodeRange: _latin, preload: true),
  (family: 'Inter', file: 'fonts/inter-cyrillic-wght-normal.woff2', unicodeRange: _cyrillic, preload: true),
  (
    family: 'JetBrains Mono',
    file: 'fonts/jetbrains-mono-latin-wght-normal.woff2',
    unicodeRange: _latin,
    preload: false,
  ),
  (
    family: 'JetBrains Mono',
    file: 'fonts/jetbrains-mono-cyrillic-wght-normal.woff2',
    unicodeRange: _cyrillic,
    preload: false,
  ),
];

/// `@font-face` для всех файлов. Пути относительные и разрешаются от `<base href>`.
@css
List<StyleRule> get fontStyles => [
  for (final font in fontFiles)
    css('@font-face').styles(
      raw: {
        'font-family': "'${font.family}'",
        'font-style': 'normal',
        'font-weight': '100 900',
        'font-display': 'swap',
        'src': "url('${font.file}') format('woff2')",
        'unicode-range': font.unicodeRange,
      },
    ),
];
