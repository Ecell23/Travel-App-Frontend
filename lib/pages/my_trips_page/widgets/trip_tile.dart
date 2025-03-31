import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../models/trip.dart';

class TripTile extends StatelessWidget {
  final Trip trip;
  const TripTile({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 7,
            ),
          ],
        ),
        child: Column(
          children: [
            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${trip.locations[1]} Trip', style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 2),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                DateFormat('dd-MM-yyyy').format(trip.startDate),
                                style: TextStyle(fontSize: 13, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: ListView.builder(
                          physics: trip.locations.length<3? NeverScrollableScrollPhysics():null,
                          itemCount: trip.locations.length,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location Icon & Dotted Line (Aligned Left)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16), // Offset to the left
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                                      ),
                                      if (index < trip.locations.length - 1) // Add line for all except last item
                                        DottedLine(
                                          direction: Axis.vertical,
                                          lineLength: 40,
                                          dashColor: Colors.grey,
                                          lineThickness: 2,
                                          dashLength: 4,
                                          dashGapLength: 3,
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5), // Space between dotted line and text
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center, // Align text with day number
                                      children: [
                                        Expanded(
                                          child: Text(
                                            index == 0 ? '${trip.startLocation} - Start' : trip.locations[index],
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ),
                                        Text(
                                          'Day ${index + 1}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer Section
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.people_alt_outlined, color: Colors.white),
                      SizedBox(width: 6),
                      Text(trip.guests.toString(), style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {}, // Add your action here
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('View Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
