import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/copy_button.dart';
import '../components/icons.dart';
import '../components/page_layout.dart';
import '../data/profile.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

class ContactsPage extends StatelessComponent {
  const ContactsPage({required this.locale, super.key});

  final AppLocale locale;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);

    return PageLayout(
      locale: locale,
      route: '/contacts',
      title: s.contactsTitle,
      description: s.contactsDescription,
      ogType: OgType.profile,
      structuredData: _person(),
      children: [
        section(
          classes: 'section contacts',
          attributes: {'aria-labelledby': 'contacts-title'},
          [
            div(classes: 'container', [
              header(classes: 'contacts__header reveal', [
                h1(id: 'contacts-title', classes: 'contacts__title', [.text(s.contactsTitle)]),
                p(classes: 'contacts__intro', [.text(s.contactsIntro)]),
              ]),
              ul(
                classes: 'contacts__list reveal reveal-1',
                attributes: {'aria-label': s.contactsListLabel},
                [
                  for (final contact in profile.contacts) li([_card(contact, s)]),
                ],
              ),
              dl(classes: 'contacts__facts reveal reveal-2', [
                div([
                  dt([.text(s.contactsLocation)]),
                  dd([.text(s.contactsLocationValue)]),
                ]),
              ]),
            ]),
          ],
        ),
      ],
    );
  }

  Component _card(Contact contact, Strings s) {
    final isEmail = contact.kind == ContactKind.email;

    return div(classes: 'contact-card contact-card--${contact.kind.name}', [
      span(classes: 'contact-card__icon', [contactIcon(contact.kind)]),
      div(classes: 'contact-card__body', [
        span(classes: 'contact-card__kind', [.text(contact.kind.label.of(locale))]),
        a(
          classes: 'contact-card__link',
          href: contact.url,
          attributes: {if (!isEmail) 'rel': 'noopener me'},
          [.text(contact.label)],
        ),
      ]),
      if (isEmail)
        CopyButton(
          text: contact.label,
          label: s.contactsCopy,
          doneLabel: s.contactsCopied,
          failedLabel: s.contactsCopyFailed,
        ),
    ]);
  }

  /// schema.org/Person: имя, должность, город и профили.
  Map<String, Object?> _person() => {
    '@context': 'https://schema.org',
    '@type': 'Person',
    'name': profile.name.of(locale),
    'jobTitle': profile.role.of(locale),
    'url': SiteConfig.absolute(locale.path('/')),
    'address': {'@type': 'PostalAddress', 'addressLocality': profile.city.of(locale), 'addressCountry': 'RU'},
    if (profile.contact(ContactKind.email) case final email?) 'email': email.url,
    'sameAs': [
      for (final c in profile.contacts)
        if (c.kind != ContactKind.email) c.url,
    ],
  };

  @css
  static List<StyleRule> get styles => [
    css('.contacts', [
      css('.contacts__header').styles(margin: .only(bottom: 2.rem)),
      css('.contacts__title').styles(raw: {'font-size': 'clamp(2rem, 1.5rem + 2.5vw, 3rem)'}),
      css('.contacts__title::before').styles(
        content: '> ',
        color: AppColors.accent,
        fontFamily: AppFonts.mono,
        fontWeight: .w400,
      ),
      css('.contacts__intro').styles(
        maxWidth: 40.rem,
        margin: .only(top: 0.75.rem),
        color: AppColors.muted,
        fontSize: 1.125.rem,
      ),
      css('.contacts__list').styles(
        display: .grid,
        maxWidth: 40.rem,
        padding: .zero,
        margin: .zero,
        gap: .all(1.rem),
        listStyle: .none,
      ),
      css('.contacts__facts').styles(
        display: .flex,
        margin: .only(top: 2.rem),
        flexWrap: .wrap,
        gap: .all(2.rem),
      ),
      css('.contacts__facts dt').styles(
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.75.rem,
        textTransform: .upperCase,
        raw: {'letter-spacing': '0.08em'},
      ),
      css('.contacts__facts dd').styles(margin: .fromLTRB(.zero, 0.25.rem, .zero, .zero), fontWeight: .w600),
    ]),
    css('.contact-card', [
      css('&').styles(
        display: .flex,
        position: const .relative(),
        padding: .all(1.25.rem),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(16.px),
        transition: Transition('border-color', duration: 200.ms),
        flexWrap: .wrap,
        alignItems: .center,
        gap: .all(1.rem),
        backgroundColor: AppColors.surface,
      ),
      css('&:hover').styles(
        border: .all(color: AppColors.accent, style: .solid, width: 1.px),
      ),
      css('&:focus-within').styles(
        outline: Outline(color: AppColors.focus, style: .solid, width: OutlineWidth(2.px), offset: 3.px),
      ),
      css('.contact-card__icon').styles(
        display: .flex,
        width: 3.rem,
        height: 3.rem,
        radius: .circular(12.px),
        justifyContent: .center,
        alignItems: .center,
        color: AppColors.accent,
        backgroundColor: AppColors.surfaceRaised,
        raw: {'flex-shrink': '0'},
      ),
      // Базис 12rem: блок остаётся рядом с иконкой, а на новую строку уходит кнопка.
      css('.contact-card__body').styles(
        display: .flex,
        minWidth: .zero,
        flexDirection: .column,
        raw: {'flex': '1 1 12rem'},
      ),
      css('.contact-card__kind').styles(color: AppColors.muted, fontSize: 0.875.rem),
      // Длинный адрес переносится, а не обрезается: контакт должен читаться целиком.
      css('.contact-card__link').styles(
        color: AppColors.text,
        fontFamily: AppFonts.mono,
        fontWeight: .w600,
        textDecoration: const TextDecoration(line: .none),
        raw: {'overflow-wrap': 'anywhere'},
      ),
      // Растянутая ссылка; кнопка копирования лежит поверх неё.
      css('.contact-card__link::after').styles(
        content: '',
        position: const .absolute(top: .zero, left: .zero, bottom: .zero, right: .zero),
      ),
      css('.contact-card__link:focus-visible').styles(outline: .unset),
      css('.copy-button').styles(position: const .relative(), zIndex: const ZIndex(1)),
    ]),
  ];
}
