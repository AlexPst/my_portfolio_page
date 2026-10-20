import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';
import '../styles/theme_preference.dart';
import 'icons.dart';

/// Переключатель темы: «как в системе», светлая, тёмная.
///
/// `@client`: на сервере неизвестно, что сохранено в `localStorage`, поэтому
/// до гидрации группа невидима, но занимает место (без сдвига шапки).
/// Начальную тему до загрузки Dart применяет `themeInitScript` в `<head>`.
@client
class ThemeToggle extends StatefulComponent {
  const ThemeToggle({required this.lang, super.key});

  /// Код языка: значение `AppLocale.name`.
  final String lang;

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();

  @css
  static List<StyleRule> get styles => [
    css('.theme-toggle', [
      css('&').styles(
        display: .inlineFlex,
        padding: .all(3.px),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(999.px),
        gap: .column(2.px),
        backgroundColor: AppColors.surface,
      ),
      css('&:not([data-ready])').styles(visibility: .hidden),
      css('button').styles(
        display: .inlineFlex,
        width: 2.rem,
        height: 2.rem,
        padding: .zero,
        border: .none,
        radius: .circular(999.px),
        cursor: .pointer,
        transition: Transition.combine([
          Transition('background-color', duration: 150.ms),
          Transition('color', duration: 150.ms),
        ]),
        justifyContent: .center,
        alignItems: .center,
        color: AppColors.muted,
        backgroundColor: Colors.transparent,
      ),
      css('button:hover').styles(color: AppColors.text),
      css('button[aria-pressed="true"]').styles(color: AppColors.onAccent, backgroundColor: AppColors.accentStrong),
    ]),
  ];
}

class _ThemeToggleState extends State<ThemeToggle> {
  ThemePreference _theme = .system;

  AppLocale get _locale => AppLocale.values.asNameMap()[component.lang] ?? AppLocale.fallback;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _theme = ThemePreference.parse(_read());
  }

  void _select(ThemePreference theme) {
    final root = web.document.documentElement;
    switch (theme) {
      case .system:
        root?.removeAttribute('data-theme');
        _write(null);
      case .light || .dark:
        root?.setAttribute('data-theme', theme.name);
        _write(theme.name);
    }
    setState(() => _theme = theme);
  }

  // localStorage может быть недоступен (приватный режим, запрет cookies):
  // тогда тема просто не запоминается.
  String? _read() {
    try {
      return web.window.localStorage.getItem(ThemePreference.storageKey);
    } catch (_) {
      return null;
    }
  }

  void _write(String? value) {
    try {
      final storage = web.window.localStorage;
      value == null
          ? storage.removeItem(ThemePreference.storageKey)
          : storage.setItem(ThemePreference.storageKey, value);
    } catch (_) {}
  }

  @override
  Component build(BuildContext context) {
    final s = Strings.of(_locale);

    return div(
      classes: 'theme-toggle',
      attributes: {
        'role': 'group',
        'aria-label': s.themeLabel,
        if (kIsWeb) 'data-ready': '',
      },
      [
        for (final theme in ThemePreference.values)
          button(
            type: ButtonType.button,
            attributes: {
              'aria-pressed': '${theme == _theme}',
              'title': _label(s, theme),
            },
            onClick: () => _select(theme),
            [
              themeIcon(theme),
              span(classes: 'visually-hidden', [.text(_label(s, theme))]),
            ],
          ),
      ],
    );
  }

  String _label(Strings s, ThemePreference theme) => switch (theme) {
    .system => s.themeSystem,
    .light => s.themeLight,
    .dark => s.themeDark,
  };
}
