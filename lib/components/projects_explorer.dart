import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/project.dart';
import '../data/projects.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';
import 'project_card.dart';

/// Список проектов с фильтром по технологиям.
///
/// `@client`: при сборке рендерится в HTML (весь список виден без JS),
/// а в браузере гидрируется и начинает реагировать на кнопки фильтра.
/// Параметры `@client`-компонента сериализуются, поэтому язык передаётся строкой.
@client
class ProjectsExplorer extends StatefulComponent {
  const ProjectsExplorer({required this.lang, super.key});

  /// Код языка: значение `AppLocale.name`.
  final String lang;

  @override
  State<ProjectsExplorer> createState() => _ProjectsExplorerState();

  @css
  static List<StyleRule> get styles => [
    css('.explorer', [
      css('.explorer__filters').styles(
        display: .flex,
        flexWrap: .wrap,
        gap: .all(0.5.rem),
      ),
      css('.explorer__chip', [
        css('&').styles(
          display: .inlineFlex,
          padding: .symmetric(vertical: 0.4375.rem, horizontal: 0.875.rem),
          border: .all(color: AppColors.border, style: .solid, width: 1.px),
          radius: .circular(999.px),
          cursor: .pointer,
          transition: Transition.combine([
            Transition('background-color', duration: 150.ms),
            Transition('border-color', duration: 150.ms),
            Transition('color', duration: 150.ms),
          ]),
          alignItems: .center,
          gap: .column(0.5.rem),
          color: AppColors.text,
          fontFamily: AppFonts.mono,
          fontSize: 0.875.rem,
          backgroundColor: AppColors.surface,
        ),
        css('&:hover').styles(
          border: .all(color: AppColors.accent, style: .solid, width: 1.px),
        ),
        css('&[aria-pressed="true"]').styles(
          border: .all(color: AppColors.accentStrong, style: .solid, width: 1.px),
          color: AppColors.onAccent,
          backgroundColor: AppColors.accentStrong,
        ),
      ]),
      css('.explorer__count').styles(
        padding: .symmetric(horizontal: 0.4375.rem),
        radius: .circular(999.px),
        fontSize: 0.75.rem,
        raw: {'background-color': 'color-mix(in srgb, currentColor 14%, transparent)'},
      ),
      css('.explorer__status').styles(
        margin: .symmetric(vertical: 1.25.rem),
        color: AppColors.muted,
        fontFamily: AppFonts.mono,
        fontSize: 0.875.rem,
      ),
      css('.explorer__empty').styles(
        padding: .all(2.rem),
        border: .all(color: AppColors.border, style: .dashed, width: 1.px),
        radius: .circular(16.px),
        color: AppColors.muted,
        textAlign: .center,
      ),
      css('.explorer__grid').styles(
        display: .grid,
        padding: .zero,
        margin: .zero,
        gap: .all(1.25.rem),
        listStyle: .none,
        raw: {'grid-template-columns': 'repeat(auto-fill, minmax(min(100%, 20rem), 1fr))'},
      ),
      css('.explorer__grid > li').styles(display: .flex),
      css('.explorer__grid .project-card').styles(width: 100.percent),
    ]),
  ];
}

class _ProjectsExplorerState extends State<ProjectsExplorer> {
  /// Выбранная технология; `null` — показать все.
  String? _selected;

  AppLocale get _locale => AppLocale.values.asNameMap()[component.lang] ?? AppLocale.fallback;

  List<Project> get _visible => switch (_selected) {
    null => projects,
    final tech => projects.where((project) => project.tech.contains(tech)).toList(),
  };

  void _select(String? tech) => setState(() => _selected = _selected == tech ? null : tech);

  @override
  Component build(BuildContext context) {
    final s = Strings.of(_locale);
    final visible = _visible;

    return div(classes: 'explorer', [
      div(
        classes: 'explorer__filters',
        attributes: {'role': 'group', 'aria-label': s.filterLabel},
        [
          _chip(label: s.filterAll, count: projects.length, pressed: _selected == null, onTap: () => _select(null)),
          for (final tech in allTech)
            _chip(
              label: tech,
              count: projects.where((project) => project.tech.contains(tech)).length,
              pressed: _selected == tech,
              onTap: () => _select(tech),
            ),
        ],
      ),
      p(
        classes: 'explorer__status',
        attributes: {'role': 'status', 'aria-live': 'polite'},
        [.text(s.projectsShown(visible.length))],
      ),
      if (visible.isEmpty)
        p(classes: 'explorer__empty', [.text(s.projectsEmpty)])
      else
        ul(classes: 'explorer__grid', [
          for (final project in visible)
            li(key: ValueKey(project.slug), [ProjectCard(project: project, locale: _locale)]),
        ]),
    ]);
  }

  Component _chip({required String label, required int count, required bool pressed, required VoidCallback onTap}) {
    return button(
      type: ButtonType.button,
      classes: 'explorer__chip',
      attributes: {'aria-pressed': '$pressed'},
      onClick: onTap,
      [
        .text(label),
        span(classes: 'explorer__count', attributes: {'aria-hidden': 'true'}, [.text('$count')]),
      ],
    );
  }
}
