import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/profile.dart';
import '../styles/theme_preference.dart';

/// Иконка контакта. Декоративная: подпись всегда есть рядом текстом.
Component contactIcon(ContactKind kind, {int size = 24}) => switch (kind) {
  ContactKind.email => _icon(const ['M3 5h18v14H3z', 'm3 6 9 7 9-7'], size: size),
  ContactKind.telegram => _icon(const [_telegram], size: size, filled: true),
  ContactKind.github => _icon(const [_github], size: size, filled: true),
  ContactKind.linkedin || ContactKind.habr || ContactKind.hh => _icon(const [_link1, _link2], size: size),
};

/// Иконка варианта темы: монитор, солнце, луна.
Component themeIcon(ThemePreference theme, {int size = 18}) => switch (theme) {
  ThemePreference.system => _icon(const ['M3 4h18v12H3z', 'M8 20h8', 'M12 16v4'], size: size),
  ThemePreference.light => _icon(const [
    'M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z',
    'M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41',
  ], size: size),
  ThemePreference.dark => _icon(const ['M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z'], size: size),
};

Component _icon(List<String> paths, {required int size, bool filled = false}) {
  return svg(
    viewBox: '0 0 24 24',
    width: size.px,
    height: size.px,
    attributes: {'aria-hidden': 'true', 'focusable': 'false'},
    [
      for (final d in paths)
        filled
            ? path(d: d, fill: Color.currentColor, [])
            : path(
                d: d,
                fill: Colors.transparent,
                stroke: Color.currentColor,
                strokeWidth: '1.8',
                attributes: {'stroke-linecap': 'round', 'stroke-linejoin': 'round'},
                [],
              ),
    ],
  );
}

const _telegram =
    'M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 '
    '7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 '
    '8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417'
    '-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 '
    '1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216'
    '.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z';

const _github =
    'M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04'
    '-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 '
    '1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332'
    '-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 '
    '1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 '
    '1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 '
    '.315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12';

const _link1 = 'M10 14a5 5 0 0 0 7.07 0l2.83-2.83a5 5 0 0 0-7.07-7.07L11.5 5.5';
const _link2 = 'M14 10a5 5 0 0 0-7.07 0L4.1 12.83a5 5 0 0 0 7.07 7.07l1.33-1.33';
