import '../l10n/app_locale.dart';

/// Тип контакта: от него зависят иконка и подпись.
enum ContactKind {
  email(label: (ru: 'Почта', en: 'Email')),
  telegram(label: (ru: 'Telegram', en: 'Telegram')),
  github(label: (ru: 'GitHub', en: 'GitHub')),
  linkedin(label: (ru: 'LinkedIn', en: 'LinkedIn')),
  habr(label: (ru: 'Хабр Карьера', en: 'Habr Career')),
  hh(label: (ru: 'hh.ru', en: 'hh.ru'));

  const ContactKind({required this.label});

  final Localized label;
}

final class Contact {
  const Contact({required this.kind, required this.label, required this.url});

  final ContactKind kind;

  /// Видимый текст ссылки, например `@username`.
  final String label;
  final String url;
}

final class Profile {
  const Profile({
    required this.name,
    required this.shortName,
    required this.role,
    required this.level,
    required this.city,
    required this.about,
    required this.openTo,
    required this.contacts,
  });

  final Localized name;

  /// Короткое имя для логотипа и кода в hero.
  final Localized shortName;
  final Localized role;
  final Localized level;
  final Localized city;

  /// Абзацы блока «Обо мне».
  final List<Localized> about;

  /// Что ищу: работа, фриланс, заказы.
  final Localized openTo;
  final List<Contact> contacts;

  Contact? contact(ContactKind kind) {
    for (final c in contacts) {
      if (c.kind == kind) return c;
    }
    return null;
  }
}

/// Все личные данные в одном месте — правьте здесь.
const profile = Profile(
  name: (ru: 'Алексей Поступинский', en: 'Alexey Postupinskiy'),
  shortName: (ru: 'Алексей', en: 'Alexey'),
  role: (ru: 'Dart / Flutter-разработчик', en: 'Dart / Flutter developer'),
  level: (ru: 'Junior', en: 'Junior'),
  city: (ru: 'Екатеринбург', en: 'Yekaterinburg'),
  about: [
    (
      ru:
          'Пишу приложения на Flutter для Android и Linux: от модели данных и офлайн-хранилища '
          'до релиза в Google Play и RuStore. Люблю, когда архитектура понятна, а код — предсказуем.',
      en:
          'I build Flutter apps for Android and Linux: from the data model and offline storage '
          'to releases on Google Play and RuStore. I like clear architecture and predictable code.',
    ),
    (
      ru:
          'Мой основной проект — TutorApp, CRM для репетиторов с расписанием, учётом оплат и '
          'статистикой. Этот сайт тоже написан целиком на Dart: на Jaspr, со статической генерацией.',
      en:
          'My main project is TutorApp, a CRM for tutors with scheduling, payment tracking and '
          'progress charts. This site is written entirely in Dart too, using Jaspr with static generation.',
    ),
  ],
  openTo: (
    ru: 'Открыт к работе в команде, фрилансу и заказам.',
    en: 'Open to full-time roles, freelance and contract work.',
  ),
  contacts: [
    Contact(
      kind: ContactKind.email,
      label: 'aleksey.postupinskiy@yandex.ru',
      url: 'mailto:aleksey.postupinskiy@yandex.ru',
    ),
    Contact(kind: ContactKind.telegram, label: '@alexdart1', url: 'https://t.me/alexdart1'),
    Contact(kind: ContactKind.github, label: 'AlexPst', url: 'https://github.com/AlexPst'),
  ],
);
