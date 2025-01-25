import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child; // The content that will be displayed inside the custom background

  const CustomBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // White background
          Container(
            color: Colors.white,
            width: screenWidth,
            height: screenHeight,
          ),
          // Top Ellipse with the adjusted layout and opacity using custom Path
          Positioned(
            left: -370.12, // Original left position
            top: -216,    // Original top position
            child: Transform.rotate(
              angle: -185 * (3.14159 / 180), // -143 degrees rotation
              child: ClipPath(
                clipper: SteepEllipseClipper(),
                child: Container(
                  width: screenWidth * 1.5,  // Adjusted width for better visibility
                  height: screenHeight * 0.5, // Adjusted height for better visibility
                  color: Color.fromRGBO(24, 192, 193, 0.25), // rgba(24, 192, 193, 0.25)
                ),
              ),
            ),
          ),
          // Bottom Ellipse with adjusted layout and opacity using custom Path
          Positioned(
            left: 0.3,  // Original left position
            top: 700,   // Original top position
            child: Transform.rotate(
              angle: 165 * (3.14159 / 180), // -143 degrees rotation
              child: ClipPath(
                clipper: SteepEllipseClipper(),
                child: Container(
                  width: screenWidth * 1.5,  // Adjusted width for better visibility
                  height: screenHeight * 0.5, // Adjusted height for better visibility
                  color: Color.fromRGBO(24, 192, 193, 0.25), // rgba(24, 192, 193, 0.25)
                ),
              ),
            ),
          ),
          // Child content (the page content you pass to this background)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

// Custom Clipper to create a steep ellipse
class SteepEllipseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Steep ellipse with straight edges on top and bottom
    path.moveTo(0, size.height * 0.5); // Start at the middle of the left edge
    path.quadraticBezierTo(size.width * 0.3, 0, size.width * 0.5, 0); // Top curve
    path.quadraticBezierTo(size.width * 0.6, 0, size.width, size.height * 0.5); // Right curve
    path.quadraticBezierTo(size.width * 0.75, size.height, size.width * 0.2, size.height); // Bottom curve
    path.quadraticBezierTo(size.width * 0.25, size.height, 0, size.height * 0.5); // Left curve back to start

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
