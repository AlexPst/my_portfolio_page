import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_config.dart';
import '../styles/theme.dart';

/// Элемент цепочки. Последний элемент — текущая страница, у него нет `route`.
typedef Crumb = ({String label, String? route});

class Breadcrumbs extends StatelessComponent {
  const Breadcrumbs({required this.items, required this.label, super.key});

  final List<Crumb> items;

  /// `aria-label` для `<nav>`.
  final String label;

  @override
  Component build(BuildContext context) {
    return nav(
      classes: 'breadcrumbs',
      attributes: {'aria-label': label},
      [
        ol([
          for (final item in items)
            li([
              switch (item.route) {
                final route? => a(href: SiteConfig.href(route), [.text(item.label)]),
                null => span(attributes: {'aria-current': 'page'}, [.text(item.label)]),
              },
            ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.breadcrumbs', [
      css('ol').styles(
        display: .flex,
        padding: .zero,
        margin: .zero,
        flexWrap: .wrap,
        gap: .column(0.5.rem),
        listStyle: .none,
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.8125.rem,
      ),
      css('li:not(:last-child)::after').styles(
        content: '/',
        margin: .only(left: 0.5.rem),
        color: AppColors.border,
      ),
      css('a').styles(color: AppColors.muted),
      css('a:hover').styles(color: AppColors.accent),
      css('[aria-current]').styles(color: AppColors.text),
    ]),
  ];
}
