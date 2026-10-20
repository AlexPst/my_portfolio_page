import 'app_locale.dart';

/// Строки интерфейса. Данные профиля и проектов лежат в `lib/data`.
final class Strings {
  const Strings({
    required this.skipToContent,
    required this.navHome,
    required this.navProjects,
    required this.navContacts,
    required this.mainNavLabel,
    required this.heroGreeting,
    required this.heroCtaContact,
    required this.heroCtaProjects,
    required this.heroCodeCaption,
    required this.aboutTitle,
    required this.stackTitle,
    required this.featuredTitle,
    required this.allProjects,
    required this.homeTitle,
    required this.homeDescription,
    required this.projectsTitle,
    required this.projectsDescription,
    required this.projectsIntro,
    required this.filterLabel,
    required this.filterAll,
    required this.projectsShown,
    required this.projectsEmpty,
    required this.breadcrumbLabel,
    required this.projectProblem,
    required this.projectFeatures,
    required this.projectDecisions,
    required this.projectArchitecture,
    required this.projectScreenshots,
    required this.projectLinks,
    required this.projectYear,
    required this.projectStatus,
    required this.projectPlatforms,
    required this.projectStack,
    required this.projectPrev,
    required this.projectNext,
    required this.projectPagerLabel,
    required this.backToProjects,
    required this.opensInNewTab,
    required this.footerBuiltWith,
    required this.footerSource,
    required this.footerContactsLabel,
  });

  final String skipToContent;
  final String navHome;
  final String navProjects;
  final String navContacts;
  final String mainNavLabel;
  final String heroGreeting;
  final String heroCtaContact;
  final String heroCtaProjects;
  final String heroCodeCaption;
  final String aboutTitle;
  final String stackTitle;
  final String featuredTitle;
  final String allProjects;
  final String homeTitle;
  final String homeDescription;
  final String projectsTitle;
  final String projectsDescription;
  final String projectsIntro;
  final String filterLabel;
  final String filterAll;

  /// Текст для live-региона фильтра: «Показано: 2 проекта».
  final String Function(int count) projectsShown;
  final String projectsEmpty;
  final String breadcrumbLabel;
  final String projectProblem;
  final String projectFeatures;
  final String projectDecisions;
  final String projectArchitecture;
  final String projectScreenshots;
  final String projectLinks;
  final String projectYear;
  final String projectStatus;
  final String projectPlatforms;
  final String projectStack;
  final String projectPrev;
  final String projectNext;
  final String projectPagerLabel;
  final String backToProjects;
  final String opensInNewTab;
  final String footerBuiltWith;
  final String footerSource;
  final String footerContactsLabel;

  static Strings of(AppLocale locale) => switch (locale) {
    AppLocale.ru => _ru,
    AppLocale.en => _en,
  };

  static const _ru = Strings(
    skipToContent: 'Перейти к содержимому',
    navHome: 'Главная',
    navProjects: 'Проекты',
    navContacts: 'Контакты',
    mainNavLabel: 'Основная навигация',
    heroGreeting: 'Привет, я',
    heroCtaContact: 'Связаться',
    heroCtaProjects: 'Проекты',
    heroCodeCaption: 'Обо мне на Dart',
    aboutTitle: 'Обо мне',
    stackTitle: 'Стек',
    featuredTitle: 'Избранные проекты',
    allProjects: 'Все проекты',
    homeTitle: 'Dart / Flutter-разработчик',
    homeDescription:
        'Алексей Поступинский — Dart/Flutter-разработчик из Екатеринбурга. '
        'Мобильные и десктопные приложения на Flutter: Riverpod, Drift, Clean Architecture.',
    projectsTitle: 'Проекты',
    projectsDescription: 'Проекты Алексея Поступинского на Flutter и Dart: задачи, архитектура и технические решения.',
    projectsIntro: 'Что я сделал и как это устроено внутри. Выберите технологию, чтобы отфильтровать список.',
    filterLabel: 'Фильтр по технологиям',
    filterAll: 'Все',
    projectsShown: _ruProjectsShown,
    projectsEmpty: 'Проектов с этой технологией пока нет.',
    breadcrumbLabel: 'Навигационная цепочка',
    projectProblem: 'Задача',
    projectFeatures: 'Возможности',
    projectDecisions: 'Решения',
    projectArchitecture: 'Архитектура',
    projectScreenshots: 'Скриншоты',
    projectLinks: 'Ссылки',
    projectYear: 'Год',
    projectStatus: 'Статус',
    projectPlatforms: 'Платформы',
    projectStack: 'Стек',
    projectPrev: 'Предыдущий проект',
    projectNext: 'Следующий проект',
    projectPagerLabel: 'Другие проекты',
    backToProjects: 'Все проекты',
    opensInNewTab: '(откроется в новой вкладке)',
    footerBuiltWith: 'Сайт написан на Dart с помощью Jaspr',
    footerSource: 'Исходный код',
    footerContactsLabel: 'Контакты в соцсетях',
  );

  static const _en = Strings(
    skipToContent: 'Skip to content',
    navHome: 'Home',
    navProjects: 'Projects',
    navContacts: 'Contacts',
    mainNavLabel: 'Main navigation',
    heroGreeting: 'Hi, I am',
    heroCtaContact: 'Get in touch',
    heroCtaProjects: 'Projects',
    heroCodeCaption: 'About me, in Dart',
    aboutTitle: 'About',
    stackTitle: 'Tech stack',
    featuredTitle: 'Featured projects',
    allProjects: 'All projects',
    homeTitle: 'Dart / Flutter developer',
    homeDescription:
        'Alexey Postupinskiy is a Dart/Flutter developer based in Yekaterinburg. '
        'Mobile and desktop apps with Flutter: Riverpod, Drift, Clean Architecture.',
    projectsTitle: 'Projects',
    projectsDescription:
        'Flutter and Dart projects by Alexey Postupinskiy: goals, architecture and technical decisions.',
    projectsIntro: 'What I built and how it works inside. Pick a technology to filter the list.',
    filterLabel: 'Filter by technology',
    filterAll: 'All',
    projectsShown: _enProjectsShown,
    projectsEmpty: 'No projects with this technology yet.',
    breadcrumbLabel: 'Breadcrumb',
    projectProblem: 'The problem',
    projectFeatures: 'Features',
    projectDecisions: 'Key decisions',
    projectArchitecture: 'Architecture',
    projectScreenshots: 'Screenshots',
    projectLinks: 'Links',
    projectYear: 'Year',
    projectStatus: 'Status',
    projectPlatforms: 'Platforms',
    projectStack: 'Stack',
    projectPrev: 'Previous project',
    projectNext: 'Next project',
    projectPagerLabel: 'More projects',
    backToProjects: 'All projects',
    opensInNewTab: '(opens in a new tab)',
    footerBuiltWith: 'Built with Dart and Jaspr',
    footerSource: 'Source code',
    footerContactsLabel: 'Social links',
  );
}

String _ruProjectsShown(int count) {
  final mod10 = count % 10;
  final mod100 = count % 100;
  final word = switch ((mod10, mod100)) {
    (1, != 11) => 'проект',
    (2 || 3 || 4, < 12 || > 14) => 'проекта',
    _ => 'проектов',
  };
  return 'Показано: $count $word';
}

String _enProjectsShown(int count) => 'Showing $count ${count == 1 ? 'project' : 'projects'}';
