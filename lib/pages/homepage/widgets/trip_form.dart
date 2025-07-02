import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/place_model.dart';
import 'package:travel_app/services/trip_services.dart';

import '../../../providers/auth_provider.dart';

class TripForm extends StatefulWidget {
  const TripForm({
    super.key,
  });

  @override
  State<TripForm> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  bool pendingRequest = false;
  List<PlaceModel> locations = [ PlaceModel(placeId: '1', placeName: 'Gangtok', day: 1), PlaceModel(placeId: '2', placeName: 'Shimla', day: 1)];
  int guestCount = 1;
  DateTime selectedDate = DateTime.now();
  late final TripService tripService;

  @override
  void initState() {
    super.initState();
    tripService = TripService(auth: Provider.of<Auth>(context,listen: false));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
          child:Column(
            spacing: 15,
            children: [
              Column(
                  spacing: 15,
                  children: List.generate(locations.length, (index) => GestureDetector(
                    onTap: () async {
                      PlaceModel? result = await Navigator.pushNamed(context, '/searchPage') as PlaceModel?;
                      if(result!=null){
                        setState(() {
                          int currentDay = locations[index].day;
                          locations[index] = PlaceModel(
                            placeId: result.placeId,
                            placeName: result.placeName,
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
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color:
                              Theme.of(context).colorScheme.onSurface,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(index==0? "FROM" : "LOCATION $index",
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                      Text(locations[index].placeName??'',
                                      overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                      ),
                                    ],
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
                                      index>0 && locations.length>2? IconButton(
                                        onPressed: (){
                                          setState(() {
                                            locations.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.delete_outline,size: 30,)
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
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
                          locations.add(PlaceModel(
                            placeId: result.placeId,
                            placeName: result.placeName,
                            day: 1,
                          ));
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
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('START AT',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.people_alt_outlined,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GUESTS  ',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Theme.of(context).colorScheme.primary)
                        ),
                        //width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Text('FILTER',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Theme.of(context).colorScheme.primary)
                        ),
                        //width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.arrow_drop_down,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Text('BUDGET',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
                    onPressed: () async {
                      setState(() {
                        pendingRequest = true;
                      });
                      try{
                        var reqBody = {
                          "startLocation":locations[0].toJson(),
                          "locations":locations.map((e) => e.toJson()).toList(),
                          "startDate":selectedDate.toIso8601String(),
                          "guests":guestCount,
                        };
                        await tripService.postTrip(reqBody);
                        if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Trip Created Successfully!")));
                        setState(() {
                          pendingRequest = false;
                        });
                        if(context.mounted) Navigator.pushNamed(context, '/myTripsPage');
                      } catch(e){
                        setState(() {
                          pendingRequest = false;
                        });
                        if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent, content: Text('${e.toString()}. Try Again!')));
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                    ),
                    child: pendingRequest? SizedBox(height: 30, width : 30,child: CircularProgressIndicator(color: Colors.white,)) : Text('CREATE TRIP',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),)
                ),
              ),
            ],
          )
      ),
    );
  }
}