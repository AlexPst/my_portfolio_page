import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'data/projects.dart';
import 'l10n/app_locale.dart';
import 'pages/contacts_page.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
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
        // GitHub Pages отдаёт 404.html на любой неизвестный адрес.
        Route(path: '/404.html', builder: (_, _) => const NotFoundPage()),
      ],
      // Неизвестные адреса в `jaspr serve`.
      errorBuilder: (_, _) => const NotFoundPage(),
    );
  }

  /// Маршруты одного языка. SSG не поддерживает параметры в пути (`/projects/:slug`),
  /// поэтому страница каждого проекта регистрируется явно из списка данных.
  /// `settings` попадают в sitemap.xml.
  List<RouteBase> _routesFor(AppLocale locale) => [
    Route(
      path: locale.path('/'),
      settings: const RouteSettings(priority: 1.0, changeFreq: ChangeFreq.monthly),
      builder: (_, _) => HomePage(locale: locale),
    ),
    Route(
      path: locale.path('/projects'),
      settings: const RouteSettings(priority: 0.9, changeFreq: ChangeFreq.monthly),
      builder: (_, _) => ProjectsPage(locale: locale),
    ),
    for (final project in projects)
      Route(
        path: locale.path(project.route),
        settings: const RouteSettings(priority: 0.8, changeFreq: ChangeFreq.monthly),
        builder: (_, _) => ProjectPage(project: project, locale: locale),
      ),
    Route(
      path: locale.path('/contacts'),
      settings: const RouteSettings(priority: 0.6, changeFreq: ChangeFreq.yearly),
      builder: (_, _) => ContactsPage(locale: locale),
    ),
  ];
}
