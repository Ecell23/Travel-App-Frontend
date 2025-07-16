import 'package:flutter/material.dart';
import 'package:travel_app/pages/bookings_page/bookings_page.dart';

class PopularDestinationsCarousel extends StatelessWidget {
  PopularDestinationsCarousel({super.key});

  final List<Map<String, String>> destinations = [
    {
      'name': 'Paris',
      'image':
      'assets/images/paris.jpg',
    },
    {
      'name': 'London',
      'image':
      'assets/images/london.jpg',
    },
    {
      'name': 'Dubai',
      'image':
      'assets/images/dubai.jpg',
    },
    {
      'name': 'Singapore',
      'image':
      'assets/images/singapore.jpg',
    },
    {
      'name': 'Bali',
      'image':
      'assets/images/bali.jpg',
    },
    {
      'name': 'Maldives',
      'image':
      'assets/images/maldives.jpg',
    },
    {
      'name': 'Tokyo',
      'image':
      'assets/images/tokyo.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(
                        prefillLocation: destination['name'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(destination['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16)),
                          ),
                          child: Text(
                            destination['name']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
