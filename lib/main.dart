import 'package:flutter/material.dart';
import 'package:travel_app/pages/forgot_password_page/forgot_password.dart';
import 'package:travel_app/pages/login_page/login_page.dart';
import 'package:travel_app/pages/signup_page/signup_page.dart';
import 'package:travel_app/pages/otp_verification_page/otp_verification.dart';
import 'package:travel_app/pages/welcome_page/welcome_page.dart';
import 'package:travel_app/pages/splash_screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/forgotPassword',  // Set the splash screen as initial route
      routes: {
        '/splash': (context) => SplashScreen(),  // Add splash screen route
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        '/otpVerification': (context) => OtpverificationPage(),
      },
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}
