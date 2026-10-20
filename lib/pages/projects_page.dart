import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/page_layout.dart';
import '../components/projects_explorer.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../styles/theme.dart';

class ProjectsPage extends StatelessComponent {
  const ProjectsPage({required this.locale, super.key});

  final AppLocale locale;

  @override
  Component build(BuildContext context) {
    final s = Strings.of(locale);

    return PageLayout(
      locale: locale,
      route: '/projects',
      title: s.projectsTitle,
      description: s.projectsDescription,
      children: [
        section(
          classes: 'section projects-page',
          attributes: {'aria-labelledby': 'projects-title'},
          [
            div(classes: 'container', [
              header(classes: 'projects-page__header reveal', [
                h1(id: 'projects-title', classes: 'projects-page__title', [.text(s.projectsTitle)]),
                p(classes: 'projects-page__intro', [.text(s.projectsIntro)]),
              ]),
              div(classes: 'reveal reveal-1', [ProjectsExplorer(lang: locale.name)]),
            ]),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects-page__header').styles(margin: .only(bottom: 2.rem)),
    css('.projects-page__title').styles(raw: {'font-size': 'clamp(2rem, 1.5rem + 2.5vw, 3rem)'}),
    css('.projects-page__title::before').styles(
      content: '> ',
      color: AppColors.accent,
      fontFamily: AppFonts.mono,
      fontWeight: .w400,
    ),
    css('.projects-page__intro').styles(
      maxWidth: 40.rem,
      margin: .only(top: 0.75.rem),
      color: AppColors.muted,
    ),
  ];
}
