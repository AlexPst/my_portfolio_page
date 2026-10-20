/// Доводит результат `jaspr build` до вида, готового к публикации на GitHub Pages.
///
/// 1. Удаляет служебные файлы build_runner (`packages/`, `.dart_tool/`, `.build.manifest`):
///    сайту они не нужны, а `packages/` содержит исходники зависимостей.
/// 2. В `sitemap.xml` добавляет адресам страниц завершающий слеш, как у canonical:
///    GitHub Pages отдаёт `/projects/index.html` по адресу `/projects/`.
/// 3. Добавляет `.nojekyll`, чтобы Pages не обрабатывал сайт Jekyll'ом.
/// 4. Проверяет, что ключевые файлы на месте; иначе завершается с ошибкой.
///
/// Запуск после сборки: `dart run tool/postbuild.dart [build/jaspr]`.
library;

import 'dart:io';

void main(List<String> args) {
  final dir = Directory(args.isNotEmpty ? args.first : 'build/jaspr');
  if (!dir.existsSync()) _fail('Нет ${dir.path} — сначала выполните jaspr build.');

  for (final junk in ['packages', '.dart_tool', '.build.manifest']) {
    final path = '${dir.path}/$junk';
    if (Directory(path).existsSync()) {
      Directory(path).deleteSync(recursive: true);
      stdout.writeln('Удалено: $junk/');
    } else if (File(path).existsSync()) {
      File(path).deleteSync();
      stdout.writeln('Удалено: $junk');
    }
  }

  _fixSitemap(File('${dir.path}/sitemap.xml'));
  File('${dir.path}/.nojekyll').writeAsStringSync('');

  final required = ['index.html', 'en/index.html', '404.html', 'sitemap.xml', 'robots.txt', 'main.client.dart.js'];
  final missing = [
    for (final path in required)
      if (!File('${dir.path}/$path').existsSync()) path,
  ];
  if (missing.isNotEmpty) _fail('В сборке нет файлов: ${missing.join(', ')}');

  stdout.writeln('Сборка готова к публикации: ${dir.path}');
}

void _fixSitemap(File sitemap) {
  if (!sitemap.existsSync()) _fail('Нет sitemap.xml — соберите сайт с --sitemap-domain.');

  final locPattern = RegExp('<loc>([^<]+)</loc>');
  var fixed = 0;
  final content = sitemap.readAsStringSync().replaceAllMapped(locPattern, (m) {
    final url = m[1]!;
    final last = Uri.parse(url).pathSegments.lastOrNull ?? '';
    if (url.endsWith('/') || last.contains('.')) return m[0]!;
    fixed++;
    return '<loc>$url/</loc>';
  });
  sitemap.writeAsStringSync(content);
  stdout.writeln('sitemap.xml: добавлен слеш к $fixed адресам.');
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
