import 'package:flutter/material.dart';
import 'package:travel_app/utils/widgets/custom_background/custom_background.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Center(
        child: Text(
          'Welcome to the Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}