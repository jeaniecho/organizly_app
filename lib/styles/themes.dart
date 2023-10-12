import 'package:flutter/material.dart';
import 'package:what_to_do/styles/colors.dart';

class OGThemes {
  OGThemes._();
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffFCFDFF),
    ),
    scaffoldBackgroundColor: const Color(0xffFCFDFF),
    splashColor: Colors.transparent,
    primaryColor: const Color(0xff39A0FF),
    focusColor: const Color(0xff39A0FF),
    highlightColor: Colors.transparent,
    cardColor: Colors.white,
    disabledColor: const Color(0xFFCDCDCD),
    colorScheme: OGColors.lightColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        splashFactory: InkRipple.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: const Color(0xffD8ECFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    useMaterial3: true,
    fontFamily: 'NotoSansKR',
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff424242),
    ),
    scaffoldBackgroundColor: const Color(0xff424242),
    splashColor: Colors.transparent,
    primaryColor: const Color(0xff39A0FF),
    focusColor: const Color(0xff39A0FF),
    highlightColor: Colors.transparent,
    cardColor: const Color(0xff242424),
    disabledColor: const Color(0xFF757575),
    colorScheme: OGColors.darkColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        splashFactory: InkRipple.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: Color.fromARGB(255, 40, 111, 178),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    useMaterial3: true,
    fontFamily: 'NotoSansKR',
  );
}
