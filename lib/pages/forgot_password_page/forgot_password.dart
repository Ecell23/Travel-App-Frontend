import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/widgets/custom_background/custom_background.dart';

import '../../config/constants.dart';
import '../../models/user.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? _isNotvalid ;
  bool pendingrequest = false;
  TextEditingController emailcontroller = TextEditingController();

  void sendOTP() async {
    setState(() {
      pendingrequest = true;
    });
    var reqBody = {
      "email":emailcontroller.text
    };
    try{
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/user/send_otp'),
        body: jsonEncode(reqBody),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
      );
      if(res.statusCode==200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP sent")));
        Navigator.pushNamed(context, '/otpVerification',arguments: reqBody["email"]);
      } else {
        _isNotvalid = res.body;
      }
    }
    catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection Failed")));
    }

    setState(() {
      pendingrequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 150),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Forgot Your Password?',
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                      SizedBox(height: 120),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Provide your email / contact number',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          errorText: _isNotvalid,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.error)
                          ),
                          hintText: 'E-Mail',
                          filled: true,
                          fillColor: Colors.teal.withOpacity(0.7),
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: Colors.white,
                        onChanged: (_) {
                          setState(() {
                            _isNotvalid = null;
                          });
                        },
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                          onPressed: pendingrequest? (){} : () {
                            sendOTP();
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          elevation: 10,
                          shadowColor: Colors.black.withOpacity(0.4),
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
              Positioned(
                top: 40,
                left: 16,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
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