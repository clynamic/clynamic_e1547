import 'dart:ui';

import 'package:flutter/material.dart';

Color? naturalColorLerp(Color a, Color b, double t) {
  return HSVColor.lerp(HSVColor.fromColor(a), HSVColor.fromColor(b), t)
      ?.toColor();
}

const Color accent = Color(0xFFFFC107);

const MaterialColor primarySwatch = MaterialColor(
  0xFFFCB328,
  <int, Color>{
    50: Color(0xFFFFF6E5),
    100: Color(0xFFFEE8BF),
    200: Color(0xFFFED994),
    300: Color(0xFFFDCA69),
    400: Color(0xFFFCBE48),
    500: Color(0xFFFCB328),
    600: Color(0xFFFCAC24),
    700: Color(0xFFFBA31E),
    800: Color(0xFFFB9A18),
    900: Color(0xFFFA8B0F),
  },
);

final ThemeData appTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: primarySwatch,
    accentColor: accent,
    cardColor: const Color(0xFFFDB245),
    backgroundColor: const Color.fromARGB(255, 20, 20, 20),
    brightness: Brightness.dark,
  ),
).copyWith(
  applyElevationOverlayColor: false,
);

class DesktopScrollBehaviour extends ScrollBehavior {
  const DesktopScrollBehaviour();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
