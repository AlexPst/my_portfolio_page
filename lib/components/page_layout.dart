import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/profile.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';
import 'site_footer.dart';
import 'site_header.dart';

/// Общий каркас страницы: skip-link, шапка, `<main>`, подвал и мета-теги.
class PageLayout extends StatelessComponent {
  const PageLayout({
    required this.locale,
    required this.route,
    required this.title,
    required this.description,
    required this.children,
    super.key,
  });

  final AppLocale locale;

  /// Маршрут страницы без префикса языка.
  final String route;

  /// Заголовок страницы без суффикса с именем.
  final String title;
  final String description;
  final List<Component> children;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);
    final fullTitle = '$title — ${profile.name.of(locale)}';

    return .fragment([
      Document.html(attributes: {'lang': locale.code}),
      Document.head(title: fullTitle, meta: {'description': description}),
      a(classes: 'skip-link', href: '#main', [.text(s.skipToContent)]),
      SiteHeader(locale: locale, currentRoute: route),
      main_(id: 'main', attributes: {'tabindex': '-1'}, children),
      SiteFooter(locale: locale),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('body').styles(display: .flex, flexDirection: .column),
    css('main').styles(outline: .unset, flex: const Flex(grow: 1)),
    css('.skip-link', [
      css('&').styles(
        position: .absolute(top: 0.5.rem, left: 0.5.rem),
        zIndex: const ZIndex(100),
        padding: .symmetric(vertical: 0.5.rem, horizontal: 1.rem),
        radius: .circular(8.px),
        transform: Transform.translate(y: (-200).percent),
        color: AppColors.onAccent,
        fontWeight: .w600,
        backgroundColor: AppColors.accentStrong,
      ),
      css('&:focus').styles(transform: const Transform.translate(y: .zero)),
    ]),
  ];
}
