import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/profile.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({required this.locale, super.key});

  final AppLocale locale;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);
    final year = DateTime.now().year;

    return footer(classes: 'site-footer', [
      div(classes: 'container site-footer__inner', [
        div([
          p(classes: 'site-footer__name', [.text('© $year ${profile.name.of(locale)}')]),
          p(classes: 'site-footer__meta', [
            .text('${s.footerBuiltWith} · '),
            a(href: SiteConfig.sourceUrl, attributes: {'rel': 'noopener'}, [.text(s.footerSource)]),
          ]),
        ]),
        ul(
          classes: 'site-footer__links',
          attributes: {'aria-label': s.footerContactsLabel},
          [
            for (final contact in profile.contacts)
              li([
                a(
                  href: contact.url,
                  attributes: {if (contact.kind != ContactKind.email) 'rel': 'noopener me'},
                  [.text(contact.label)],
                ),
              ]),
          ],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        padding: .symmetric(vertical: 2.rem),
        border: .only(
          top: .solid(color: AppColors.border, width: 1.px),
        ),
        color: AppColors.muted,
        fontSize: 0.9375.rem,
      ),
      css('.site-footer__inner').styles(
        display: .flex,
        flexWrap: .wrap,
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: .all(1.rem),
      ),
      css('.site-footer__name').styles(color: AppColors.text, fontWeight: .w600),
      css('.site-footer__meta').styles(fontSize: 0.875.rem),
      css('.site-footer__links').styles(
        display: .flex,
        padding: .zero,
        margin: .zero,
        flexWrap: .wrap,
        gap: .all(1.rem),
        listStyle: .none,
        fontFamily: AppFonts.mono,
        fontSize: 0.875.rem,
      ),
    ]),
  ];
}
