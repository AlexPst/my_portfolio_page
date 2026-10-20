/// Генерирует растровые ассеты сайта из данных профиля:
///
/// - `web/images/og-<lang>.png` — картинки Open Graph 1200×630 для каждого языка;
/// - `web/apple-touch-icon.png` (180×180) и `web/favicon.ico` (16, 32, 48) из `web/favicon.svg`.
///
/// Рендерит через headless Chromium, поэтому он должен быть установлен.
/// Запуск: `dart run tool/generate_assets.dart [путь-к-chromium]`.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:my_portfolio_page/data/profile.dart';
import 'package:my_portfolio_page/data/skills.dart';
import 'package:my_portfolio_page/l10n/app_locale.dart';
import 'package:my_portfolio_page/styles/fonts.dart';

Future<void> main(List<String> args) async {
  final chrome = args.isNotEmpty ? args.first : _findChrome();
  final tmp = await Directory.systemTemp.createTemp('portfolio_assets_');

  try {
    Directory('web/images').createSync(recursive: true);

    for (final locale in AppLocale.values) {
      final html = File('${tmp.path}/og-${locale.code}.html')..writeAsStringSync(_ogHtml(locale));
      await _screenshot(chrome, html, 'web/images/og-${locale.code}.png', width: 1200, height: 630);
    }

    final svg = File('web/favicon.svg').readAsStringSync();
    final icons = <int, Uint8List>{};
    for (final size in [16, 32, 48, 180]) {
      final html = File('${tmp.path}/icon-$size.html')..writeAsStringSync(_iconHtml(svg, size));
      final out = '${tmp.path}/icon-$size.png';
      await _screenshot(chrome, html, out, width: size, height: size, transparent: true);
      icons[size] = File(out).readAsBytesSync();
    }
    File('web/apple-touch-icon.png').writeAsBytesSync(icons[180]!);
    File('web/favicon.ico').writeAsBytesSync(
      _ico({
        for (final s in [16, 32, 48]) s: icons[s]!,
      }),
    );

    stdout.writeln('Готово: web/images/og-*.png, web/apple-touch-icon.png, web/favicon.ico');
  } finally {
    tmp.deleteSync(recursive: true);
  }
}

String _findChrome() {
  for (final name in ['chromium', 'chromium-browser', 'google-chrome', 'google-chrome-stable']) {
    final result = Process.runSync('which', [name]);
    if (result.exitCode == 0) return (result.stdout as String).trim();
  }
  stderr.writeln('Chromium не найден. Передайте путь первым аргументом.');
  exit(1);
}

Future<void> _screenshot(
  String chrome,
  File html,
  String out, {
  required int width,
  required int height,
  bool transparent = false,
}) async {
  final result = await Process.run(chrome, [
    '--headless=new',
    '--disable-gpu',
    '--hide-scrollbars',
    '--force-device-scale-factor=1',
    // Отдельный профиль: без него Chromium в headless-режиме может падать на старте.
    '--user-data-dir=${html.parent.path}/chrome-profile',
    '--virtual-time-budget=5000',
    if (transparent) '--default-background-color=00000000',
    '--window-size=$width,$height',
    '--screenshot=${File(out).absolute.path}',
    html.uri.toString(),
  ]);
  if (result.exitCode != 0 || !File(out).existsSync()) {
    throw ProcessException(chrome, [], '${result.stderr}', result.exitCode);
  }
}

/// ICO-контейнер с PNG внутри (поддерживается всеми актуальными браузерами).
Uint8List _ico(Map<int, Uint8List> pngs) {
  final header = ByteData(6 + 16 * pngs.length)
    ..setUint16(2, 1, Endian.little) // тип: иконка
    ..setUint16(4, pngs.length, Endian.little);
  var offset = header.lengthInBytes;
  var entry = 6;
  for (final MapEntry(key: size, value: png) in pngs.entries) {
    header
      ..setUint8(entry, size == 256 ? 0 : size)
      ..setUint8(entry + 1, size == 256 ? 0 : size)
      ..setUint16(entry + 4, 1, Endian.little) // planes
      ..setUint16(entry + 6, 32, Endian.little) // bpp
      ..setUint32(entry + 8, png.length, Endian.little)
      ..setUint32(entry + 12, offset, Endian.little);
    offset += png.length;
    entry += 16;
  }
  return (BytesBuilder()
        ..add(header.buffer.asUint8List())
        ..add([for (final png in pngs.values) ...png]))
      .toBytes();
}

String _iconHtml(String svg, int size) =>
    '<!doctype html><html><body style="margin:0;background:transparent">'
    '<div style="width:${size}px;height:${size}px">${svg.replaceFirst('<svg ', '<svg width="$size" height="$size" ')}</div>'
    '</body></html>';

String _esc(String s) => s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

String _ogHtml(AppLocale locale) {
  // Те же локальные шрифты, что и на сайте: генерация работает без сети.
  final fontFaces = [
    for (final font in fontFiles)
      "@font-face { font-family: '${font.family}'; font-weight: 100 900; "
          "src: url('${File('web/${font.file}').absolute.uri}') format('woff2'); "
          'unicode-range: ${font.unicodeRange}; }',
  ].join('\n  ');
  final stack = skillGroups.expand((g) => g.items).take(6).map((t) => '<span class="tag">${_esc(t)}</span>').join();
  return '''
<!doctype html>
<html lang="${locale.code}">
<head>
<meta charset="utf-8">
<style>
$fontFaces
  * { box-sizing: border-box; margin: 0; }
  body {
    width: 1200px; height: 630px; padding: 72px 80px; overflow: hidden;
    display: flex; flex-direction: column; justify-content: space-between;
    color: #e6edf7; font-family: Inter, system-ui, sans-serif;
    background:
      radial-gradient(ellipse 70% 80% at 85% 20%, rgba(1, 117, 194, .35), transparent 70%),
      linear-gradient(rgba(64, 196, 255, .07) 1px, transparent 1px) 0 0 / 40px 40px,
      linear-gradient(90deg, rgba(64, 196, 255, .07) 1px, transparent 1px) 0 0 / 40px 40px,
      #0a101d;
  }
  .mono { font-family: 'JetBrains Mono', ui-monospace, monospace; }
  .logo { font-size: 30px; font-weight: 700; }
  .accent { color: #40c4ff; }
  h1 { font-size: 84px; line-height: 1.05; letter-spacing: -0.03em; margin-top: 8px; }
  .role { font-size: 36px; margin-top: 20px; }
  .meta { font-size: 24px; color: #9aa8bf; margin-top: 14px; }
  .tags { display: flex; gap: 12px; flex-wrap: wrap; }
  .tag { font-size: 22px; padding: 8px 18px; border-radius: 999px; border: 1px solid #22304a; background: #152036; }
</style>
</head>
<body>
  <div class="logo mono"><span class="accent">~/</span>${_esc(profile.shortName.of(locale).toLowerCase())}<span class="accent">_</span></div>
  <div>
    <h1>${_esc(profile.name.of(locale))}</h1>
    <p class="role mono accent">${_esc(profile.role.of(locale))}</p>
    <p class="meta">${_esc(profile.level.of(locale))} · ${_esc(profile.city.of(locale))}</p>
  </div>
  <div class="tags mono">$stack</div>
</body>
</html>''';
}
