import 'package:flutter/material.dart';
import 'package:travel_app/Pages/forgotpasswordpage/forgotpassword.dart';
import 'package:travel_app/Pages/loginpage/loginpage.dart';
import 'package:travel_app/Pages/signuppage/signuppage.dart';
import 'package:travel_app/Pages/otpverificationpage/otpverification.dart';
import 'package:travel_app/Pages/welcomepage/welcomepage.dart';
import 'package:travel_app/Pages/splashscreen/splashscreen.dart';

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
      initialRoute: '/splash',  // Set the splash screen as initial route
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
