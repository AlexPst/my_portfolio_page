// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:my_portfolio_page/components/breadcrumbs.dart' as _breadcrumbs;
import 'package:my_portfolio_page/components/code_window.dart' as _code_window;
import 'package:my_portfolio_page/components/copy_button.dart' as _copy_button;
import 'package:my_portfolio_page/components/page_layout.dart' as _page_layout;
import 'package:my_portfolio_page/components/project_card.dart'
    as _project_card;
import 'package:my_portfolio_page/components/projects_explorer.dart'
    as _projects_explorer;
import 'package:my_portfolio_page/components/site_footer.dart' as _site_footer;
import 'package:my_portfolio_page/components/site_header.dart' as _site_header;
import 'package:my_portfolio_page/components/theme_toggle.dart'
    as _theme_toggle;
import 'package:my_portfolio_page/pages/contacts_page.dart' as _contacts_page;
import 'package:my_portfolio_page/pages/home_page.dart' as _home_page;
import 'package:my_portfolio_page/pages/not_found_page.dart' as _not_found_page;
import 'package:my_portfolio_page/pages/project_page.dart' as _project_page;
import 'package:my_portfolio_page/pages/projects_page.dart' as _projects_page;
import 'package:my_portfolio_page/styles/fonts.dart' as _fonts;
import 'package:my_portfolio_page/styles/theme.dart' as _theme;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _copy_button.CopyButton: ClientTarget<_copy_button.CopyButton>(
      'copy_button',
      params: __copy_buttonCopyButton,
    ),
    _projects_explorer.ProjectsExplorer:
        ClientTarget<_projects_explorer.ProjectsExplorer>(
          'projects_explorer',
          params: __projects_explorerProjectsExplorer,
        ),
    _theme_toggle.ThemeToggle: ClientTarget<_theme_toggle.ThemeToggle>(
      'theme_toggle',
      params: __theme_toggleThemeToggle,
    ),
  },
  styles: () => [
    ..._fonts.fontStyles,
    ..._theme.themeStyles,
    ..._breadcrumbs.Breadcrumbs.styles,
    ..._code_window.CodeWindow.styles,
    ..._copy_button.CopyButton.styles,
    ..._page_layout.PageLayout.styles,
    ..._project_card.ProjectCard.styles,
    ..._projects_explorer.ProjectsExplorer.styles,
    ..._site_footer.SiteFooter.styles,
    ..._site_header.SiteHeader.styles,
    ..._theme_toggle.ThemeToggle.styles,
    ..._contacts_page.ContactsPage.styles,
    ..._home_page.HomePage.styles,
    ..._not_found_page.NotFoundPage.styles,
    ..._project_page.ProjectPage.styles,
    ..._projects_page.ProjectsPage.styles,
  ],
);

Map<String, Object?> __copy_buttonCopyButton(_copy_button.CopyButton c) => {
  'text': c.text,
  'label': c.label,
  'doneLabel': c.doneLabel,
  'failedLabel': c.failedLabel,
};
Map<String, Object?> __projects_explorerProjectsExplorer(
  _projects_explorer.ProjectsExplorer c,
) => {'lang': c.lang};
Map<String, Object?> __theme_toggleThemeToggle(_theme_toggle.ThemeToggle c) => {
  'lang': c.lang,
};
