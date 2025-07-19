import 'package:flutter/material.dart';

class EmptyDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;

  const EmptyDisplayWidget({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox, color: Colors.grey, size: 48),
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onRefresh,
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
          ),
        ],
      ),
    );
  }
} 