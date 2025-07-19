// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/place_model.dart';
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/services/trip_services.dart';
import '../provider/edit_trip_provider.dart';

class EditTripCard extends StatefulWidget {
  const EditTripCard({
    super.key,
    required this.trip,
    required this.tripService,
  });

  final Trip trip;
  final TripService tripService;

  @override
  State<EditTripCard> createState() => _EditTripCardState();
}

class _EditTripCardState extends State<EditTripCard> {
  List<PlaceModel> locations = [];
  int guestCount = 1;
  DateTime selectedDate = DateTime.now();
  late final EditTripProvider editTripProvider;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    locations = widget.trip.locations;
    guestCount = widget.trip.guests;
    selectedDate = widget.trip.startDate;
    editTripProvider = EditTripProvider(
      tripService: widget.tripService,
      tripId: widget.trip.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTripProvider>.value(
      value: editTripProvider,
      child: Consumer<EditTripProvider>(
        builder: (context, provider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.redAccent,
                  content: Text(provider.errorMessage!),
                ),
              );
              Navigator.of(context).pop();
              provider.errorMessage = null; // Prevent duplicate snackbars
            }
            if (provider.isSuccess) {
              log('ok');
              Navigator.of(context).pop(true);
            }
          });

          return IntrinsicHeight(
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with title and delete button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(width: 12,),
                              Text(
                                'Edit Trip',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red, size: 24),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.red.withOpacity(0.1)),
                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                ),
                                tooltip: 'Delete Trip',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Delete Trip'),
                                      content: Text('Are you sure you want to delete this trip?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(false),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () => Navigator.of(ctx).pop(true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    provider.deleteTrip();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 15,
                                children: [
                                  Column(
                                      spacing: 15,
                                      children: List.generate(locations.length, (index) => GestureDetector(
                                        onTap: () async {
                                          PlaceModel? result = await Navigator.pushNamed(context, '/searchPage') as PlaceModel?;
                                          if(result!=null){
                                            setState(() {
                                              // Preserve the day value when updating the location
                                              int currentDay = locations[index].day;
                                              locations[index] = PlaceModel(
                                                placeId: result.placeId,
                                                placeName: result.placeName,
                                                latitude: result.latitude,
                                                longitude: result.longitude,
                                                day: currentDay,
                                              );
                                            });
                                          }
                                        },
                                        child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12)
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 6,
                          children: [
                            SizedBox(width: 0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(index==0? "FROM" : "LOCATION $index",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                  ),
                                  Text(locations[index].placeName,
                                  overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                if (index > 0)
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("DAYS",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                          ),
                                          SizedBox(height: 2,),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (locations[index].day > 1) {
                                                    setState(() {
                                                      locations[index] = PlaceModel(
                                                        placeId: locations[index].placeId,
                                                        placeName: locations[index].placeName,
                                                        day: locations[index].day - 1,
                                                      );
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Icon(Icons.remove, size: 18),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "${locations[index].day}",
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    locations[index] = PlaceModel(
                                                      placeId: locations[index].placeId,
                                                      placeName: locations[index].placeName,
                                                      day: locations[index].day + 1,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Icon(Icons.add, size: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                index>0 && locations.length>2? GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      locations.removeAt(index);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.delete_outline,size: 24,color: Theme.of(context).colorScheme.onSurface,),
                                  )
                                ) : SizedBox(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                                      ),)
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                        onPressed: () async {
                                          PlaceModel? result = await Navigator.pushNamed(context, '/searchPage') as PlaceModel?;
                                          if(result!=null){
                                            setState(() {
                                              // Set default day to 1 for new locations
                                              locations.add(result);
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                                        ),
                                        child: Text('ADD LOCATION',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),)
                                    ),
                                  ),
                                  Row(
                                    spacing: 15,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surface,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.black12)
                                            ),
                                            //width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                              child: Row(
                                                spacing: 6,
                                                children: [
                                                  SizedBox(width: 0,),
                                                  Icon(
                                                    Icons.calendar_today_outlined,
                                                    color:
                                                    Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                  SizedBox(width: 0,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('START AT',
                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                                      ),
                                                      Text(DateFormat.MMMd().format(selectedDate.toLocal()),
                                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surface,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.black12)
                                            ),
                                            //width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                              child: Row(
                                                spacing: 6,
                                                children: [
                                                  SizedBox(width: 0,),
                                                  Icon(
                                                    Icons.people_alt_outlined,
                                                    color:
                                                    Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                  SizedBox(width: 0,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('GUESTS  ',
                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: (){
                                                                if(guestCount>1){
                                                                  setState(() {
                                                                    guestCount--;
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(Icons.remove)
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Text(guestCount.toString(),
                                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          GestureDetector(
                                                              onTap: (){
                                                                setState(() {
                                                                  guestCount++;
                                                                });
                                                              },
                                                              child: Icon(Icons.add)
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                        onPressed: provider.editIsLoading ? null : () async {
                                          provider.editTrip({
                                            "startLocation": locations[0].toJson(),
                                            "locations": locations.map((e) => e.toJson()).toList(),
                                            "startDate": selectedDate.toIso8601String(),
                                            "guests": guestCount,
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                                        ),
                                        child: provider.editIsLoading
                                            ? SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white))
                                            : Text('SAVE',
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (provider.deleteIsLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: CircularProgressIndicator()),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}