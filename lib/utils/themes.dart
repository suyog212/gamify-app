import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{

  final ThemeData _lightThemeData = ThemeData.light(
    useMaterial3: true
  ).copyWith(
      colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.orangeAccent,
        brightness: Brightness.light,
        errorColor: Colors.redAccent,
        primarySwatch: Colors.orange
      ).copyWith(
        primary: Colors.orangeAccent,
        secondary: Colors.orangeAccent,
        inversePrimary: Colors.grey,
      ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.white,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      )
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    )
  );

  final ThemeData _darkThemeData = ThemeData.dark(
    useMaterial3: true
  ).copyWith(
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.black,
      elevation: 4
    ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white
      ),
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSwatch(
        accentColor: Colors.orangeAccent,
        brightness: Brightness.dark,
        errorColor: Colors.redAccent,
        primarySwatch: Colors.orange
    ).copyWith(
      primary: Colors.orangeAccent,
      secondary: Colors.orange
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0
    ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          )
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          )
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
  );


  ThemeData get lightTheme => _lightThemeData;
  ThemeData get darkTheme => _darkThemeData;
}