import 'package:flutter/material.dart';
import 'package:travel_app/utils/widgets/custom_background/custom_background.dart';

class OtpverificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40), // Space from the top

                // Top back button with "LogIn" text
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Go back
                      },
                    ),
                    Text(
                      'OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40), // Space below top section

                // Enter The OTP Text
                Text(
                  'Enter The OTP We Sent You!',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 150), // Space below heading

                // OTP TextFields
                OTPInputField(), // Updated OTP field with auto-focus

                SizedBox(height: 50), // Space below OTP fields

                // VERIFY OTP Button
                ElevatedButton(
                  onPressed: () {
                    // Add your action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Center(
                    child: Text(
                      'VERIFY OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space below "VERIFY OTP" button

                // CLICK TO RESEND Button
                ElevatedButton(
                  onPressed: () {
                    // Add your action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Center(
                    child: Text(
                      'CLICK TO RESEND',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

// Reusable OTP TextField Widget
class OTPInputField extends StatefulWidget {
  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus(); // Hide keyboard after the last digit
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
            (index) => SizedBox(
          width: 40, // Fixed width for each OTP field
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1, // Limit to one character
            cursorColor: Colors.white, // White cursor
            onChanged: (value) => _onChanged(value, index),
            decoration: InputDecoration(
              counterText: "", // Removes the character counter below the field
              filled: true,
              fillColor: _focusNodes[index].hasFocus
                  ? Colors.teal // Highlighted when focused
                  : Colors.teal.withOpacity(0.5), // Light when not focused
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
