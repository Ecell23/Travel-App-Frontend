import 'package:flutter/material.dart';
import 'package:travel_app/pages/emergency_page/utils/utils.dart'; // Adjust the import path according to your folder structure

class SOSButtonWidget extends StatelessWidget {
  final List<String> emergencyContacts;

  SOSButtonWidget({required this.emergencyContacts});

  void onSOSPressed(BuildContext context) async {
    try {
      // Request permissions and proceed only if granted
      bool permissionsGranted = await requestPermissions();
      if (!permissionsGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SOS Failed. Please grant all required permissions.')),
        );
        return;
      }

      // Flags to check if both SMS and Police call succeed
      bool smsSuccess = false;
      bool policeCallSuccess = false;

      // Attempt to send Emergency SMS
      smsSuccess = await sendEmergencySMS(context, emergencyContacts);

      // Attempt to call Police
      policeCallSuccess = await callPolice(context);

      // Show success message if both operations succeed
      if (smsSuccess && policeCallSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Emergency SMS sent and police called successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SOS Failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send SOS or call police.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSOSPressed(context),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 15,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                'SOS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
