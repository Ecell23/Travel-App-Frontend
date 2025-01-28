import 'package:flutter/material.dart';
import 'package:travel_app/pages/pages.dart';

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
      initialRoute: '/otpVerification', // Set the splash screen as initial route
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(), // Add splash screen route
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
