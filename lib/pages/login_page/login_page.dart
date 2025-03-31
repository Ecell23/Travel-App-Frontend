import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/widgets/custom_background/custom_background.dart';
import 'package:http/http.dart' as http;

import '../../config/constants.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordHidden = true;
  String? _isNotvalid ;
  bool pendingrequest = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void loginUser() async {
    setState(() {
      pendingrequest = true;
    });
    var reqBody = {
      "email":emailcontroller.text,
      "password":passwordcontroller.text
    };
    try{
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/user/login'),
        body: jsonEncode(reqBody),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
      );
      if(res.statusCode==200){
        print(jsonDecode(res.body));
        Provider.of<Auth>(context, listen: false).login(res.headers['x-auth-token']!,jsonDecode(res.body)["user"] );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
        Navigator.pushNamedAndRemoveUntil(context, '/homepage',(Route<dynamic> route) => false);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40), // Space from the top
                // Top back button with "Get Started" text
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Go back
                      },
                    ),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40), // Space below top section

                // Welcome Back Text
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 100), // Space below welcome text

                // Email/Contact Number TextField
                TextField(
                  controller: emailcontroller,
                  cursorColor: Colors.white,
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
                      fontWeight: FontWeight.w400,
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
                  onChanged: (_) {
                    setState(() {
                      _isNotvalid = null;
                    });
                  },
                ),
                SizedBox(height: 20), // Space below email field

                // Password TextField with Visibility Toggle
                TextField(
                  controller: passwordcontroller,
                  obscureText: _isPasswordHidden,
                  cursorColor: Colors.white,
                  onChanged: (_) {
                    setState(() {
                      _isNotvalid = null;
                    });
                  },
                  decoration: InputDecoration(
                    errorText: _isNotvalid,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error)
                    ),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.teal.withOpacity(0.7),
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10), // Space below password field

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Space below the forgot password link

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Click to Login Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: pendingrequest? (){} : () {
                          loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: pendingrequest? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.orange,
                          ),
                        ) : Text(
                          'CLICK TO LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Space between buttons
                    // Skip For Now Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/homepage',(Route<dynamic> route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(
                          'SKIP FOR NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space below buttons

                // Don't have an account? Tap to SignUp
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'SignUp',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
