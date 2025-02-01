import 'package:flutter/material.dart';
import 'package:travel_app/utils/utils/widgets/custom_background/custom_background.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome Image
                Image.asset(
                  'lib/assets/images/welcome.png', // Path to your asset image
                  height: 200, // Adjust height as per design
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 40), // Space below the image

                // Welcome Heading
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 32, // Font size for the heading
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 16), // Space below the heading

                // Subheading Text
                Text(
                  "We're glad that you're here. Let's get started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16, // Font size for the subheading
                    color: Colors.black54, // Muted color for subtext
                  ),
                ),
                SizedBox(height: 40), // Space below the subheading

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    // Add navigation or action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                  child: Text(
                    'GET STARTED',
                    style: TextStyle(
                      fontSize: 16, // Font size for the button text
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
