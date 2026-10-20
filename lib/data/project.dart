/// Модели портфолио. Файл без зависимостей от Jaspr: он компилируется
/// и на сервере, и в клиентский бандл фильтра проектов.
library;

import '../l10n/app_locale.dart';

enum ProjectStatus {
  released(label: (ru: 'В релизе', en: 'Released')),
  inDevelopment(label: (ru: 'В разработке', en: 'In development')),
  archived(label: (ru: 'В архиве', en: 'Archived'));

  const ProjectStatus({required this.label});

  final Localized label;
}

enum Platform {
  android('Android'),
  linux('Linux'),
  web('Web');

  const Platform(this.label);

  final String label;
}

enum Store {
  googlePlay('Google Play'),
  ruStore('RuStore');

  const Store(this.label);

  final String label;
}

/// Ссылка проекта. Подпись и иконка выводятся из типа через pattern matching.
sealed class ProjectLink {
  const ProjectLink(this.url);

  final String url;

  Localized get label => switch (this) {
    SourceLink() => (ru: 'Исходный код', en: 'Source code'),
    StoreLink(:final store) => (ru: store.label, en: store.label),
    DemoLink() => (ru: 'Открыть', en: 'Open'),
  };
}

final class SourceLink extends ProjectLink {
  const SourceLink(super.url);
}

final class StoreLink extends ProjectLink {
  const StoreLink(this.store, String url) : super(url);

  final Store store;
}

final class DemoLink extends ProjectLink {
  const DemoLink(super.url);
}

/// Скриншот в `web/images/projects/<slug>/`. Размеры нужны, чтобы не было сдвига макета.
final class Screenshot {
  const Screenshot({required this.file, required this.alt, required this.width, required this.height});

  /// Путь относительно `web/`, например `images/projects/tutor-app/schedule.webp`.
  final String file;
  final Localized alt;
  final int width;
  final int height;
}

/// Ключевое техническое решение: что сделано и зачем.
typedef Decision = ({Localized title, Localized text});

final class Project {
  const Project({
    required this.slug,
    required this.title,
    required this.tagline,
    required this.year,
    required this.status,
    required this.platforms,
    required this.tech,
    required this.accent,
    required this.problem,
    required this.features,
    required this.decisions,
    required this.architecture,
    this.architectureTree,
    this.screenshots = const [],
    this.links = const [],
    this.featured = false,
  });

  /// Часть URL: `/projects/<slug>`.
  final String slug;
  final Localized title;

  /// Одна фраза для карточки и meta description.
  final Localized tagline;
  final int year;
  final ProjectStatus status;
  final List<Platform> platforms;

  /// Технологии. По ним работает фильтр на `/projects`.
  final List<String> tech;

  /// Цвет обложки карточки, CSS hex.
  final String accent;

  /// Задача: какую проблему решает проект.
  final Localized problem;
  final List<Localized> features;
  final List<Decision> decisions;

  /// Описание архитектуры.
  final Localized architecture;

  /// Дерево каталогов, выводится моноширинным блоком.
  final Localized? architectureTree;
  final List<Screenshot> screenshots;
  final List<ProjectLink> links;

  /// Показывать на главной.
  final bool featured;

  String get route => '/projects/$slug';
}
