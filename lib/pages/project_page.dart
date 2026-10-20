import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/breadcrumbs.dart';
import '../components/code_window.dart';
import '../components/page_layout.dart';
import '../data/project.dart';
import '../data/projects.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

/// Страница одного проекта: задача, возможности, решения, архитектура, скриншоты, ссылки.
class ProjectPage extends StatelessComponent {
  const ProjectPage({required this.project, required this.locale, super.key});

  final Project project;
  final AppLocale locale;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);
    final title = project.title.of(locale);

    return PageLayout(
      locale: locale,
      route: project.route,
      title: title,
      description: project.tagline.of(locale),
      children: [
        article(
          classes: 'project',
          styles: Styles(raw: {'--project-accent': project.accent}),
          attributes: {'aria-labelledby': 'project-title'},
          [
            div(classes: 'container', [
              Breadcrumbs(
                label: s.breadcrumbLabel,
                items: [
                  (label: s.navHome, route: locale.path('/')),
                  (label: s.navProjects, route: locale.path('/projects')),
                  (label: title, route: null),
                ],
              ),
              _header(s, title),
              div(classes: 'project__layout', [
                div(classes: 'project__content', [
                  _section(id: 'problem', title: s.projectProblem, [
                    p([.text(project.problem.of(locale))]),
                  ]),
                  _section(id: 'features', title: s.projectFeatures, [
                    ul(classes: 'project__features', [
                      for (final feature in project.features) li([.text(feature.of(locale))]),
                    ]),
                  ]),
                  _section(id: 'decisions', title: s.projectDecisions, [
                    div(classes: 'project__decisions', [
                      for (final (index, decision) in project.decisions.indexed)
                        div(classes: 'decision', [
                          span(
                            classes: 'decision__index',
                            attributes: {'aria-hidden': 'true'},
                            [
                              .text((index + 1).toString().padLeft(2, '0')),
                            ],
                          ),
                          h3(classes: 'decision__title', [.text(decision.title.of(locale))]),
                          p(classes: 'decision__text', [.text(decision.text.of(locale))]),
                        ]),
                    ]),
                  ]),
                  _section(id: 'architecture', title: s.projectArchitecture, [
                    p([.text(project.architecture.of(locale))]),
                    if (project.architectureTree case final tree?)
                      div(classes: 'project__tree', [
                        CodeWindow(source: tree, fileName: 'tree', caption: s.projectArchitecture, highlight: false),
                      ]),
                  ]),
                  if (project.screenshots.isNotEmpty)
                    _section(id: 'screenshots', title: s.projectScreenshots, [_gallery()]),
                ]),
                _aside(s),
              ]),
              _pager(s),
            ]),
          ],
        ),
      ],
    );
  }

  Component _header(Strings s, String title) {
    return header(classes: 'project__header reveal', [
      p(
        classes: 'project__file',
        attributes: {'aria-hidden': 'true'},
        [
          .text('${project.slug.replaceAll('-', '_')}.dart'),
        ],
      ),
      h1(id: 'project-title', classes: 'project__title', [.text(title)]),
      p(classes: 'project__tagline', [.text(project.tagline.of(locale))]),
      dl(classes: 'project__facts', [
        _fact(s.projectYear, '${project.year}'),
        _fact(s.projectStatus, project.status.label.of(locale)),
        _fact(s.projectPlatforms, project.platforms.map((platform) => platform.label).join(', ')),
      ]),
    ]);
  }

  Component _fact(String term, String value) => div(classes: 'project__fact', [
    dt([.text(term)]),
    dd([.text(value)]),
  ]);

  Component _section(List<Component> children, {required String id, required String title}) {
    return section(
      classes: 'project__section reveal-on-scroll',
      attributes: {'aria-labelledby': '$id-title'},
      [
        h2(id: '$id-title', classes: 'section-title', [.text(title)]),
        ...children,
      ],
    );
  }

  Component _gallery() {
    return ul(classes: 'gallery', [
      for (final shot in project.screenshots)
        li([
          a(href: SiteConfig.asset(shot.file), [
            img(
              src: SiteConfig.asset(shot.file),
              alt: shot.alt.of(locale),
              width: shot.width,
              height: shot.height,
              loading: MediaLoading.lazy,
              attributes: {'decoding': 'async'},
            ),
          ]),
        ]),
    ]);
  }

  Component _aside(Strings s) {
    return aside(classes: 'project__aside', [
      div(classes: 'project__panel', [
        h2(classes: 'project__panel-title', [.text(s.projectStack)]),
        ul(classes: 'project__tags', [
          for (final tech in project.tech) li(classes: 'tag', [.text(tech)]),
        ]),
      ]),
      if (project.links.isNotEmpty)
        div(classes: 'project__panel', [
          h2(classes: 'project__panel-title', [.text(s.projectLinks)]),
          ul(classes: 'project__links', [
            for (final link in project.links)
              li([
                a(
                  classes: switch (link) {
                    StoreLink() || DemoLink() => 'btn btn-primary',
                    SourceLink() => 'btn btn-ghost',
                  },
                  href: link.url,
                  target: Target.blank,
                  attributes: {'rel': 'noopener'},
                  [
                    .text(link.label.of(locale)),
                    span(classes: 'visually-hidden', [.text(' ${s.opensInNewTab}')]),
                    const span(attributes: {'aria-hidden': 'true'}, [.text('↗')]),
                  ],
                ),
              ]),
          ]),
        ]),
    ]);
  }

  Component _pager(Strings s) {
    final index = projects.indexOf(project);
    final prev = index > 0 ? projects[index - 1] : null;
    final next = index < projects.length - 1 ? projects[index + 1] : null;

    Component item(Project target, String label, String modifier) => a(
      classes: 'pager__link pager__link--$modifier',
      href: SiteConfig.href(locale.path(target.route)),
      [
        span(classes: 'pager__label', [.text(label)]),
        span(classes: 'pager__title', [.text(target.title.of(locale))]),
      ],
    );

    return nav(
      classes: 'pager',
      attributes: {'aria-label': s.projectPagerLabel},
      [
        if (prev != null) item(prev, '← ${s.projectPrev}', 'prev') else const span([]),
        a(classes: 'pager__all', href: SiteConfig.href(locale.path('/projects')), [.text(s.backToProjects)]),
        if (next != null) item(next, '${s.projectNext} →', 'next') else const span([]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.project', [
      css('&').styles(
        padding: .only(top: 2.rem, bottom: 4.rem),
      ),
      css('.project__header').styles(
        position: const .relative(),
        padding: .symmetric(vertical: 2.5.rem),
        margin: .only(bottom: 1.rem),
        border: .only(
          bottom: .solid(color: AppColors.border, width: 1.px),
        ),
      ),
      css('.project__file').styles(
        margin: .only(bottom: 0.75.rem),
        color: AppColors.accent,
        fontFamily: AppFonts.mono,
        fontSize: 0.875.rem,
      ),
      css('.project__title').styles(raw: {'font-size': 'clamp(2rem, 1.4rem + 3vw, 3.25rem)'}),
      css('.project__tagline').styles(
        maxWidth: 42.rem,
        margin: .only(top: 1.rem),
        color: AppColors.muted,
        fontSize: 1.1875.rem,
      ),
      css('.project__facts').styles(
        display: .flex,
        margin: .only(top: 1.75.rem, bottom: .zero),
        flexWrap: .wrap,
        gap: .all(2.rem),
      ),
      css('.project__fact dt').styles(
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.75.rem,
        textTransform: .upperCase,
        raw: {'letter-spacing': '0.08em'},
      ),
      css('.project__fact dd').styles(
        margin: .fromLTRB(.zero, 0.25.rem, .zero, .zero),
        fontWeight: .w600,
      ),
      css('.project__layout').styles(
        display: .grid,
        alignItems: .start,
        gap: .all(2.5.rem),
        raw: {'grid-template-columns': 'minmax(0, 1fr)'},
      ),
      css('.project__content').styles(minWidth: .zero),
      css('.project__section').styles(padding: .only(top: 2.5.rem)),
      css('.project__section > p').styles(maxWidth: 46.rem),
      css('.project__features').styles(
        display: .grid,
        maxWidth: 46.rem,
        padding: .zero,
        margin: .zero,
        gap: .row(0.625.rem),
        listStyle: .none,
      ),
      css('.project__features li').styles(
        position: const .relative(),
        padding: .only(left: 1.75.rem),
      ),
      css('.project__features li::before').styles(
        content: '▹',
        position: const .absolute(left: .zero),
        color: AppColors.accent,
        fontFamily: AppFonts.mono,
      ),
      css('.project__decisions').styles(
        display: .grid,
        gap: .all(1.rem),
        raw: {'grid-template-columns': 'repeat(auto-fill, minmax(min(100%, 16rem), 1fr))'},
      ),
      css('.project__tree').styles(
        maxWidth: 34.rem,
        margin: .only(top: 1.25.rem),
      ),
      css('.project__aside').styles(display: .grid, gap: .row(1.rem)),
      css('.project__panel').styles(
        padding: .all(1.25.rem),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(14.px),
        backgroundColor: AppColors.surface,
      ),
      css('.project__panel-title').styles(
        margin: .only(bottom: 0.875.rem),
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.8125.rem,
        fontWeight: .w500,
        textTransform: .upperCase,
        raw: {'letter-spacing': '0.08em'},
      ),
      css('.project__tags').styles(
        display: .flex,
        padding: .zero,
        margin: .zero,
        flexWrap: .wrap,
        gap: .all(0.375.rem),
        listStyle: .none,
      ),
      css('.project__links').styles(
        display: .grid,
        padding: .zero,
        margin: .zero,
        gap: .row(0.5.rem),
        listStyle: .none,
      ),
      css('.project__links .btn').styles(width: 100.percent, justifyContent: .spaceBetween),
    ]),
    css('.decision', [
      css('&').styles(
        padding: .all(1.25.rem),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(14.px),
        backgroundColor: AppColors.surface,
        raw: {'border-top': '3px solid var(--project-accent)'},
      ),
      css('.decision__index').styles(color: AppColors.accent, fontFamily: AppFonts.mono, fontSize: 0.8125.rem),
      css('.decision__title').styles(
        margin: .symmetric(vertical: 0.5.rem),
        fontSize: 1.0625.rem,
      ),
      css('.decision__text').styles(color: AppColors.muted, fontSize: 0.9375.rem),
    ]),
    css('.gallery', [
      css('&').styles(
        display: .grid,
        padding: .zero,
        margin: .zero,
        gap: .all(1.rem),
        listStyle: .none,
        raw: {'grid-template-columns': 'repeat(auto-fill, minmax(min(100%, 12rem), 1fr))'},
      ),
      css('img').styles(
        width: 100.percent,
        height: .auto,
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(12.px),
        backgroundColor: AppColors.surfaceRaised,
      ),
    ]),
    css('.pager', [
      css('&').styles(
        display: .grid,
        padding: .only(top: 2.rem),
        margin: .only(top: 3.rem),
        border: .only(
          top: .solid(color: AppColors.border, width: 1.px),
        ),
        alignItems: .center,
        gap: .all(1.rem),
        raw: {'grid-template-columns': '1fr auto 1fr'},
      ),
      css('.pager__link').styles(
        display: .flex,
        flexDirection: .column,
        gap: .row(0.25.rem),
        textDecoration: const TextDecoration(line: .none),
      ),
      css('.pager__link--next').styles(alignItems: .end, textAlign: .right),
      css('.pager__label').styles(color: AppColors.muted, fontFamily: AppFonts.mono, fontSize: 0.8125.rem),
      css('.pager__title').styles(color: AppColors.text, fontWeight: .w600),
      css('.pager__link:hover .pager__title').styles(color: AppColors.accent),
      css('.pager__all').styles(fontFamily: AppFonts.mono, fontSize: 0.875.rem),
    ]),
    css.media(MediaQuery.screen(minWidth: Breakpoints.md.px), [
      css('.project .project__layout').styles(raw: {'grid-template-columns': 'minmax(0, 1fr) 18rem'}),
      css('.project .project__aside').styles(
        position: .sticky(top: 5.5.rem),
        padding: .only(top: 2.5.rem),
      ),
    ]),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.sm.px), [
      css('.pager').styles(raw: {'grid-template-columns': '1fr'}),
      css('.pager .pager__link--next').styles(alignItems: .start, textAlign: .left),
      css('.pager .pager__all').styles(order: -1),
    ]),
  ];
}
