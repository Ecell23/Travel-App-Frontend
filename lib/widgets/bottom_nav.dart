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
          if(index == 1 && currentindex!=1){
            Navigator.pushNamed(context, '/myTripsPage');
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
