import 'package:my_portfolio_page/data/site_config.dart';
import 'package:my_portfolio_page/l10n/app_locale.dart';
import 'package:my_portfolio_page/l10n/strings.dart';
import 'package:my_portfolio_page/styles/theme_preference.dart';
import 'package:my_portfolio_page/utils/dart_highlighter.dart';
import 'package:test/test.dart';

void main() {
  group('AppLocale.path', () {
    test('русский живёт в корне', () {
      expect(AppLocale.ru.path('/'), '/');
      expect(AppLocale.ru.path('/projects'), '/projects');
    });

    test('английский получает префикс /en', () {
      expect(AppLocale.en.path('/'), '/en');
      expect(AppLocale.en.path('/projects/tutor-app'), '/en/projects/tutor-app');
    });

    test('fromUrl распознаёт язык по префиксу', () {
      expect(AppLocale.fromUrl('/en'), AppLocale.en);
      expect(AppLocale.fromUrl('/en/projects'), AppLocale.en);
      expect(AppLocale.fromUrl('/projects'), AppLocale.ru);
      // Префикс должен быть целым сегментом пути.
      expect(AppLocale.fromUrl('/enterprise'), AppLocale.ru);
    });
  });

  group('SiteConfig.href (BASE_PATH по умолчанию = /)', () {
    test('страницы заканчиваются слешем', () {
      expect(SiteConfig.href('/'), '/');
      expect(SiteConfig.href('/projects'), '/projects/');
      expect(SiteConfig.href('/en'), '/en/');
    });

    test('файлы — без слеша', () {
      expect(SiteConfig.href('/404.html'), '/404.html');
      expect(SiteConfig.asset('images/og-ru.png'), '/images/og-ru.png');
    });
  });

  group('склонение счётчика проектов', () {
    final ru = Strings.of(AppLocale.ru).projectsShown;
    final en = Strings.of(AppLocale.en).projectsShown;

    test('русский', () {
      expect(ru(1), 'Показано: 1 проект');
      expect(ru(2), 'Показано: 2 проекта');
      expect(ru(5), 'Показано: 5 проектов');
      expect(ru(11), 'Показано: 11 проектов');
      expect(ru(12), 'Показано: 12 проектов');
      expect(ru(21), 'Показано: 21 проект');
      expect(ru(22), 'Показано: 22 проекта');
      expect(ru(0), 'Показано: 0 проектов');
    });

    test('английский', () {
      expect(en(1), 'Showing 1 project');
      expect(en(3), 'Showing 3 projects');
    });
  });

  group('highlightDart', () {
    const source = "final me = Developer(name: 'A', age: 3); // ok\nvoid main() => run();";

    test('склейка токенов возвращает исходный текст', () {
      expect(highlightDart(source).map((t) => t.text).join(), source);
    });

    test('классифицирует основные токены', () {
      final kinds = {for (final t in highlightDart(source)) t.text: t.kind};
      expect(kinds['final'], TokenKind.keyword);
      expect(kinds['Developer'], TokenKind.type);
      expect(kinds["'A'"], TokenKind.string);
      expect(kinds['3'], TokenKind.number);
      expect(kinds['// ok'], TokenKind.comment);
      expect(kinds['name'], TokenKind.property);
      expect(kinds['run'], TokenKind.function);
    });
  });

  test('ThemePreference.parse: неизвестное значение — системная тема', () {
    expect(ThemePreference.parse('dark'), ThemePreference.dark);
    expect(ThemePreference.parse('light'), ThemePreference.light);
    expect(ThemePreference.parse(null), ThemePreference.system);
    expect(ThemePreference.parse('purple'), ThemePreference.system);
  });

  test('inline-скрипт темы использует тот же ключ localStorage', () {
    expect(themeInitScript, contains("'${ThemePreference.storageKey}'"));
  });
}
