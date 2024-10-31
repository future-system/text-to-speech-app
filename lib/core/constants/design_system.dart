import 'dart:ui';

sealed class DesignSystem {
  static final colors = _Colors();
}

final class _Colors {
  final Color background = const Color(0xFF282A2E);
  final Color primary = const Color(0xFF383b43);
  final Color secondary = const Color(0xFF66686C);
  final Color textDetail = const Color(0xFFF4F4F4);
  final Color error = const Color(0xFFD18275);
  final Color success = const Color(0xFF8FB98B);
}
