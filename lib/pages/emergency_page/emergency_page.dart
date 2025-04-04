import 'package:flutter/material.dart';
import 'package:travel_app/pages/emergency_page/widgets/add_contact_button.dart';
import 'package:travel_app/pages/emergency_page/widgets/sos_button.dart';
import 'package:travel_app/widgets/bottom_nav.dart';

class EmergencyContactPage extends StatefulWidget {
  @override
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  List<String> emergencyContacts = [];

  void addContact(String contact) {
    setState(() {
      emergencyContacts.add(contact);
    });
  }

  void removeContact(int index) {
    setState(() {
      emergencyContacts.removeAt(index);
    });
  }

  void showInfoDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'SOS Button Info',
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          ),
          content: Text(
            'Pressing the SOS button will:\n\n'
                '1. Send an emergency message to your saved contacts with your location.\n'
                '2. Make a direct call to the local police authorities.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety Settings',
                style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Centering the SOS Button with Info Button
                      Stack(
                        children: [
                          Center(
                            child: SOSButtonWidget(emergencyContacts: emergencyContacts),
                          ),
                          Positioned(
                            right: 20,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.info_outline, color: colorScheme.primary),
                              onPressed: () => showInfoDialog(context),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Emergency Contacts',
                        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                      ),
                      SizedBox(height: 15),

                      // Show placeholder if the list is empty
                      Expanded(
                        child: emergencyContacts.isEmpty
                            ? Center(
                          child: Text(
                            'No emergency contacts yet.',
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                          ),
                        )
                            : ListView.builder(
                          itemCount: emergencyContacts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: colorScheme.primary.withOpacity(0.5)),
                                      ),
                                      child: Text(
                                        emergencyContacts[index],
                                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: colorScheme.error),
                                    onPressed: () => removeContact(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Add Contact Button
                      SizedBox(height: 20),
                      AddContactWidget(onAddContact: addContact),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentindex: 4),
    );
  }
}
