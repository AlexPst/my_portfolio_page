/// Минимальный лексер Dart для подсветки синтаксиса на этапе сборки.
///
/// Не претендует на полноту грамматики: покрывает то, что встречается
/// в коротких фрагментах на сайте (ключевые слова, типы, строки, числа,
/// комментарии, вызовы функций).
library;

enum TokenKind { keyword, type, string, number, comment, function, property, punctuation, plain }

typedef Token = ({TokenKind kind, String text});

const _keywords = {
  'abstract', 'as', 'async', 'await', 'base', 'break', 'case', 'class', 'const', 'continue', //
  'default', 'else', 'enum', 'extends', 'extension', 'false', 'final', 'for', 'if', 'implements',
  'import', 'in', 'interface', 'is', 'late', 'mixin', 'new', 'null', 'required', 'return',
  'sealed', 'static', 'super', 'switch', 'this', 'true', 'typedef', 'var', 'void', 'when',
  'while', 'with', 'yield', 'throw', 'rethrow', 'try', 'catch', 'on', 'finally', 'assert', 'do',
  'factory', 'get', 'set', 'export', 'library', 'part', 'show', 'hide', 'external', 'covariant',
};

final _pattern = RegExp(
  r'(?<comment>//[^\n]*)'
  r"|(?<string>'(?:[^'\\\n]|\\.)*'|"
  r'"(?:[^"\\\n]|\\.)*")'
  r'|(?<number>\b\d+(?:\.\d+)?\b)'
  r'|(?<word>[A-Za-z_$][\w$]*)'
  r'|(?<space>\s+)'
  r'|(?<punct>.)',
);

/// Разбивает [source] на токены. Соседние пробелы склеиваются с `plain`.
List<Token> highlightDart(String source) {
  final tokens = <Token>[];
  final matches = _pattern.allMatches(source).toList();

  for (var i = 0; i < matches.length; i++) {
    final m = matches[i];
    final text = m[0]!;
    final kind = switch (m) {
      _ when m.namedGroup('comment') != null => TokenKind.comment,
      _ when m.namedGroup('string') != null => TokenKind.string,
      _ when m.namedGroup('number') != null => TokenKind.number,
      _ when m.namedGroup('word') != null => _classifyWord(text, matches, i),
      _ when m.namedGroup('space') != null => TokenKind.plain,
      _ => TokenKind.punctuation,
    };
    tokens.add((kind: kind, text: text));
  }
  return tokens;
}

TokenKind _classifyWord(String word, List<RegExpMatch> matches, int index) {
  if (_keywords.contains(word)) return TokenKind.keyword;
  if (word.startsWith(RegExp('[A-Z]'))) return TokenKind.type;

  final next = _nextSignificant(matches, index);
  final prev = index > 0 ? matches[index - 1][0] : null;
  return switch ((prev, next)) {
    (_, '(') => TokenKind.function,
    (_, ':') => TokenKind.property,
    ('.', _) => TokenKind.property,
    _ => TokenKind.plain,
  };
}

String? _nextSignificant(List<RegExpMatch> matches, int index) {
  for (var j = index + 1; j < matches.length; j++) {
    final text = matches[j][0]!;
    if (text.trim().isNotEmpty) return text;
  }
  return null;
}
