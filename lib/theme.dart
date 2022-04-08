import 'dart:ui';

import 'package:flutter/material.dart';

Color dimTextColor(BuildContext context, [double opacity = 0.5]) =>
    Theme.of(context).textTheme.bodyText2!.color!.withOpacity(opacity);

const Color siteBackgroundColor = Color(0xFFFDB245);

final ThemeData appTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: const MaterialColor(
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
    ),
    accentColor: const Color(0xFFFFC107),
    cardColor: Colors.grey[900]!,
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
