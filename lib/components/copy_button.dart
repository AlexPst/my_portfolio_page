import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../styles/theme.dart';

enum _CopyStatus { idle, done, failed }

/// Кнопка «Скопировать» для текста (например email).
///
/// `@client`: в статическом HTML кнопка скрыта атрибутом `hidden`, потому что
/// без JavaScript она бесполезна. После гидрации она появляется.
@client
class CopyButton extends StatefulComponent {
  const CopyButton({
    required this.text,
    required this.label,
    required this.doneLabel,
    required this.failedLabel,
    super.key,
  });

  final String text;
  final String label;

  /// Подпись после успешного копирования.
  final String doneLabel;

  /// Подпись, если браузер запретил доступ к буферу обмена.
  final String failedLabel;

  @override
  State<CopyButton> createState() => _CopyButtonState();

  @css
  static List<StyleRule> get styles => [
    css('.copy-button', [
      css('&').styles(
        display: .inlineFlex,
        padding: .symmetric(vertical: 0.375.rem, horizontal: 0.75.rem),
        border: .all(color: AppColors.border, style: .solid, width: 1.px),
        radius: .circular(8.px),
        cursor: .pointer,
        alignItems: .center,
        color: AppColors.text,
        fontFamily: AppFonts.mono,
        fontSize: 0.8125.rem,
        backgroundColor: AppColors.surfaceRaised,
      ),
      css('&:hover').styles(
        border: .all(color: AppColors.accent, style: .solid, width: 1.px),
      ),
      css('&[hidden]').styles(display: .none),
      css('&.is-done').styles(
        border: .all(color: const Color.variable('--success'), style: .solid, width: 1.px),
        color: const Color.variable('--success'),
      ),
      css('&.is-failed').styles(color: AppColors.muted),
    ]),
  ];
}

class _CopyButtonState extends State<CopyButton> {
  /// На сервере `false`: кнопка рендерится скрытой.
  final bool _available = kIsWeb;
  _CopyStatus _status = .idle;
  Timer? _reset;

  Future<void> _copy() async {
    _CopyStatus result;
    try {
      await web.window.navigator.clipboard.writeText(component.text).toDart;
      result = .done;
    } catch (_) {
      // Нет фокуса, нет разрешения или небезопасный контекст (http).
      result = .failed;
    }
    if (!mounted) return;
    _reset?.cancel();
    setState(() => _status = result);
    _reset = Timer(const Duration(seconds: 2), () => setState(() => _status = .idle));
  }

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final (label, modifier) = switch (_status) {
      .idle => (component.label, ''),
      .done => (component.doneLabel, ' is-done'),
      .failed => (component.failedLabel, ' is-failed'),
    };

    return button(
      type: ButtonType.button,
      classes: 'copy-button$modifier',
      attributes: {if (!_available) 'hidden': ''},
      onClick: _copy,
      [
        // role=status зачитывает смену подписи скринридером.
        span(attributes: {'role': 'status'}, [.text(label)]),
      ],
    );
  }
}
