import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Replace with your background image path
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          // Content overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                children: [
                  SizedBox(height: 50), // Space from the top

                  // Login Header
                  Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white), // Back arrow
                      SizedBox(width: 8),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30), // Space below the header

                  // First TextField with icon
                  TextField(
                    style: TextStyle(color: Colors.black), // Text color
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9), // White background with slight transparency
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      ), // Left icon inside the text box
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        borderSide: BorderSide.none, // No border
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // Space below the first text box

                  // "Forgot Your Password?" Text Box
                  Container(
                    width: double.infinity, // Takes full width
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Padding inside
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // White background
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: Text(
                      'Forgot Your Password?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 30), // Space below the text box

                  // Reset Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded button
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Button size
                      ),
                      onPressed: () {
                        // Handle reset password action
                        print('Reset password button clicked');
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
