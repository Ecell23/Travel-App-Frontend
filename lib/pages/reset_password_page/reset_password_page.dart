import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/widgets/custom_background/custom_background.dart';

import '../../config/constants.dart';

class paasswordResetPage extends StatefulWidget {
  const paasswordResetPage({super.key});

  @override
  State<paasswordResetPage> createState() => _paasswordResetPageState();
}

class _paasswordResetPageState extends State<paasswordResetPage> {
  bool _isPasswordHidden = true;
  TextEditingController passwordController = TextEditingController();
  String? _isNotvalid ;
  bool pendingrequest = false;
  void resetPassword() async {
    setState(() {
      pendingrequest = true;
    });
    var reqBody = {
      "token":ModalRoute.of(context)?.settings.arguments,
      "password":passwordController.text
    };
    try{
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/user/reset_password'),
        body: jsonEncode(reqBody),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
      );
      if(res.statusCode==200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reset Successful")));
        Navigator.of(context).pop();
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
                          'Reset Password',
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
                          'Provide new password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
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
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error)),
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
                              _isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: pendingrequest? (){} : () {
                          resetPassword();
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
                            'SAVE PASSWORD',
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
