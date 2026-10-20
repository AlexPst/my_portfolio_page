import 'package:jaspr/dom.dart';

/// Дизайн-токены. Значения задаются CSS-переменными, поэтому смена темы
/// не требует пересборки: достаточно атрибута `data-theme` на `<html>`.
abstract final class AppColors {
  static const bg = Color.variable('--bg');
  static const surface = Color.variable('--surface');
  static const surfaceRaised = Color.variable('--surface-raised');
  static const border = Color.variable('--border');
  static const text = Color.variable('--text');
  static const muted = Color.variable('--muted');
  static const accent = Color.variable('--accent');
  static const accentStrong = Color.variable('--accent-strong');
  static const onAccent = Color.variable('--on-accent');
  static const focus = Color.variable('--focus');
}

abstract final class AppFonts {
  static const sans = FontFamily.list([
    FontFamily('Inter'),
    FontFamilies.uiSansSerif,
    FontFamily('system-ui'),
    FontFamilies.sansSerif,
  ]);
  static const mono = FontFamily.list([
    FontFamily('JetBrains Mono'),
    FontFamilies.uiMonospace,
    FontFamily('SFMono-Regular'),
    FontFamilies.monospace,
  ]);
}

abstract final class Breakpoints {
  static const sm = 640;
  static const md = 900;
}

/// Ширина контентной колонки.
const contentMaxWidth = Unit.pixels(1120);

/// CSS-переменные светлой темы. Публичные, чтобы тесты проверяли контраст.
const lightTokens = {
  '--bg': '#f6f8fb',
  '--surface': '#ffffff',
  '--surface-raised': '#eef3f9',
  '--border': '#d6dfeb',
  '--text': '#0b1324',
  '--muted': '#4a5568',
  '--accent': '#0168a8',
  '--accent-strong': '#0175c2',
  '--on-accent': '#ffffff',
  '--focus': '#0175c2',
  '--success': '#15803d',
  '--grid': 'rgba(1, 117, 194, 0.07)',
  'color-scheme': 'light',
};

/// CSS-переменные тёмной темы.
const darkTokens = {
  '--bg': '#0a101d',
  '--surface': '#0f1829',
  '--surface-raised': '#152036',
  '--border': '#22304a',
  '--text': '#e6edf7',
  '--muted': '#9aa8bf',
  '--accent': '#40c4ff',
  '--accent-strong': '#0175c2',
  '--on-accent': '#ffffff',
  '--focus': '#40c4ff',
  '--success': '#4ade80',
  '--grid': 'rgba(64, 196, 255, 0.06)',
  'color-scheme': 'dark',
};

