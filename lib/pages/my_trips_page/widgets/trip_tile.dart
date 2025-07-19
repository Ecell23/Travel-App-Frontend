import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:travel_app/pages/live_trip_page/trip_details_page.dart';
import 'package:travel_app/pages/my_trips_page/widgets/edit_trip_card.dart';
import 'package:travel_app/providers/auth_provider.dart';
import 'package:travel_app/services/trip_services.dart';
import '../../../models/trip.dart';

class TripTile extends StatefulWidget {
  final Trip trip;
  final VoidCallback onRefresh;
  final Auth auth;
  const TripTile({super.key, required this.trip, required this.onRefresh, required this.auth});

  @override
  State<TripTile> createState() => _TripTileState();
}

class _TripTileState extends State<TripTile> {
  void editTrip() async {
    bool? success = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      //constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      context: context, 
      builder: (context) => EditTripCard(
        trip: widget.trip, tripService: TripService(
          auth: widget.auth,
        )
    ));
    if(success!=null && success == true){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip updated successfully')));
        widget.onRefresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.sizeOf(context).width * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${widget.trip.locations[1].placeName} Trip', 
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                                
                              ),
                              SizedBox(height: 2),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Text(
                                  DateFormat('dd-MM-yyyy').format(widget.trip.startDate),
                                  style: TextStyle(fontSize: 13, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            editTrip();
                          }, 
                          icon: Icon(Icons.edit_outlined)),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 0),
                        child: ListView.builder(
                          physics: widget.trip.locations.length<3? NeverScrollableScrollPhysics():null,
                          itemCount: widget.trip.locations.length,
                          itemBuilder: (context, index) {
                            int day = 0;
                            for(int i = 0; i < index; i++){
                              day += widget.trip.locations[i].day;
                            }
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
                                      if (index < widget.trip.locations.length - 1) // Add line for all except last item
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
                                            index == 0 ? '${widget.trip.startLocation.placeName} - Start' : widget.trip.locations[index].placeName,
                                            style: Theme.of(context).textTheme.bodyLarge,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          'Day $day',
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
            SizedBox(height: 16,),
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
                      Text(widget.trip.guests.toString(), style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailsPage(trip: widget.trip)));
                    }, // Add your action here
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('View Details', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      ),),
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
