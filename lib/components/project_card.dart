import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/project.dart';
import '../data/site_config.dart';
import '../l10n/app_locale.dart';
import '../styles/theme.dart';

/// Карточка проекта. Используется на главной и внутри клиентского фильтра,
/// поэтому не зависит от серверного окружения.
class ProjectCard extends StatelessComponent {
  const ProjectCard({required this.project, required this.locale, this.headingLevel = 2, super.key});

  final Project project;
  final AppLocale locale;

  /// Уровень заголовка карточки: 2 на `/projects`, 3 внутри секции на главной.
  final int headingLevel;

  @override
  Component build(BuildContext context) {
    final title = project.title.of(locale);
    final link = a(href: SiteConfig.href(locale.path(project.route)), classes: 'project-card__link', [.text(title)]);

    return article(
      classes: 'project-card',
      styles: Styles(raw: {'--project-accent': project.accent}),
      [
        div(
          classes: 'project-card__cover',
          attributes: {'aria-hidden': 'true'},
          [
            span(classes: 'project-card__file', [.text('${project.slug.replaceAll('-', '_')}.dart')]),
            span(classes: 'project-card__platforms', [
              .text(project.platforms.map((platform) => platform.label).join(' · ')),
            ]),
          ],
        ),
        div(classes: 'project-card__body', [
          p(classes: 'project-card__meta', [
            .text('${project.year} · '),
            span(classes: 'project-card__status project-card__status--${project.status.name}', [
              .text(project.status.label.of(locale)),
            ]),
          ]),
          headingLevel == 3 ? h3(classes: 'project-card__title', [link]) : h2(classes: 'project-card__title', [link]),
          p(classes: 'project-card__tagline', [.text(project.tagline.of(locale))]),
          ul(classes: 'project-card__tags', [
            for (final tech in project.tech) li(classes: 'tag', [.text(tech)]),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.project-card', [
      css('&').styles(
        display: .flex,
        position: const .relative(),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(16.px),
        overflow: .hidden,
        transition: Transition.combine([
          Transition('border-color', duration: 200.ms),
          Transition('transform', duration: 200.ms),
          Transition('box-shadow', duration: 200.ms),
        ]),
        flexDirection: .column,
        backgroundColor: AppColors.surface,
      ),
      css('&:hover').styles(
        border: .all(color: const Color.variable('--project-accent'), style: .solid, width: 1.px),
        transform: Transform.translate(y: (-3).px),
        raw: {'box-shadow': '0 18px 40px -24px var(--project-accent)'},
      ),
      // Фокус ссылки подсвечивает всю карточку.
      css('&:focus-within').styles(
        outline: Outline(color: AppColors.focus, style: .solid, width: OutlineWidth(2.px), offset: 3.px),
      ),
      css('.project-card__cover').styles(
        display: .flex,
        position: const .relative(),
        padding: .all(1.rem),
        flexDirection: .column,
        justifyContent: .spaceBetween,
        color: Colors.white,
        fontFamily: AppFonts.mono,
        fontSize: 0.8125.rem,
        raw: {
          'aspect-ratio': '16 / 7',
          'background':
              'linear-gradient(rgba(255,255,255,.08) 1px, transparent 1px) 0 0 / 24px 24px, '
              'linear-gradient(90deg, rgba(255,255,255,.08) 1px, transparent 1px) 0 0 / 24px 24px, '
              'linear-gradient(135deg, var(--project-accent), color-mix(in srgb, var(--project-accent) 35%, #050a14))',
        },
      ),
      css('.project-card__file').styles(
        fontSize: 1.0625.rem,
        fontWeight: .w700,
        raw: {'text-shadow': '0 1px 2px rgba(0,0,0,.35)'},
      ),
      css('.project-card__platforms').styles(opacity: 0.9, alignSelf: .end),
      css('.project-card__body').styles(
        display: .flex,
        padding: .all(1.25.rem),
        flexDirection: .column,
        gap: .row(0.625.rem),
        flex: const Flex(grow: 1),
      ),
      css('.project-card__meta').styles(color: AppColors.muted, fontFamily: AppFonts.mono, fontSize: 0.8125.rem),
      css('.project-card__status--released').styles(color: const Color.variable('--success')),
      css('.project-card__status--inDevelopment').styles(color: AppColors.accent),
      css('.project-card__title').styles(fontSize: 1.25.rem),
      css('.project-card__link', [
        css('&').styles(
          color: AppColors.text,
          textDecoration: const TextDecoration(line: .none),
        ),
        // Растянутая ссылка: кликабельна вся карточка, в дереве доступности одна ссылка.
        css('&::after').styles(
          content: '',
          position: const .absolute(top: .zero, left: .zero, bottom: .zero, right: .zero),
        ),
        css('&:focus-visible').styles(outline: .unset),
      ]),
      css('.project-card__tagline').styles(color: AppColors.muted, fontSize: 0.9375.rem),
      css('.project-card__tags').styles(
        display: .flex,
        padding: .zero,
        margin: const .only(top: .auto),
        flexWrap: .wrap,
        gap: .all(0.375.rem),
        listStyle: .none,
        raw: {'padding-top': '0.5rem'},
      ),
    ]),
  ];
}
