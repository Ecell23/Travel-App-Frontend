import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/widgets/custom_background/custom_background.dart';
import 'package:http/http.dart' as http;

import '../../config/constants.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isPasswordHidden = true;
  String? _isNotvalid ;
  bool pendingrequest = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void registerUser() async {
    setState(() {
      pendingrequest = true;
    });
    var reqBody = {
      "name":namecontroller.text,
      "email":emailcontroller.text,
      "password":passwordcontroller.text
    };
    try{
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/user/signUp'),
        body: jsonEncode(reqBody),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
      );
      if(res.statusCode==200){
        Provider.of<Auth>(context, listen: false).login(res.headers['x-auth-token']!,jsonDecode(res.body) );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
        Navigator.pushNamedAndRemoveUntil(context, '/homepage',(Route<dynamic> route) => false);
      } else {
        _isNotvalid = res.body;
      }
    }
    catch(e){
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
                // Top back button with "Signup" text
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Go back
                      },
                    ),
                    Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40), // Space below top section

                // Welcome Text
                Text(
                  'Enter Your Details!',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 70), // Space below welcome text

                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    errorText: _isNotvalid,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error)
                    ),
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.teal.withOpacity(0.7),
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  cursorColor: Colors.white,
                  onChanged: (_) {
                    setState(() {
                      _isNotvalid = null;
                    });
                  },
                ),
                SizedBox(height: 20),

                // Email/Contact Number TextField
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
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  cursorColor: Colors.white,
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  cursorColor: Colors.white,
                ),
                SizedBox(height: 30), // Space below the password field

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Click to Signup Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: pendingrequest? (){} : () {
                          registerUser();
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
                          'CLICK TO SIGNUP',
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

                // Already have an account? Login
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account already? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log In',
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
