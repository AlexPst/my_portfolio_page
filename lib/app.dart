import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'data/projects.dart';
import 'l10n/app_locale.dart';
import 'pages/home_page.dart';
import 'pages/project_page.dart';
import 'pages/projects_page.dart';

/// Корневой компонент. При multi-page роутинге выполняется только при генерации,
/// на клиент попадают лишь компоненты с аннотацией `@client`.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        for (final locale in AppLocale.values) ..._routesFor(locale),
      ],
    );
  }

  /// Маршруты одного языка. SSG не поддерживает параметры в пути (`/projects/:slug`),
  /// поэтому страница каждого проекта регистрируется явно из списка данных.
  List<RouteBase> _routesFor(AppLocale locale) => [
    Route(
      path: locale.path('/'),
      builder: (_, _) => HomePage(locale: locale),
    ),
    Route(
      path: locale.path('/projects'),
      builder: (_, _) => ProjectsPage(locale: locale),
    ),
    for (final project in projects)
      Route(
        path: locale.path(project.route),
        builder: (_, _) => ProjectPage(project: project, locale: locale),
      ),
  ];
}
