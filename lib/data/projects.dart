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
    tech: ['Flutter', 'Riverpod', 'go_router', 'Drift', 'Freezed', 'fl_chart', 'Material 3', 'gen-l10n'],
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
              'Все данные лежат в локальной SQLite через Drift: таблицы учеников, предметов, занятий, '
              'пакетов и оплат с SQL-ограничениями. Связанные записи меняются в одной транзакции, '
              'а реактивные запросы обновляют экран сами.',
          en:
              'All data lives in a local SQLite database via Drift: students, subjects, lessons, packages '
              'and payments tables with SQL constraints. Related records change in a single transaction, '
              'and reactive queries refresh the screen on their own.',
        ),
      ),
      (
        title: (ru: 'Долг вычисляется, а не хранится', en: 'Debt is derived, not stored'),
        text: (
          ru:
              'Баланс ученика — это «оплачено минус начислено» по занятиям и пакетам. Нет отдельного '
              'поля, которое разойдётся с реальностью после правки старой записи. Суммы хранятся '
              'в value-объекте Money, а не в double.',
          en:
              'A student balance is "paid minus charged" across lessons and packages. There is no separate '
              'field that could drift out of sync after editing an old record. Amounts use a Money value '
              'object instead of double.',
        ),
      ),
      (
        title: (ru: 'Riverpod с кодогенерацией и тесты', en: 'Generated Riverpod and tests'),
        text: (
          ru:
              'Провайдеры объявлены через riverpod_annotation и связывают репозитории, use case и UI. '
              'Зависимости явные, поэтому репозитории, доменные сервисы и экраны покрыты тестами.',
          en:
              'Providers are declared with riverpod_annotation and connect repositories, use cases and UI. '
              'Dependencies are explicit, so repositories, domain services and screens are covered by tests.',
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
          'Clean Architecture с разбиением по фичам. В каждой фиче слои data (репозитории на Drift '
          'и мапперы), domain (Freezed-модели, интерфейсы репозиториев, сервисы и use case, например '
          'политика начислений) и presentation (экраны, контроллеры, провайдеры). Роутер и тема — '
          'в app, база данных, общие виджеты и доменные типы вроде Money — в core.',
      en:
          'Feature-first Clean Architecture. Each feature has data (Drift repositories and mappers), '
          'domain (Freezed models, repository interfaces, services and use cases such as the billing '
          'policy) and presentation (screens, controllers, providers) layers. Router and theme live in '
          'app; the database, shared widgets and domain types such as Money live in core.',
    ),
    architectureTree: (
      ru: '''
lib/
├── app/              # роутер, тема, bootstrap
├── core/             # Drift, Money, общие виджеты
└── features/
    ├── finance/
    │   ├── data/         # репозитории, мапперы
    │   ├── domain/       # модели, сервисы, use case
    │   └── presentation/ # экраны, провайдеры
    ├── lessons/
    ├── students/
    ├── subjects/
    ├── progress/
    ├── dashboard/
    └── settings/''',
      en: '''
lib/
├── app/              # router, theme, bootstrap
├── core/             # Drift, Money, shared widgets
└── features/
    ├── finance/
    │   ├── data/         # repositories, mappers
    │   ├── domain/       # models, services, use cases
    │   └── presentation/ # screens, providers
    ├── lessons/
    ├── students/
    ├── subjects/
    ├── progress/
    ├── dashboard/
    └── settings/''',
    ),
    links: [
      SourceLink('https://github.com/AlexPst/TutorAppFlutter'),
    ],
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
    architectureTree: (
      ru: '''
lib/
├── components/      # layout, карточки, фильтр (@client)
├── pages/           # страницы
├── data/            # профиль, навыки, проекты
├── l10n/            # языки и строки
└── styles/          # токены и глобальные стили''',
      en: '''
lib/
├── components/      # layout, cards, filter (@client)
├── pages/           # pages
├── data/            # profile, skills, projects
├── l10n/            # locales and strings
└── styles/          # tokens and global styles''',
    ),
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
