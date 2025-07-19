// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AddContactWidget extends StatelessWidget {
  final Future<bool> Function(String) onAddContact;
  final bool isLoading;

  const AddContactWidget({super.key, 
    required this.onAddContact, 
    this.isLoading = false,
  });

  bool isValidPhoneNumber(String phoneNumber) {
    // More flexible validation for phone numbers
    final regex = RegExp(r'^\+?[0-9]{10,15}$');
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
          onPressed: isLoading 
            ? null 
            : () => showDialog(
            context: context,
            builder: (context) {
              bool dialogLoading = false;
              
              return StatefulBuilder(
                builder: (context, setState) {
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
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        filled: true,
                        labelText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.phone),
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                      ),
                      keyboardType: TextInputType.phone,
                      enabled: !dialogLoading,
                    ),
                    actions: [
                      TextButton(
                        onPressed: dialogLoading ? null : () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                      dialogLoading 
                        ? Container(
                            margin: EdgeInsets.only(right: 16),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        : TextButton(
                          onPressed: () async {
                            String enteredNumber = contactController.text.trim();

                            if (enteredNumber.isNotEmpty && isValidPhoneNumber(enteredNumber)) {
                              setState(() {
                                dialogLoading = true;
                              });
                              
                              bool success = await onAddContact(enteredNumber);
                              
                              if (success) {
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  dialogLoading = false;
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter a valid phone number.'),
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
                }
              );
            },
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            disabledBackgroundColor: colorScheme.primary.withOpacity(0.6),
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
