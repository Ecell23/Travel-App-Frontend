import 'package:flutter/material.dart';
import 'package:travel_app/pages/filter_page/filter_page.dart';
import 'package:travel_app/pages/pages.dart';
import 'package:travel_app/pages/profile_page/profile_page.dart';

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
        '/bookingPage' : (context) => BookingPage(),
        '/filterpage':(context)=> FilterPage(),
        '/profilepage':(context)=> ProfilePage(),
        '/searchPage' : (context) => SearchPage()
      },
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}
