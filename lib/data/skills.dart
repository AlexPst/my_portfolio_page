import '../l10n/app_locale.dart';

final class SkillGroup {
  const SkillGroup({required this.title, required this.items});

  final Localized title;
  final List<String> items;
}

const skillGroups = [
  SkillGroup(
    title: (ru: 'Язык и UI', en: 'Language & UI'),
    items: ['Dart 3', 'Flutter', 'Material 3', 'Jaspr'],
  ),
  SkillGroup(
    title: (ru: 'Состояние и навигация', en: 'State & navigation'),
    items: ['Riverpod', 'go_router'],
  ),
  SkillGroup(
    title: (ru: 'Данные', en: 'Data'),
    items: ['Drift (SQLite)', 'Freezed', 'json_serializable'],
  ),
  SkillGroup(
    title: (ru: 'Архитектура', en: 'Architecture'),
    items: ['Clean Architecture', 'feature-first', 'intl / gen-l10n'],
  ),
  SkillGroup(
    title: (ru: 'Релизы и платформы', en: 'Releases & platforms'),
    items: ['Google Play', 'RuStore', 'Linux desktop', 'Git'],
  ),
];
