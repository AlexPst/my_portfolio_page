/// Проверки целостности данных: ошибка в `lib/data` должна ронять CI, а не сайт.
library;

import 'dart:io';

import 'package:my_portfolio_page/data/profile.dart';
import 'package:my_portfolio_page/data/project.dart';
import 'package:my_portfolio_page/data/projects.dart';
import 'package:my_portfolio_page/data/skills.dart';
import 'package:my_portfolio_page/l10n/app_locale.dart';
import 'package:my_portfolio_page/styles/fonts.dart';
import 'package:test/test.dart';

void expectLocalized(Localized value, String field) {
  expect(value.ru.trim(), isNotEmpty, reason: '$field: пустой русский текст');
  expect(value.en.trim(), isNotEmpty, reason: '$field: пустой английский текст');
}

bool isHttpUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null && (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty;
}

void main() {
  group('проекты', () {
    test('есть хотя бы один проект и один избранный', () {
      expect(projects, isNotEmpty);
      expect(projects.where((p) => p.featured), isNotEmpty);
    });

    test('slug уникальны и годятся для URL', () {
      final slugs = projects.map((p) => p.slug).toList();
      expect(slugs.toSet().length, slugs.length, reason: 'повторяющийся slug');
      for (final slug in slugs) {
        expect(slug, matches(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$')), reason: 'slug "$slug"');
      }
    });

    for (final project in projects) {
      group(project.slug, () {
        test('все тексты переведены', () {
          expectLocalized(project.title, 'title');
          expectLocalized(project.tagline, 'tagline');
          expectLocalized(project.problem, 'problem');
          expectLocalized(project.architecture, 'architecture');
          if (project.architectureTree case final tree?) expectLocalized(tree, 'architectureTree');
          for (final f in project.features) {
            expectLocalized(f, 'features');
          }
          for (final d in project.decisions) {
            expectLocalized(d.title, 'decisions.title');
            expectLocalized(d.text, 'decisions.text');
          }
        });

        test('стек, платформы и решения заполнены', () {
          expect(project.tech, isNotEmpty);
          expect(project.tech.toSet().length, project.tech.length, reason: 'повтор в tech');
          expect(project.platforms, isNotEmpty);
          expect(project.decisions, isNotEmpty);
        });

        test('цвет обложки — hex', () {
          expect(project.accent, matches(RegExp(r'^#[0-9a-fA-F]{6}$')));
        });

        test('ссылки — абсолютные http(s)', () {
          for (final link in project.links) {
            expect(isHttpUrl(link.url), isTrue, reason: link.url);
          }
        });

        test('файлы скриншотов существуют и это WebP', () {
          for (final shot in project.screenshots) {
            expect(File('web/${shot.file}').existsSync(), isTrue, reason: 'нет web/${shot.file}');
            expect(shot.file, endsWith('.webp'));
            expect(shot.width, greaterThan(0));
            expect(shot.height, greaterThan(0));
            expectLocalized(shot.alt, 'screenshot.alt');
          }
        });
      });
    }

    test('projectBySlug находит каждый проект', () {
      for (final p in projects) {
        expect(projectBySlug(p.slug), same(p));
      }
      expect(projectBySlug('missing'), isNull);
    });
  });

  group('профиль', () {
    test('тексты переведены', () {
      expectLocalized(profile.name, 'name');
      expectLocalized(profile.role, 'role');
      expectLocalized(profile.city, 'city');
      expectLocalized(profile.openTo, 'openTo');
      for (final p in profile.about) {
        expectLocalized(p, 'about');
      }
    });

    test('контакты корректны', () {
      expect(profile.contact(ContactKind.email), isNotNull);
      for (final c in profile.contacts) {
        switch (c.kind) {
          case ContactKind.email:
            expect(c.url, 'mailto:${c.label}');
          case _:
            expect(isHttpUrl(c.url), isTrue, reason: c.url);
        }
      }
    });

    test('группы навыков не пустые', () {
      for (final g in skillGroups) {
        expectLocalized(g.title, 'skill group');
        expect(g.items, isNotEmpty);
      }
    });
  });

  test('файлы шрифтов на месте', () {
    for (final font in fontFiles) {
      expect(File('web/${font.file}').existsSync(), isTrue, reason: 'нет web/${font.file}');
    }
  });

  test('ассеты из tool/generate_assets.dart на месте', () {
    for (final locale in AppLocale.values) {
      expect(File('web/images/og-${locale.code}.png').existsSync(), isTrue);
    }
    for (final file in ['favicon.svg', 'favicon.ico', 'apple-touch-icon.png', 'robots.txt']) {
      expect(File('web/$file').existsSync(), isTrue, reason: 'нет web/$file');
    }
  });

  test('статус проекта переведён', () {
    for (final s in ProjectStatus.values) {
      expectLocalized(s.label, 'status ${s.name}');
    }
  });
}
