// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:my_portfolio_page/components/copy_button.dart'
    deferred as _copy_button;
import 'package:my_portfolio_page/components/projects_explorer.dart'
    deferred as _projects_explorer;
import 'package:my_portfolio_page/components/theme_toggle.dart'
    deferred as _theme_toggle;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'copy_button': ClientLoader(
      (p) => _copy_button.CopyButton(
        text: p['text'] as String,
        label: p['label'] as String,
        doneLabel: p['doneLabel'] as String,
        failedLabel: p['failedLabel'] as String,
      ),
      loader: _copy_button.loadLibrary,
    ),
    'projects_explorer': ClientLoader(
      (p) => _projects_explorer.ProjectsExplorer(lang: p['lang'] as String),
      loader: _projects_explorer.loadLibrary,
    ),
    'theme_toggle': ClientLoader(
      (p) => _theme_toggle.ThemeToggle(lang: p['lang'] as String),
      loader: _theme_toggle.loadLibrary,
    ),
  },
);
