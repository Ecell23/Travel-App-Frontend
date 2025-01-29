import 'package:flutter/material.dart';
import 'package:travel_app/widgets/custom_background/custom_background.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground( // Using the custom background widget
        child: SingleChildScrollView( // Pass the content using the child parameter
          child: Stack(
            children: [
              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align items at the top
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Space for the "LogIn" button at the top left
                      SizedBox(height: 150), // Adjust space for the "LogIn" button

                      // Forgot Your Password? Text aligned left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Forgot Your Password?',
                          style: TextStyle(
                            fontSize: 46, // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6), // Reduced opacity
                          ),
                        ),
                      ),

                      SizedBox(height: 120), // Increased gap

                      // Provide your email/contact number text
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Provide your email / contact number',
                          style: TextStyle(
                            fontSize: 14, // Adjust font size
                            color: Colors.black54, // Muted color
                          ),
                        ),
                      ),

                      SizedBox(height: 10), // Space between label and text field

                      // Email/Contact Number TextField
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'E-Mail / Contact Number',
                          filled: true,
                          fillColor: Colors.teal.withOpacity(0.7),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),

                      SizedBox(height: 40), // Gap between fields

                      // Verification Message Button
                      ElevatedButton(
                        onPressed: () {
                          // Add action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          elevation: 10, // Shadow effect
                          shadowColor: Colors.black.withOpacity(0.4), // Shadow color
                        ),
                        child: Center(
                          child: Text(
                            'CLICK TO GET A VERIFICATION MESSAGE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // LogIn Button on the top left corner
              Positioned(
                top: 40,
                left: 16,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous page
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LogIn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
