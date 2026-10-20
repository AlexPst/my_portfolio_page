// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:my_portfolio_page/components/projects_explorer.dart'
    deferred as _projects_explorer;

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
    'projects_explorer': ClientLoader(
      (p) => _projects_explorer.ProjectsExplorer(lang: p['lang'] as String),
      loader: _projects_explorer.loadLibrary,
    ),
  },
);
