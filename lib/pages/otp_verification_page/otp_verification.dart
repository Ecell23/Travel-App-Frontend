import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/widgets/custom_background/custom_background.dart';

import '../../config/constants.dart';

class OtpverificationPage extends StatefulWidget {
  @override
  State<OtpverificationPage> createState() => _OtpverificationPageState();
}
class _OtpverificationPageState extends State<OtpverificationPage> {
  bool _isNotvalid  = false;
  bool pendingrequest = false;
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  void verifyOTP() async {
    setState(() {
      pendingrequest = true;
    });
    String otp = '';
    for (var e in _controllers) {
      otp+=e.text;
    }

    if(otp.length<6){
      setState(() {
        _isNotvalid = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect OTP")));
    }
    else{
      var reqBody = {
        "email": ModalRoute.of(context)?.settings.arguments,
        "otp" : otp
      };
      try{
        http.Response res = await http.post(
          Uri.parse('${Constants.uri}/api/user/verify_otp'),
          body: jsonEncode(reqBody),
          headers: <String,String>{
            'Content-Type' : 'application/json; charset=UTF-8',
          },
        );
        if(res.statusCode==200){
          if(jsonDecode(res.body)["valid"]) {
            String? token = res.headers["x-pwdreset-token"];
            print(token);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP verified")));
            Navigator.of(context).pushNamedAndRemoveUntil('/resetPasswordPage', ModalRoute.withName('/login'),arguments: token);
          } else{
            setState(() {
              _isNotvalid = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect OTP")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request new OTP")));
          Navigator.of(context).pop();
        }
      }
      catch(e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection Failed")));
      }

    }


    setState(() {
      pendingrequest = false;
    });
  }

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
                OTPInputField(controllers: _controllers,isError: _isNotvalid,resetError: () {
                  setState(() {
                    _isNotvalid = false;
                  });
                },), // Updated OTP field with auto-focus

                SizedBox(height: 50), // Space below OTP fields

                // VERIFY OTP Button
                ElevatedButton(
                  onPressed: pendingrequest? (){} : () {
                    verifyOTP();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Center(
                    child: pendingrequest? SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.orange,
                      ),
                    ) : Text(
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
                    Navigator.of(context).pop();
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
  final List<TextEditingController> controllers;
  final bool isError;
  final VoidCallback resetError;

  const OTPInputField({super.key, required this.controllers, required this.isError, required this.resetError});
  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    widget.resetError();
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus(); // Hide keyboard after the last digit
      }
    }
    else{
      if(index>0){
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
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
            controller: widget.controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1, // Limit to one character
            cursorColor: Colors.white, // White cursor
            onChanged: (value) => _onChanged(value, index),
            decoration: InputDecoration(
              errorText: widget.isError? '' : null,
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.error,width: 1.5)
              ),
              counterText: "", // Removes the character counter below the field
              filled: true,
              fillColor: Colors.teal.withOpacity(0.5), // Light when not focused
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:  BorderSide.none,
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
