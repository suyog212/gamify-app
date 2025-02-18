import 'dart:ui';

enum Language {
  english(
    Locale('en', 'US'),
    'English',
  ),
  german(
    Locale('de'),
    'German',
  ),
  hindi(
    Locale('hi'),
    'Hindi',
  ),
  danish(
    Locale('da'),
    'Danish',
  ),
  swedish(
    Locale('sv'),
    'Swedish',
  );



  const Language(
      this.value,
      this.text,
      );

  final Locale value;
  final String text;
}