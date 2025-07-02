import 'package:flutter/material.dart';
import 'package:travel_app/services/trip_services.dart';
import 'package:travel_app/models/trip.dart';

class EditTripProvider extends ChangeNotifier {
  final TripService tripService;
  final String tripId;

  bool editIsLoading = false;
  bool deleteIsLoading = false;
  bool isSuccess = false;
  String? errorMessage;
  Trip? updatedTrip;

  EditTripProvider({required this.tripService, required this.tripId});

  Future<void> editTrip(Map<String, dynamic> data) async {
    editIsLoading = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
    try {
      updatedTrip = await tripService.updateTrip(tripId, data);
      isSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
      isSuccess = false;
    } finally {
      editIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTrip() async {
    deleteIsLoading = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
    try {
      await tripService.deleteTrip(tripId);
      isSuccess = true;
    } catch (e) {
      print(e);
      errorMessage = e.toString();
      isSuccess = false;
    } finally {
      deleteIsLoading = false;
      notifyListeners();
    }
  }
}