/// Глобальные стили сайта.
@css
List<StyleRule> get themeStyles => [
  // Тема: светлая по умолчанию, тёмная по системной настройке,
  // явный выбор через data-theme перекрывает систему.
  css(':root').styles(raw: lightTokens),
  css.media(const MediaQuery.all(prefersColorScheme: .dark), [
    css(':root:not([data-theme="light"])').styles(raw: darkTokens),
  ]),
  css(':root[data-theme="dark"]').styles(raw: darkTokens),

  css('*, *::before, *::after').styles(boxSizing: .borderBox),
  css('html').styles(
    raw: {
      'scroll-behavior': 'smooth',
      '-webkit-text-size-adjust': '100%',
      'text-size-adjust': '100%',
      'scroll-padding-top': '5rem',
    },
  ),
  css('body').styles(
    minHeight: 100.vh,
    margin: .zero,
    color: AppColors.text,
    fontFamily: AppFonts.sans,
    fontSize: 1.0625.rem,
    lineHeight: 1.6.em,
    backgroundColor: AppColors.bg,
    raw: {
      '-webkit-font-smoothing': 'antialiased',
      'text-rendering': 'optimizeLegibility',
    },
  ),
  css('h1, h2, h3, h4').styles(
    margin: .zero,
    fontWeight: .w700,
    lineHeight: 1.2.em,
    raw: {'text-wrap': 'balance', 'letter-spacing': '-0.02em'},
  ),
  css('p').styles(margin: .zero, raw: {'text-wrap': 'pretty'}),
  css('img, svg').styles(display: .block, maxWidth: 100.percent),
  css('a').styles(
    color: AppColors.accent,
    raw: {'text-underline-offset': '0.2em'},
  ),
  css('code, pre').styles(fontFamily: AppFonts.mono),
  css('ul').styles(raw: {'padding-left': '1.25rem'}),

  // Видимый фокус для клавиатуры.
  css(':focus-visible').styles(
    outline: Outline(color: AppColors.focus, style: .solid, width: OutlineWidth(2.px), offset: 3.px),
    raw: {'border-radius': '4px'},
  ),
  css('::selection').styles(color: AppColors.onAccent, backgroundColor: AppColors.accentStrong),

  // Утилиты.
  css('.container').styles(
    width: 100.percent,
    maxWidth: contentMaxWidth,
    padding: .symmetric(horizontal: 1.25.rem),
    margin: const .symmetric(horizontal: .auto),
  ),
  css('.visually-hidden').styles(
    position: const .absolute(),
    width: 1.px,
    height: 1.px,
    padding: .zero,
    margin: .all((-1).px),
    overflow: .hidden,
    whiteSpace: .noWrap,
    raw: {'clip': 'rect(0 0 0 0)', 'clip-path': 'inset(50%)', 'border': '0'},
  ),
  css('.section').styles(padding: .symmetric(vertical: 4.rem)),
  css('.section-title').styles(
    margin: .only(bottom: 1.5.rem),
    fontSize: 1.75.rem,
    raw: {'font-size': 'clamp(1.5rem, 1.2rem + 1.2vw, 2rem)'},
  ),
  css('.section-title::before').styles(
    content: '# ',
    color: AppColors.accent,
    fontFamily: AppFonts.mono,
    fontWeight: .w400,
  ),
  css('.tag').styles(
    display: .inlineFlex,
    padding: .symmetric(vertical: 0.25.rem, horizontal: 0.625.rem),
    border: .all(color: AppColors.border, style: .solid, width: 1.px),
    radius: .circular(999.px),
    alignItems: .center,
    color: AppColors.text,
    fontFamily: AppFonts.mono,
    fontSize: 0.8125.rem,
    lineHeight: 1.4.em,
    backgroundColor: AppColors.surfaceRaised,
  ),

  // Кнопки.
  css('.btn', [
    css('&').styles(
      display: .inlineFlex,
      padding: .symmetric(vertical: 0.75.rem, horizontal: 1.25.rem),
      border: .all(color: Colors.transparent, style: .solid, width: 1.px),
      radius: .circular(10.px),
      transition: Transition.combine([
        Transition('background-color', duration: 150.ms),
        Transition('border-color', duration: 150.ms),
        Transition('transform', duration: 150.ms),
      ]),
      alignItems: .center,
      gap: Gap.column(0.5.rem),
      fontWeight: .w600,
      textDecoration: const TextDecoration(line: .none),
      lineHeight: 1.2.em,
    ),
    css('&:hover').styles(transform: Transform.translate(y: (-1).px)),
    css('&.btn-primary').styles(color: AppColors.onAccent, backgroundColor: AppColors.accentStrong),
    css('&.btn-primary:hover').styles(raw: {'background-color': 'color-mix(in srgb, var(--accent-strong) 85%, #000)'}),
    css('&.btn-ghost').styles(
      border: .all(color: AppColors.border, style: .solid, width: 1.px),
      color: AppColors.text,
      backgroundColor: AppColors.surface,
    ),
    css('&.btn-ghost:hover').styles(
      border: .all(color: AppColors.accent, style: .solid, width: 1.px),
    ),
  ]),

  // Анимация появления.
  css.keyframes('fade-up', {
    'from': Styles(opacity: 0, transform: Transform.translate(y: 16.px)),
    'to': const Styles(opacity: 1, transform: Transform.translate(y: .zero)),
  }),
  css('.reveal').styles(
    animation: Animation(
      name: 'fade-up',
      duration: 600.ms,
      curve: const Curve.cubicBezier(0.2, 0.7, 0.2, 1),
      fillMode: .both,
    ),
  ),
  for (var i = 1; i <= 4; i++) css('.reveal-$i').styles(raw: {'animation-delay': '${i * 90}ms'}),
  // Блоки ниже первого экрана появляются при прокрутке там, где есть scroll-driven animations.
  css.supports('(animation-timeline: view())', [
    css('.reveal-on-scroll').styles(
      animation: Animation(name: 'fade-up', duration: 1.ms, curve: .linear, fillMode: .both),
      raw: {'animation-timeline': 'view()', 'animation-range': 'entry 0% entry 60%'},
    ),
  ]),
  css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
    css('html').styles(raw: {'scroll-behavior': 'auto'}),
    css('*, *::before, *::after').styles(
      raw: {
        'animation-duration': '0.01ms !important',
        'animation-delay': '0ms !important',
        'animation-timeline': 'auto !important',
        'transition-duration': '0.01ms !important',
      },
    ),
  ]),
];
