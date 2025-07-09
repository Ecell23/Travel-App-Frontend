import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config/constants.dart';

class Auth extends ChangeNotifier {
  String? _token;
  User? _user;
  String? _editError;
  bool _isLoading = false;
  
  // Add a flag to track if error has been shown
  bool _errorShown = false;

  String? get token => _token;
  User? get user => _user;
  String? get editError => _editError;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  
  // Add getter and method to handle error display
  bool get hasUnshownError => _editError != null && !_errorShown;
  
  void markErrorAsShown() {
    _errorShown = true;
  }

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
  
  Future<bool> editProfile(User updatedUser) async {
    if (_token == null) return false;
    
    _isLoading = true;
    _editError = null;
    _errorShown = false;
    notifyListeners();
    
    try {
      final response = await http.put(
        Uri.parse('${Constants.uri}/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': _token!,
        },
        body: json.encode(updatedUser.toJson()),
      );
      
      _isLoading = false;
      
      if (response.statusCode == 200) {
        _user = updatedUser;
        notifyListeners();
        return true;
      } else {
        print(response.body);
        _editError = 'Failed to update profile: ${response.body}';
        _errorShown = false;
        notifyListeners();
        
        // Reset error after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          _editError = null;
          _errorShown = false;
          notifyListeners();
        });
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _editError = 'Network error: ${e.toString()}';
      _errorShown = false;
      notifyListeners();
      
      // Reset error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        _editError = null;
        _errorShown = false;
        notifyListeners();
      });
      return false;
    }
  }
  
  // Add emergency contact
  Future<bool> addEmergencyContact(String contactNumber) async {
    if (_token == null || _user == null) return false;
    
    _isLoading = true;
    _editError = null;
    _errorShown = false;
    notifyListeners();
    
    try {
      // Create a new list with the added contact
      List<String> updatedContacts = List<String>.from(_user!.emergencyContacts);
      updatedContacts.add(contactNumber);
      
      // Create updated user object
      User updatedUser = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        phone: _user!.phone,
        imageUrl: _user!.imageUrl,
        emergencyContacts: updatedContacts,
      );
      
      // Use the existing editProfile method to update the user
      return await editProfile(updatedUser);
    } catch (e) {
      _isLoading = false;
      _editError = 'Error adding contact: ${e.toString()}';
      _errorShown = false;
      notifyListeners();
      
      // Reset error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        _editError = null;
        _errorShown = false;
        notifyListeners();
      });
      return false;
    }
  }
  
  // Remove emergency contact
  Future<bool> removeEmergencyContact(int index) async {
    if (_token == null || _user == null || index < 0 || index >= _user!.emergencyContacts.length) {
      return false;
    }
    
    _isLoading = true;
    _editError = null;
    _errorShown = false;
    notifyListeners();
    
    try {
      // Create a new list without the removed contact
      List<String> updatedContacts = List<String>.from(_user!.emergencyContacts);
      updatedContacts.removeAt(index);
      
      // Create updated user object
      User updatedUser = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        phone: _user!.phone,
        imageUrl: _user!.imageUrl,
        emergencyContacts: updatedContacts,
      );
      
      // Use the existing editProfile method to update the user
      return await editProfile(updatedUser);
    } catch (e) {
      _isLoading = false;
      _editError = 'Error removing contact: ${e.toString()}';
      _errorShown = false;
      notifyListeners();
      
      // Reset error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        _editError = null;
        _errorShown = false;
        notifyListeners();
      });
      return false;
    }
  }
}