import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black
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
      )
  );


  ThemeData get lightTheme => _lightThemeData;
  ThemeData get darkTheme => _darkThemeData;
}