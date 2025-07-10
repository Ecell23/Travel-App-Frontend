import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromRGBO(24, 192, 193, 1),
          onPrimary: Colors.white,
          secondary: Color.fromRGBO(255, 146, 90, 1),
          onSecondary: Color.fromRGBO(0, 0, 0, 0.4),
          error: Colors.redAccent,
          onError: Colors.white,
          surface: Color.fromRGBO(242, 245, 250, 1),
          onSurface: Color.fromRGBO(84, 106, 131, 1),
          secondaryContainer: Color.fromRGBO(24, 192, 193, 0.25)
      ),
      scaffoldBackgroundColor: Color.fromRGBO(242, 245, 250, 1),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),

        bodyLarge: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
      bodySmall: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)
    )
  );
}
