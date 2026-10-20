import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/profile.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';
import 'site_footer.dart';
import 'site_header.dart';

/// Значение `og:type`.
enum OgType { website, article, profile }

/// Общий каркас страницы: skip-link, шапка, `<main>`, подвал и SEO-мета.
class PageLayout extends StatelessComponent {
  const PageLayout({
    required this.locale,
    required this.route,
    required this.title,
    required this.description,
    required this.children,
    this.ogType = OgType.website,
    this.indexable = true,
    this.localized = true,
    this.structuredData,
    super.key,
  });

  final AppLocale locale;

  /// Маршрут страницы без префикса языка.
  final String route;

  /// Заголовок страницы без суффикса с именем.
  final String title;
  final String description;
  final List<Component> children;
  final OgType ogType;

  /// `false` — `noindex`, без canonical (например, для 404).
  final bool indexable;

  /// Есть ли у страницы версии на всех языках (для `hreflang`).
  final bool localized;

  /// Разметка schema.org в формате JSON-LD.
  final Map<String, Object?>? structuredData;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);
    final name = profile.name.of(locale);
    final fullTitle = '$title — $name';
    final url = SiteConfig.absolute(locale.path(route));
    final image = SiteConfig.absolute('/images/og-${locale.code}.png');

    return .fragment([
      Document.html(attributes: {'lang': locale.code}),
      Document.head(
        title: fullTitle,
        meta: {
          'description': description,
          'robots': indexable ? 'index, follow' : 'noindex, follow',
          'author': name,
          'twitter:card': 'summary_large_image',
          'twitter:title': fullTitle,
          'twitter:description': description,
          'twitter:image': image,
          'twitter:image:alt': s.ogImageAlt,
        },
        children: [
          if (indexable) link(rel: 'canonical', href: url),
          if (indexable && localized) ...[
            for (final alt in AppLocale.values)
              link(rel: 'alternate', href: SiteConfig.absolute(alt.path(route)), attributes: {'hreflang': alt.code}),
            link(
              rel: 'alternate',
              href: SiteConfig.absolute(AppLocale.fallback.path(route)),
              attributes: {'hreflang': 'x-default'},
            ),
          ],
          _og('og:type', ogType.name),
          _og('og:site_name', name),
          _og('og:title', fullTitle),
          _og('og:description', description),
          _og('og:url', url),
          _og('og:locale', locale.ogLocale),
          for (final alt in AppLocale.values)
            if (alt != locale) _og('og:locale:alternate', alt.ogLocale),
          _og('og:image', image),
          _og('og:image:type', 'image/png'),
          _og('og:image:width', '1200'),
          _og('og:image:height', '630'),
          _og('og:image:alt', s.ogImageAlt),
          if (structuredData case final data?)
            script(
              attributes: {'type': 'application/ld+json'},
              // `</` внутри JSON закрыл бы тег script раньше времени.
              content: jsonEncode(data).replaceAll('</', r'<\/'),
            ),
        ],
      ),
      a(classes: 'skip-link', href: '#main', [.text(s.skipToContent)]),
      SiteHeader(locale: locale, currentRoute: route, translatable: localized),
      main_(id: 'main', attributes: {'tabindex': '-1'}, children),
      SiteFooter(locale: locale),
    ]);
  }

  static Component _og(String property, String content) => meta(attributes: {'property': property}, content: content);

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
