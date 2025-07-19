import 'package:flutter/material.dart';
import 'package:travel_app/pages/welcome_page/welcome_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Show the splash screen for 3 seconds before navigating
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Background color for the splash screen
      body: Stack(
        children: [
          // App Image in the center
          Center(
            child: Image.asset(
              'lib/assets/images/welcome.png', // Your app logo/image path
              height: 200, // Adjust the height as needed
              fit: BoxFit.contain,
            ),
          ),
          // Circular loading indicator at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange), // Customize the color if needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
