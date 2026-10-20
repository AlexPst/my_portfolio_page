import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/code_window.dart';
import '../components/page_layout.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

/// Страница 404. Собирается в `404.html`, которую GitHub Pages отдаёт на любой
/// неизвестный адрес. Язык заранее неизвестен, поэтому текст на обоих языках.
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  static const _snippet = '''
final page = switch (route) {
  '/' => HomePage(),
  '/projects' => ProjectsPage(),
  '/contacts' => ContactsPage(),
  _ => throw PageNotFound(404),
};''';

  @override
  Component build(BuildContext context) {
    final ru = Strings.of(AppLocale.ru);
    final en = Strings.of(AppLocale.en);

    return PageLayout(
      locale: AppLocale.fallback,
      route: '/404.html',
      title: '${ru.notFoundTitle} · ${en.notFoundTitle}',
      description: ru.notFoundText,
      indexable: false,
      localized: false,
      children: [
        section(
          classes: 'section not-found',
          attributes: {'aria-labelledby': 'not-found-title'},
          [
            div(classes: 'container not-found__inner', [
              div(classes: 'not-found__text reveal', [
                const p(classes: 'not-found__code', attributes: {'aria-hidden': 'true'}, [.text('404')]),
                h1(id: 'not-found-title', [.text(ru.notFoundTitle)]),
                p(classes: 'not-found__lead', [.text(ru.notFoundText)]),
                div(classes: 'not-found__actions', [
                  a(classes: 'btn btn-primary', href: SiteConfig.href(AppLocale.ru.path('/')), [
                    .text(ru.notFoundHome),
                  ]),
                  a(
                    classes: 'btn btn-ghost',
                    href: SiteConfig.href(AppLocale.ru.path('/projects')),
                    [.text(ru.notFoundProjects)],
                  ),
                ]),
                div(
                  classes: 'not-found__en',
                  attributes: {'lang': 'en'},
                  [
                    h2([.text(en.notFoundTitle)]),
                    p([.text(en.notFoundText)]),
                    a(href: SiteConfig.href(AppLocale.en.path('/')), [.text('${en.notFoundHome} →')]),
                  ],
                ),
              ]),
              const div(classes: 'not-found__snippet reveal reveal-2', [
                CodeWindow(source: _snippet, fileName: 'router.dart', caption: 'PageNotFound'),
              ]),
            ]),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.not-found', [
      css('.not-found__inner').styles(
        display: .grid,
        alignItems: .center,
        gap: .all(3.rem),
        raw: {'grid-template-columns': 'minmax(0, 1fr)'},
      ),
      css('.not-found__code').styles(
        color: AppColors.accent,
        fontFamily: AppFonts.mono,
        fontWeight: .w700,
        lineHeight: 1.em,
        raw: {'font-size': 'clamp(4rem, 3rem + 6vw, 8rem)'},
      ),
      css('h1').styles(
        margin: .only(top: 1.rem),
        raw: {'font-size': 'clamp(1.75rem, 1.4rem + 1.5vw, 2.5rem)'},
      ),
      css('.not-found__lead').styles(
        maxWidth: 32.rem,
        margin: .only(top: 0.75.rem),
        color: AppColors.muted,
      ),
      css('.not-found__actions').styles(
        display: .flex,
        margin: .only(top: 1.75.rem),
        flexWrap: .wrap,
        gap: .all(0.75.rem),
      ),
      css('.not-found__en').styles(
        padding: .only(top: 1.5.rem),
        margin: .only(top: 2.5.rem),
        border: .only(
          top: .solid(color: AppColors.border, width: 1.px),
        ),
        color: AppColors.muted,
        fontSize: 0.9375.rem,
      ),
      css('.not-found__en h2').styles(
        margin: .only(bottom: 0.375.rem),
        color: AppColors.text,
        fontSize: 1.125.rem,
      ),
      css('.not-found__en a').styles(
        display: .inlineBlock,
        margin: .only(top: 0.5.rem),
      ),
    ]),
    css.media(MediaQuery.screen(minWidth: Breakpoints.md.px), [
      css('.not-found .not-found__inner').styles(raw: {'grid-template-columns': 'minmax(0, 1fr) minmax(0, 1fr)'}),
    ]),
  ];
}
