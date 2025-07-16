import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

final Telephony telephony = Telephony.instance;

/// Request necessary permissions
Future<bool> requestPermissions() async {
  var smsPermissionStatus = await Permission.sms.status;
  if (!smsPermissionStatus.isGranted && !await Permission.sms.request().isGranted) return false;

  var phonePermissionStatus = await Permission.phone.status;
  if (!phonePermissionStatus.isGranted && !await Permission.phone.request().isGranted) return false;

  var locationPermissionStatus = await Permission.location.status;
  if (!locationPermissionStatus.isGranted && !await Permission.location.request().isGranted) return false;

  var locationBackgroundPermissionStatus = await Permission.locationAlways.status;
  if (!locationBackgroundPermissionStatus.isGranted && !await Permission.locationAlways.request().isGranted) return false;

  bool? granted = await telephony.requestPhoneAndSmsPermissions;
  if (granted == false) return false;

  return true;
}

/// Sends an emergency SMS and returns success status
Future<bool> sendEmergencySMS(BuildContext context, List<String> emergencyContacts) async {
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String locationUrl = "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
    String message = "I need help! Here is my location: $locationUrl";

    for (String contact in emergencyContacts) {
      await telephony.sendSms(to: contact, message: message);
    }
    return true;
  } catch (e) {
    return false;
  }
}

/// Calls police and returns success status
Future<bool> callPolice(BuildContext context) async {
  try {
    const policeNumber = "1000";
    bool? callMade = await FlutterPhoneDirectCaller.callNumber(policeNumber);
    return callMade ?? false;
  } catch (e) {
    return false;
  }
}

Future<bool> callEmergency(BuildContext context, String number) async {
  try {
    bool? callMade = await FlutterPhoneDirectCaller.callNumber(number);
    return callMade ?? false;
  } catch (e) {
    return false;
  }
}
