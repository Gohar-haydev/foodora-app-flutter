import 'package:flutter/material.dart';

/// Custom clipper for bottom navigation bar with curved notch
/// Creates a smooth curved notch in the center for the cart button
class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Start from top-left with rounded corner
    path.lineTo(0, 20);
    path.quadraticBezierTo(0, 0, 20, 0);
    
    // Draw to the start of the notch (bigger notch)
    final notchStart = size.width / 2 - 50;
    path.lineTo(notchStart, 0);
    
    // Create the curved notch for the cart button (bigger and deeper)
    path.quadraticBezierTo(
      notchStart + 10, 0,
      notchStart + 20, 15,
    );
    path.quadraticBezierTo(
      notchStart + 30, 30,
      notchStart + 50, 30,
    );
    path.quadraticBezierTo(
      notchStart + 70, 30,
      notchStart + 80, 15,
    );
    path.quadraticBezierTo(
      notchStart + 90, 0,
      notchStart + 100, 0,
    );
    
    // Draw to top-right with rounded corner
    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    
    // Draw down the right side
    path.lineTo(size.width, size.height);
    
    // Draw bottom edge
    path.lineTo(0, size.height);
    
    // Close the path
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
