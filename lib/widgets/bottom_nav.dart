import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentindex;
  const BottomNav({
    super.key, required this.currentindex
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentindex,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.white,
        onTap: (index) {
          // Don't navigate if we're already on the selected tab
          if (index == currentindex) return;
          
          switch (index) {
            case 0: // Home
              // Clear all routes and go to homepage
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/homepage', 
                (route) => false
              );
              break;
            case 1: // My Trips
              Navigator.pushReplacementNamed(context, '/myTripsPage');
              break;
            case 2: // Maps
              Navigator.pushReplacementNamed(context, '/mapsPage');
              break;
            case 3: // Bookings
              Navigator.pushReplacementNamed(context, '/bookingPage');
              break;
            case 4: // Profile
              Navigator.pushReplacementNamed(context, '/profilepage');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.home_outlined,),
          ),label: 'Home'),
          BottomNavigationBarItem(icon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.luggage_outlined),
          ),label: 'My Trips'),
          BottomNavigationBarItem(icon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.my_location),
          ),label: 'Maps'),
          BottomNavigationBarItem(icon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.flight_takeoff_outlined),
          ),label: 'Bookings'),
          BottomNavigationBarItem(icon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.account_circle_outlined),
          ),label: 'Profile')
        ]);
  }
}
