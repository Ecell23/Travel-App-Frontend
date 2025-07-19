import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/pages/filter_page/filter_page.dart';
import 'package:travel_app/pages/pages.dart';
import 'package:travel_app/pages/profile_page/profile_page.dart';
import 'package:travel_app/providers/auth_provider.dart';
import 'config/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void setDarkMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Flutter App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/splash',  // Set the splash screen as initial route
      routes: {
        '/splash': (context) => SplashScreen(),  // Add splash screen route
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        '/otpVerification': (context) => OtpverificationPage(),
        '/homepage': (context) => Homepage(),
        '/resetPasswordPage' : (context) => paasswordResetPage(),
        '/bookingPage' : (context) => BookingPage(),
        '/filterpage':(context)=> FilterPage(),
        '/profilepage':(context)=> ProfilePage(),
        '/searchPage' : (context) => SearchPage(),
        '/emergencyPage' : (context) => EmergencyContactPage(),
        '/mapsPage' : (context) => MapsPage(),
        '/myTripsPage' : (context) => MyTripsPage(),
      },
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}
