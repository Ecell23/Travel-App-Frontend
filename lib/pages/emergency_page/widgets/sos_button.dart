import 'package:flutter/material.dart';
import 'package:travel_app/pages/emergency_page/utils/utils.dart'; // Adjust if needed

class SOSButtonWidget extends StatefulWidget {
  final List<String> emergencyContacts;

  SOSButtonWidget({required this.emergencyContacts});

  @override
  State<SOSButtonWidget> createState() => _SOSButtonWidgetState();
}

class _SOSButtonWidgetState extends State<SOSButtonWidget> {
  bool isPoliceSelected = true;

  void onSOSPressed(BuildContext context) async {
    try {
      bool permissionsGranted = await requestPermissions();
      if (!permissionsGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SOS Failed. Please grant all required permissions.')),
        );
        return;
      }

      bool smsSuccess = await sendEmergencySMS(context, widget.emergencyContacts);

      // Change number based on selection
      String emergencyNumber = isPoliceSelected ? '100' : '102'; // Police or Ambulance

      bool callSuccess = await callEmergency(context, emergencyNumber);

      if (smsSuccess && callSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SOS: ${isPoliceSelected ? "Police" : "Ambulance"} contacted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SOS Failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send SOS or call emergency services.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ToggleButtons(
          isSelected: [isPoliceSelected, !isPoliceSelected],
          borderRadius: BorderRadius.circular(20),
          selectedColor: Colors.white,
          fillColor: isPoliceSelected ? Theme.of(context).colorScheme.primary : Colors.red.shade800,
          color: Colors.black87,
          onPressed: (index) {
            setState(() {
              isPoliceSelected = index == 0;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.local_police_outlined),
                  SizedBox(width: 6),
                  Text('Police'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.local_hospital_outlined),
                  SizedBox(width: 6),
                  Text('Ambulance'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
