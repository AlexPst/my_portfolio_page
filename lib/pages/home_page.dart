import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/code_window.dart';
import '../components/page_layout.dart';
import '../components/project_card.dart';
import '../data/profile.dart';
import '../data/projects.dart';
import '../data/site_config.dart';
import '../data/skills.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

class HomePage extends StatelessComponent {
  const HomePage({required this.locale, super.key});

  final AppLocale locale;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);

    return PageLayout(
      locale: locale,
      route: '/',
      title: s.homeTitle,
      description: s.homeDescription,
      children: [
        _hero(s),
        _about(s),
        _featured(s),
        _stack(s),
      ],
    );
  }

  Component _hero(Strings s) {
    return section(
      classes: 'hero',
      attributes: {'aria-labelledby': 'hero-title'},
      [
        div(classes: 'container hero__inner', [
          div(classes: 'hero__text', [
            p(classes: 'hero__eyebrow reveal', [
              const span(classes: 'hero__status', attributes: {'aria-hidden': 'true'}, []),
              .text('${profile.level.of(locale)} · ${profile.city.of(locale)}'),
            ]),
            h1(id: 'hero-title', classes: 'hero__title reveal reveal-1', [
              span(classes: 'hero__greeting', [.text(s.heroGreeting)]),
              .text(profile.name.of(locale)),
            ]),
            p(classes: 'hero__role reveal reveal-2', [.text(profile.role.of(locale))]),
            p(classes: 'hero__lead reveal reveal-2', [.text(profile.openTo.of(locale))]),
            div(classes: 'hero__actions reveal reveal-3', [
              a(classes: 'btn btn-primary', href: SiteConfig.href(locale.path('/contacts')), [.text(s.heroCtaContact)]),
              a(classes: 'btn btn-ghost', href: SiteConfig.href(locale.path('/projects')), [.text(s.heroCtaProjects)]),
            ]),
          ]),
          div(classes: 'hero__code reveal reveal-4', [
            CodeWindow(source: _heroSnippet(), fileName: 'about_me.dart', caption: s.heroCodeCaption),
          ]),
        ]),
      ],
    );
  }

  String _heroSnippet() {
    final stack = skillGroups.expand((g) => g.items).take(3).map((item) => "'$item'").join(', ');
    final comment = switch (locale) {
      AppLocale.ru => '// Ищу команду, где можно расти',
      AppLocale.en => '// Looking for a team to grow with',
    };
    return '''
final me = Developer(
  name: '${profile.shortName.of(locale)}',
  role: Role.flutter,
  city: '${profile.city.of(locale)}',
  stack: [$stack],
);

$comment
void main() => me.build(offline: true);''';
  }

  Component _about(Strings s) {
    return section(
      id: 'about',
      classes: 'section',
      attributes: {'aria-labelledby': 'about-title'},
      [
        div(classes: 'container about reveal-on-scroll', [
          h2(id: 'about-title', classes: 'section-title', [.text(s.aboutTitle)]),
          div(classes: 'about__body', [
            for (final paragraph in profile.about) p([.text(paragraph.of(locale))]),
          ]),
        ]),
      ],
    );
  }

  Component _featured(Strings s) {
    return section(
      id: 'projects',
      classes: 'section',
      attributes: {'aria-labelledby': 'featured-title'},
      [
        div(classes: 'container reveal-on-scroll', [
          div(classes: 'featured__head', [
            h2(id: 'featured-title', classes: 'section-title', [.text(s.featuredTitle)]),
            a(classes: 'featured__all', href: SiteConfig.href(locale.path('/projects')), [.text('${s.allProjects} →')]),
          ]),
          ul(classes: 'featured__grid', [
            for (final project in projects.where((project) => project.featured))
              li([ProjectCard(project: project, locale: locale, headingLevel: 3)]),
          ]),
        ]),
      ],
    );
  }

  Component _stack(Strings s) {
    return section(
      id: 'stack',
      classes: 'section',
      attributes: {'aria-labelledby': 'stack-title'},
      [
        div(classes: 'container reveal-on-scroll', [
          h2(id: 'stack-title', classes: 'section-title', [.text(s.stackTitle)]),
          div(classes: 'stack', [
            for (final group in skillGroups)
              div(classes: 'stack__group', [
                h3(classes: 'stack__title', [.text(group.title.of(locale))]),
                ul(classes: 'stack__list', [
                  for (final item in group.items) li(classes: 'tag', [.text(item)]),
                ]),
              ]),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.featured__head').styles(
      display: .flex,
      margin: .only(bottom: 1.5.rem),
      flexWrap: .wrap,
      justifyContent: .spaceBetween,
      alignItems: .baseline,
      gap: .all(1.rem),
    ),
    css('.featured__head .section-title').styles(margin: .zero),
    css('.featured__all').styles(fontFamily: AppFonts.mono, fontSize: 0.9375.rem),
    css('.featured__grid').styles(
      display: .grid,
      padding: .zero,
      margin: .zero,
      gap: .all(1.25.rem),
      listStyle: .none,
      raw: {'grid-template-columns': 'repeat(auto-fill, minmax(min(100%, 20rem), 1fr))'},
    ),
    css('.featured__grid > li').styles(display: .flex),
    css('.featured__grid .project-card').styles(width: 100.percent),
    css('.hero', [
      css('&').styles(
        position: const .relative(),
        padding: .only(top: 4.rem, bottom: 3.rem),
        overflow: .hidden,
      ),
      // Инженерная сетка на фоне, гаснущая к краям.
      css('&::before').styles(
        content: '',
        position: const .absolute(top: .zero, left: .zero, bottom: .zero, right: .zero),
        zIndex: const ZIndex(-1),
        pointerEvents: .none,
        raw: {
          'background-image':
              'linear-gradient(var(--grid) 1px, transparent 1px), linear-gradient(90deg, var(--grid) 1px, transparent 1px)',
          'background-size': '32px 32px',
          'mask-image': 'radial-gradient(ellipse 80% 70% at 60% 40%, #000 30%, transparent 75%)',
          '-webkit-mask-image': 'radial-gradient(ellipse 80% 70% at 60% 40%, #000 30%, transparent 75%)',
        },
      ),
      css('.hero__inner').styles(
        display: .grid,
        alignItems: .center,
        gap: .all(3.rem),
        raw: {'grid-template-columns': 'minmax(0, 1fr)'},
      ),
      css('.hero__eyebrow').styles(
        display: .inlineFlex,
        margin: .only(bottom: 1.25.rem),
        alignItems: .center,
        gap: .column(0.5.rem),
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.875.rem,
      ),
      css('.hero__status').styles(
        width: 0.5.rem,
        height: 0.5.rem,
        radius: .circular(50.percent),
        backgroundColor: const Color('#22c55e'),
        raw: {'box-shadow': '0 0 0 4px rgba(34, 197, 94, 0.18)'},
      ),
      css('.hero__title').styles(raw: {'font-size': 'clamp(2.25rem, 1.6rem + 3vw, 3.75rem)'}),
      css('.hero__greeting').styles(
        display: .block,
        margin: .only(bottom: 0.25.rem),
        color: AppColors.muted,
        fontSize: 0.5.em,
        fontWeight: .w500,
        raw: {'letter-spacing': '0'},
      ),
      css('.hero__role').styles(
        margin: .only(top: 1.rem),
        color: AppColors.accent,
        fontFamily: AppFonts.mono,
        fontWeight: .w500,
        raw: {'font-size': 'clamp(1.05rem, 0.95rem + 0.5vw, 1.3rem)'},
      ),
      css('.hero__lead').styles(
        maxWidth: 34.rem,
        margin: .only(top: 0.75.rem),
        color: AppColors.muted,
      ),
      css('.hero__actions').styles(
        display: .flex,
        margin: .only(top: 2.rem),
        flexWrap: .wrap,
        gap: .all(0.75.rem),
      ),
      css('.hero__code').styles(minWidth: .zero),
    ]),
    css.media(MediaQuery.screen(minWidth: Breakpoints.md.px), [
      css('.hero').styles(
        padding: .only(top: 6.rem, bottom: 5.rem),
      ),
      css('.hero .hero__inner').styles(raw: {'grid-template-columns': 'minmax(0, 1.05fr) minmax(0, 1fr)'}),
    ]),
    css('.about__body').styles(
      display: .grid,
      maxWidth: 46.rem,
      gap: .row(1.rem),
      color: AppColors.text,
      fontSize: 1.125.rem,
    ),
    css('.stack', [
      css('&').styles(
        display: .grid,
        gap: .all(1.rem),
        raw: {'grid-template-columns': 'repeat(auto-fill, minmax(min(100%, 15rem), 1fr))'},
      ),
      css('.stack__group').styles(
        padding: .all(1.25.rem),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(14.px),
        backgroundColor: AppColors.surface,
      ),
      css('.stack__title').styles(
        margin: .only(bottom: 0.875.rem),
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.875.rem,
        fontWeight: .w500,
        raw: {'letter-spacing': '0'},
      ),
      css('.stack__list').styles(
        display: .flex,
        padding: .zero,
        margin: .zero,
        flexWrap: .wrap,
        gap: .all(0.5.rem),
        listStyle: .none,
      ),
    ]),
  ];
}
