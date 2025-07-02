import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/providers/auth_provider.dart';

import '../config/constants.dart';

class TripService {
  Auth auth;

  TripService({required this.auth});

  Future<void> postTrip(Map<String,dynamic> data) async {
    try{
      String token = auth.token??'';
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/trips'),
        body: jsonEncode(data),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
          'x-auth-token' : token,
        },
      );
      if(res.statusCode!=201){
        throw Exception('Error ${res.statusCode} : ${res.body}');
      }
    } catch(e) {
      if (e is Exception) {
        rethrow;
      } else {
        print(e);
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }

  Future<List<Trip>> getAllTrips(String token) async {
    List<Trip> trips = [];
    try{
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/trips'),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
          'x-auth-token' : token,
        },
      );
      if(res.statusCode!=200){
        throw Exception(res.body);
      }
      List<dynamic> data = jsonDecode(res.body);
      for (var entry in data) {
        trips.add(Trip.fromJson(entry));
      }
      return trips;

    }catch(e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }

  Future<Trip> updateTrip(String id,Map<String,dynamic> data) async {
    try{
      String token = auth.token??'';
      http.Response res = await http.put(
        Uri.parse('${Constants.uri}/api/trips/$id'),
        body: jsonEncode(data),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
          'x-auth-token' : token,
        },
      );
      final body = jsonDecode(res.body);
      if(res.statusCode!=200 || body['success']!=true){
        throw Exception(body);
      }
      return Trip.fromJson(body['trip']);
    } catch(e) {
      if (e is Exception) {
        rethrow;
      } 
      if(e is SocketException){
        throw Exception("No internet connection");
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }

  Future<void> deleteTrip(String id) async {
    try{
      String token = auth.token??'';
      http.Response res = await http.delete(
        Uri.parse('${Constants.uri}/api/trips/$id'),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',
          'x-auth-token' : token,
        },
      );
      final body = jsonDecode(res.body);
      if(res.statusCode!=200 ){
        throw Exception(body);
      }
    } catch(e) {
      if (e is Exception) {
        rethrow;
      } 
      if(e is SocketException){
        throw Exception("No internet connection");
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }
}
