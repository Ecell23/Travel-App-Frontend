import 'package:flutter/material.dart';
import 'package:travel_app/pages/pages.dart';
import 'config/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',  // Set the splash screen as initial route

      routes: {
        '/splash': (context) => SplashScreen(),  // Add splash screen route
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        '/otpVerification': (context) => OtpverificationPage(),
        '/homepage': (context) => Homepage(),
        '/searchPage' : (context) => SearchPage()
      },
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}
