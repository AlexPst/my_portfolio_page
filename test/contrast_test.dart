/// Контраст цветов темы по WCAG 2.2: 4.5:1 для текста, 3:1 для элементов интерфейса.
library;

import 'dart:math';

import 'package:my_portfolio_page/styles/theme.dart';
import 'package:test/test.dart';

double _channel(int value) {
  final c = value / 255;
  return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(String hex) {
  final v = int.parse(hex.substring(1), radix: 16);
  return 0.2126 * _channel(v >> 16 & 0xff) + 0.7152 * _channel(v >> 8 & 0xff) + 0.0722 * _channel(v & 0xff);
}

double contrast(String a, String b) {
  final (la, lb) = (_luminance(a), _luminance(b));
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

/// Пары (передний план, фон, минимальный контраст).
const _pairs = <(String, String, double)>[
  ('--text', '--bg', 4.5),
  ('--text', '--surface', 4.5),
  ('--text', '--surface-raised', 4.5),
  ('--muted', '--bg', 4.5),
  ('--muted', '--surface', 4.5),
  ('--muted', '--surface-raised', 4.5),
  ('--accent', '--bg', 4.5),
  ('--accent', '--surface', 4.5),
  ('--on-accent', '--accent-strong', 4.5),
  ('--success', '--surface', 4.5),
  ('--focus', '--bg', 3),
];

void main() {
  test('формула контраста совпадает с эталоном WCAG', () {
    expect(contrast('#000000', '#ffffff'), closeTo(21, 0.01));
    expect(contrast('#777777', '#ffffff'), closeTo(4.48, 0.01));
  });

  for (final (name, tokens) in [('светлая', lightTokens), ('тёмная', darkTokens)]) {
    group('тема: $name', () {
      for (final (fg, bg, minRatio) in _pairs) {
        test('$fg на $bg ≥ $minRatio:1', () {
          final ratio = contrast(tokens[fg]!, tokens[bg]!);
          expect(
            ratio,
            greaterThanOrEqualTo(minRatio),
            reason: '${tokens[fg]} на ${tokens[bg]}: ${ratio.toStringAsFixed(2)}',
          );
        });
      }
    });
  }

  group('подсветка кода на фоне #0b1322', () {
    // Цвета из CodeWindow.styles: окно кода тёмное в обеих темах.
    const colors = {
      'keyword': '#c5a3ff',
      'type': '#5fd4ff',
      'string': '#a8e07a',
      'number': '#ffb86b',
      'comment': '#8593ad',
      'function': '#ffd479',
      'property': '#8fd3ff',
      'punctuation': '#aab6c9',
      'plain': '#e6edf7',
    };
    for (final MapEntry(key: kind, value: color) in colors.entries) {
      test('$kind ≥ 4.5:1', () {
        expect(contrast(color, '#0b1322'), greaterThanOrEqualTo(4.5));
      });
    }
  });
}
