import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:travel_app/models/trip.dart';

import '../config/constants.dart';

class TripService {
  Future<void> postTrip(String token,Map<String,dynamic> data) async {
    try{
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

  Future<List<Trip>> getALlTrips(String token) async {
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
        print(e);
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }
}
