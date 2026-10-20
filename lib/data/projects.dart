import 'project.dart';
import 'site_config.dart';

/// Проекты портфолио в порядке показа.
const projects = <Project>[
  Project(
    slug: 'tutor-app',
    title: (ru: 'TutorApp («Репетитор»)', en: 'TutorApp'),
    tagline: (
      ru: 'CRM для онлайн-репетиторов: ученики, расписание, оплаты и прогресс. Работает офлайн.',
      en: 'A CRM for online tutors: students, schedule, payments and progress. Works offline.',
    ),
    year: 2025,
    status: ProjectStatus.released,
    platforms: [Platform.android, Platform.linux],
    tech: ['Flutter', 'Riverpod', 'go_router', 'Drift', 'Material 3', 'gen-l10n'],
    accent: '#0175c2',
    featured: true,
    problem: (
      ru:
          'Репетиторы ведут учеников в заметках и таблицах: кто когда занимается, кто сколько '
          'заплатил, сколько занятий осталось в пакете. Долги считаются вручную и легко теряются. '
          'Нужно было приложение, которое держит всё в одном месте, работает без интернета '
          'и само напоминает о должниках.',
      en:
          'Tutors track students in notes and spreadsheets: who studies when, who paid how much, '
          'how many lessons are left in a package. Debts are calculated by hand and get lost easily. '
          'The goal was an app that keeps everything in one place, works offline and reminds '
          'about overdue payments on its own.',
    ),
    features: [
      (
        ru: 'Ученики и предметы с отдельной ставкой для каждой пары «ученик — предмет»',
        en: 'Students and subjects with a separate rate for every student–subject pair',
      ),
      (ru: 'Расписание с видами «день», «неделя» и «месяц»', en: 'Schedule with day, week and month views'),
      (
        ru: 'Учёт оплат и пакетов занятий, автоматический расчёт долга',
        en: 'Payments and lesson packages with automatic debt calculation',
      ),
      (ru: 'Прогресс по темам с графиками', en: 'Per-topic progress with charts'),
      (ru: 'Локальные уведомления о должниках', en: 'Local notifications about overdue payments'),
      (ru: 'Русский и английский, светлая и тёмная тема', en: 'Russian and English, light and dark themes'),
    ],
    decisions: [
      (
        title: (ru: 'Офлайн-first на Drift', en: 'Offline-first with Drift'),
        text: (
          ru:
              'Все данные лежат в локальной SQLite через Drift. Типобезопасные запросы и реактивные '
              'стримы: экран обновляется сам, когда меняется таблица.',
          en:
              'All data lives in a local SQLite database via Drift. Type-safe queries and reactive '
              'streams: a screen updates by itself when a table changes.',
        ),
      ),
      (
        title: (ru: 'Долг вычисляется, а не хранится', en: 'Debt is derived, not stored'),
        text: (
          ru:
              'Баланс ученика считается из проведённых занятий, ставок и оплат. Нет отдельного поля, '
              'которое может разойтись с реальностью после правки старой записи.',
          en:
              'A student balance is computed from held lessons, rates and payments. There is no separate '
              'field that could drift out of sync after editing an old record.',
        ),
      ),
      (
        title: (ru: 'Riverpod как слой состояния', en: 'Riverpod for state'),
        text: (
          ru:
              'Провайдеры связывают репозитории с UI и кешируют производные данные (расписание недели, '
              'список должников). Зависимости явные, логику легко тестировать отдельно от виджетов.',
          en:
              'Providers connect repositories to the UI and cache derived data (weekly schedule, list of '
              'debtors). Dependencies are explicit, and logic is easy to test apart from widgets.',
        ),
      ),
      (
        title: (ru: 'Одна кодовая база для Android и Linux', en: 'One codebase for Android and Linux'),
        text: (
          ru:
              'Адаптивная вёрстка на Material 3 и go_router: на телефоне нижняя навигация, '
              'на десктопе боковая панель. Релизы в Google Play и RuStore, сборка под Linux.',
          en:
              'Adaptive Material 3 layout and go_router: bottom navigation on phones, a side rail on '
              'desktop. Released on Google Play and RuStore, with a Linux build.',
        ),
      ),
    ],
    architecture: (
      ru:
          'Clean Architecture с разбиением по фичам. Каждая фича содержит слои data (Drift-таблицы, '
          'DAO, репозитории), domain (сущности и правила, например расчёт долга) и presentation '
          '(экраны и провайдеры). Общий код — тема, роутинг, локализация — вынесен в core.',
      en:
          'Feature-first Clean Architecture. Each feature has data (Drift tables, DAOs, repositories), '
          'domain (entities and rules such as debt calculation) and presentation (screens and providers) '
          'layers. Shared code — theme, routing, localization — lives in core.',
    ),
    architectureTree: '''
lib/
├── core/            # тема, роутер, l10n, база данных
└── features/
    ├── students/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── schedule/
    ├── payments/
    └── progress/''',
  ),
  Project(
    slug: 'portfolio-site',
    title: (ru: 'Этот сайт', en: 'This website'),
    tagline: (
      ru: 'Портфолио на Jaspr: статическая генерация, 100% Dart, без JS-фреймворков.',
      en: 'A Jaspr portfolio: static generation, 100% Dart, no JS frameworks.',
    ),
    year: 2026,
    status: ProjectStatus.inDevelopment,
    platforms: [Platform.web],
    tech: ['Dart', 'Jaspr', 'SSG', 'GitHub Actions'],
    accent: '#13b9fd',
    featured: true,
    problem: (
      ru:
          'Показать работы и при этом продемонстрировать Dart за пределами Flutter: сайт должен быть '
          'быстрым, доступным, двуязычным и собираться в чистый HTML/CSS для GitHub Pages.',
      en:
          'Show my work while demonstrating Dart beyond Flutter: the site has to be fast, accessible, '
          'bilingual and compile to plain HTML/CSS for GitHub Pages.',
    ),
    features: [
      (ru: 'Статическая генерация всех страниц', en: 'Every page is statically generated'),
      (ru: 'Русская и английская версии', en: 'Russian and English versions'),
      (ru: 'Светлая и тёмная тема на CSS-переменных', en: 'Light and dark themes on CSS variables'),
      (
        ru: 'Подсветка Dart-кода на этапе сборки, без JS на клиенте',
        en: 'Dart syntax highlighting at build time, no client-side JS',
      ),
    ],
    decisions: [
      (
        title: (ru: 'Частичная гидрация', en: 'Partial hydration'),
        text: (
          ru:
              'Страницы рендерятся при сборке. На клиенте оживает только то, что интерактивно, '
              'например фильтр проектов — это компоненты с аннотацией @client.',
          en:
              'Pages are rendered at build time. Only interactive parts, such as the project filter, '
              'come alive on the client as @client components.',
        ),
      ),
      (
        title: (ru: 'Стили на Dart', en: 'Styles in Dart'),
        text: (
          ru:
              'CSS описан через типизированный Styles API Jaspr рядом с компонентами. Тема — набор '
              'CSS-переменных, поэтому переключение не требует перерисовки.',
          en:
              'CSS is written with Jaspr\'s typed Styles API next to components. The theme is a set of '
              'CSS variables, so switching needs no re-render.',
        ),
      ),
      (
        title: (ru: 'Данные отдельно от разметки', en: 'Data separate from markup'),
        text: (
          ru:
              'Профиль, навыки и проекты — const-модели в lib/data. Страницы проектов генерируются '
              'из этого списка автоматически.',
          en:
              'Profile, skills and projects are const models in lib/data. Project pages are generated '
              'from that list automatically.',
        ),
      ),
    ],
    architecture: (
      ru:
          'Jaspr в режиме static с multi-page роутингом. Строки интерфейса и контент разделены, '
          'маршруты для каждого языка строятся из одного списка.',
      en:
          'Jaspr in static mode with multi-page routing. UI strings and content are separated, and '
          'routes for every language are built from a single list.',
    ),
    architectureTree: '''
lib/
├── components/      # layout, карточки, фильтр (@client)
├── pages/           # страницы
├── data/            # профиль, навыки, проекты
├── l10n/            # языки и строки
└── styles/          # токены и глобальные стили''',
    links: [
      SourceLink(SiteConfig.sourceUrl),
    ],
  ),
];

/// Проект по slug.
Project? projectBySlug(String slug) {
  for (final project in projects) {
    if (project.slug == slug) return project;
  }
  return null;
}

/// Все технологии из проектов, в порядке первого появления.
List<String> get allTech => {for (final project in projects) ...project.tech}.toList();
