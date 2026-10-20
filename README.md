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
# Для GitHub Pages репозитория проекта (https://<user>.github.io/my_portfolio_page/)
jaspr build \
  --dart-define=BASE_PATH=/my_portfolio_page/ \
  --dart-define=SITE_URL=https://<user>.github.io
```

Результат лежит в `build/jaspr/`.

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
```
