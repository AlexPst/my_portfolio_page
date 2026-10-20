import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/profile.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

typedef NavItem = ({String label, String route});

class SiteHeader extends StatelessComponent {
  const SiteHeader({required this.locale, required this.currentRoute, super.key});

  final AppLocale locale;

  /// Маршрут текущей страницы без префикса языка, например `/projects`.
  final String currentRoute;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);
    final items = <NavItem>[
      (label: s.navHome, route: '/'),
      (label: s.navProjects, route: '/projects'),
      (label: s.navContacts, route: '/contacts'),
    ];

    return header(classes: 'site-header', [
      div(classes: 'container site-header__inner', [
        a(classes: 'site-header__logo', href: SiteConfig.href(locale.path('/')), [
          const span(classes: 'site-header__prompt', attributes: {'aria-hidden': 'true'}, [.text('~/')]),
          .text(profile.shortName.of(locale).toLowerCase()),
          const span(classes: 'site-header__cursor', attributes: {'aria-hidden': 'true'}, [.text('_')]),
        ]),
        nav(
          classes: 'site-header__nav',
          attributes: {'aria-label': s.mainNavLabel},
          [
            ul([
              for (final item in items)
                li([
                  a(
                    href: SiteConfig.href(locale.path(item.route)),
                    attributes: {if (_isActive(item.route)) 'aria-current': 'page'},
                    [.text(item.label)],
                  ),
                ]),
            ]),
          ],
        ),
      ]),
    ]);
  }

  bool _isActive(String route) =>
      route == '/' ? currentRoute == '/' : currentRoute == route || currentRoute.startsWith('$route/');

  @css
  static List<StyleRule> get styles => [
    css('.site-header', [
      css('&').styles(
        position: const .sticky(top: .zero),
        zIndex: const ZIndex(10),
        border: .only(
          bottom: .solid(color: AppColors.border, width: 1.px),
        ),
        raw: {
          'background-color': 'color-mix(in srgb, var(--bg) 82%, transparent)',
          'backdrop-filter': 'saturate(140%) blur(10px)',
          '-webkit-backdrop-filter': 'saturate(140%) blur(10px)',
        },
      ),
      css('.site-header__inner').styles(
        display: .flex,
        minHeight: 4.rem,
        flexWrap: .wrap,
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: .all(0.75.rem),
      ),
      // inline-flex убирает пробелы между частями логотипа, которые появляются при форматировании HTML.
      css('.site-header__logo').styles(
        display: .inlineFlex,
        alignItems: .baseline,
        color: AppColors.text,
        fontFamily: AppFonts.mono,
        fontWeight: .w700,
        textDecoration: const TextDecoration(line: .none),
      ),
      css('.site-header__prompt').styles(color: AppColors.accent),
      css('.site-header__cursor').styles(
        animation: const Animation(name: 'blink', duration: Duration(milliseconds: 1100), count: double.infinity),
        color: AppColors.accent,
      ),
      css('.site-header__nav ul').styles(
        display: .flex,
        padding: .zero,
        margin: .zero,
        gap: .column(0.25.rem),
        listStyle: .none,
      ),
      css('.site-header__nav a', [
        css('&').styles(
          display: .block,
          padding: .symmetric(vertical: 0.5.rem, horizontal: 0.75.rem),
          radius: .circular(8.px),
          color: AppColors.muted,
          fontSize: 0.9375.rem,
          fontWeight: .w500,
          textDecoration: const TextDecoration(line: .none),
        ),
        css('&:hover').styles(color: AppColors.text, backgroundColor: AppColors.surfaceRaised),
        css('&[aria-current="page"]').styles(color: AppColors.text, backgroundColor: AppColors.surfaceRaised),
        css('&[aria-current="page"]::before').styles(content: '> ', color: AppColors.accent, fontFamily: AppFonts.mono),
      ]),
    ]),
    css.keyframes('blink', {
      '0%, 50%': const Styles(opacity: 1),
      '50.01%, 100%': const Styles(opacity: 0),
    }),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.sm.px), [
      css('.site-header .site-header__inner').styles(padding: .symmetric(vertical: 0.5.rem)),
      css('.site-header .site-header__nav').styles(width: 100.percent, overflow: .auto),
      css('.site-header .site-header__nav ul').styles(raw: {'margin-left': '-0.75rem'}),
    ]),
  ];
}
