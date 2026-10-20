# my_portfolio_page

Персональный сайт-портфолио Алексея Поступинского. 100% Dart: [Jaspr](https://jaspr.site), статическая генерация.

## Запуск

```bash
dart pub global activate jaspr_cli
dart pub get
jaspr serve            # http://localhost:8080
```

## Сборка

```bash
# GitHub Pages репозитория проекта: https://alexpst.github.io/my_portfolio_page/
jaspr build \
  --dart-define=BASE_PATH=/my_portfolio_page/ \
  --dart-define=SITE_URL=https://alexpst.github.io \
  --sitemap-domain=https://alexpst.github.io/my_portfolio_page \
  --sitemap-exclude=404
dart run tool/postbuild.dart   # слеши в sitemap.xml, как у canonical
```

Результат лежит в `build/jaspr/`.

## Проверки

```bash
dart format --output=none --set-exit-if-changed lib test tool
dart analyze --fatal-infos
dart test        # логика, целостность данных в lib/data, контраст цветов темы (WCAG AA)
```

## Деплой на GitHub Pages

Workflow `.github/workflows/deploy.yml`:

- на каждый push и pull request: формат → анализ → тесты → `jaspr build` → `tool/postbuild.dart`;
- на push в `main`: публикация на Pages, затем Lighthouse CI по опубликованным страницам
  (пороги в `lighthouserc.json`: ≥ 0.95 во всех категориях).

`BASE_PATH` и `SITE_URL` вычисляются из имени репозитория и владельца, поэтому workflow
работает в любом репозитории без правок.

Первичная настройка: **Settings → Pages → Build and deployment → Source: GitHub Actions**.

## Ассеты

OG-картинки (`web/images/og-*.png`), `favicon.ico` и `apple-touch-icon.png` генерируются
из данных профиля и `web/favicon.svg` через headless Chromium:

```bash
dart run tool/generate_assets.dart
```

Перезапускайте после изменения имени, роли или стека в `lib/data`.

## Структура

```
lib/
  app.dart             маршруты (ru в корне, en под /en)
  main.server.dart     документ: <head>, шрифты, base
  components/          шапка, подвал, layout, окно с кодом
  pages/               страницы
  data/                профиль, навыки, конфиг сборки (личные данные правятся здесь)
  l10n/                языки и строки интерфейса
  styles/              дизайн-токены и глобальные стили
  utils/               подсветка Dart-синтаксиса на этапе сборки
tool/
  generate_assets.dart OG-картинки и иконки
  postbuild.dart       чистка сборки, sitemap.xml, .nojekyll
test/                  тесты логики, данных и контраста
web/fonts/             Inter и JetBrains Mono (SIL OFL 1.1)
```
