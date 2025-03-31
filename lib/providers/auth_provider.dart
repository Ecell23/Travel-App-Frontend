import 'package:flutter/material.dart';

import '../models/user.dart';

class Auth extends ChangeNotifier {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _token != null;

  void login(String token, Map<String, dynamic> userData) {
    _token = token;
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  void updateToken(String newToken) {
    _token = newToken;
    notifyListeners();
  }
}