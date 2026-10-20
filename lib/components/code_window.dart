import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../styles/theme.dart';
import '../utils/dart_highlighter.dart';

/// Окно «редактора» с подсвеченным Dart-кодом.
///
/// Подсветка выполняется при генерации страницы, на клиент уходит готовый HTML.
class CodeWindow extends StatelessComponent {
  const CodeWindow({
    required this.source,
    required this.fileName,
    required this.caption,
    this.highlight = true,
    super.key,
  });

  final String source;
  final String fileName;

  /// Подпись для скринридеров.
  final String caption;

  /// `false` — вывести текст как есть (например, дерево каталогов).
  final bool highlight;

  @override
  Component build(BuildContext context) {
    return figure(classes: 'code-window', [
      div(
        classes: 'code-window__bar',
        attributes: {'aria-hidden': 'true'},
        [
          const span(classes: 'code-window__dot', []),
          const span(classes: 'code-window__dot', []),
          const span(classes: 'code-window__dot', []),
          span(classes: 'code-window__file', [.text(fileName)]),
        ],
      ),
      pre(
        classes: 'code-window__body',
        attributes: {'tabindex': '0'},
        [
          code([
            if (!highlight)
              .text(source)
            else
              for (final token in highlightDart(source))
                if (token.kind == TokenKind.plain)
                  .text(token.text)
                else
                  span(classes: 'tk-${token.kind.name}', [.text(token.text)]),
          ]),
        ],
      ),
      figcaption(classes: 'visually-hidden', [.text(caption)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.code-window', [
      css('&').styles(
        margin: .zero,
        border: .all(color: const Color('#22304a'), style: .solid, width: 1.px),
        radius: .circular(14.px),
        overflow: .hidden,
        shadow: BoxShadow(offsetX: .zero, offsetY: 24.px, blur: 60.px, color: const Color('rgba(1, 30, 60, 0.35)')),
        backgroundColor: const Color('#0b1322'),
      ),
      css('.code-window__bar').styles(
        display: .flex,
        padding: .symmetric(vertical: 0.75.rem, horizontal: 1.rem),
        border: .only(
          bottom: .solid(color: const Color('#1c2840'), width: 1.px),
        ),
        alignItems: .center,
        gap: .column(0.5.rem),
        backgroundColor: const Color('#0f1a2e'),
      ),
      css('.code-window__dot').styles(
        width: 0.75.rem,
        height: 0.75.rem,
        radius: .circular(50.percent),
        backgroundColor: const Color('#2a3a58'),
      ),
      css('.code-window__dot:first-child').styles(backgroundColor: const Color('#0175c2')),
      css('.code-window__file').styles(
        margin: .only(left: 0.5.rem),
        color: const Color('#9aa8bf'),
        fontFamily: AppFonts.mono,
        fontSize: 0.8125.rem,
      ),
      css('.code-window__body').styles(
        padding: .all(1.25.rem),
        margin: .zero,
        overflow: .auto,
        color: const Color('#e6edf7'),
        fontSize: 0.875.rem,
        lineHeight: 1.7.em,
        raw: {'tab-size': '2', 'font-size': 'clamp(0.75rem, 0.7rem + 0.3vw, 0.9rem)'},
      ),
      // Палитра подобрана под контраст AA на фоне #0b1322.
      css('.tk-keyword').styles(color: const Color('#c5a3ff')),
      css('.tk-type').styles(color: const Color('#5fd4ff')),
      css('.tk-string').styles(color: const Color('#a8e07a')),
      css('.tk-number').styles(color: const Color('#ffb86b')),
      css('.tk-comment').styles(color: const Color('#8593ad'), fontStyle: .italic),
      css('.tk-function').styles(color: const Color('#ffd479')),
      css('.tk-property').styles(color: const Color('#8fd3ff')),
      css('.tk-punctuation').styles(color: const Color('#aab6c9')),
    ]),
  ];
}
