import 'package:flutter/material.dart';

class AddContactWidget extends StatelessWidget {
  final Function(String) onAddContact;

  AddContactWidget({required this.onAddContact});

  bool isValidPhoneNumber(String phoneNumber) {
    // Basic validation for a 10-digit number (can be modified for international numbers)
    final regex = RegExp(r'^\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController contactController = TextEditingController();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Add New Contact',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
                content: TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      String enteredNumber = contactController.text.trim();

                      if (enteredNumber.isNotEmpty && isValidPhoneNumber(enteredNumber)) {
                        onAddContact(enteredNumber);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a valid 10-digit phone number.'),
                            backgroundColor: colorScheme.error,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                ],
              );
            },
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'ADD CONTACT',
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
