import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  List<String> locations = [ 'Gangtok','Shimla'];
  int guestCount = 1;
  DateTime selectedDate = DateTime.now();
  TripService tripService = TripService();

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
                      String? result = await Navigator.pushNamed(context, '/searchPage') as String?;
                      if(result!=null){
                        setState(() {
                          locations[index] = result;
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
                                      Text(locations[index],
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                      ),
                                    ],
                                  ),
                                  index>0 && locations.length>2? IconButton(onPressed: (){
                                    setState(() {
                                      locations.removeAt(index);
                                    });
                                  },
                                      icon: Icon(Icons.delete_outline,size: 30,)
                                  ) : SizedBox(),
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
                      String? result = await Navigator.pushNamed(context, '/searchPage') as String?;
                      if(result!=null){
                        setState(() {
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
                        String token = Provider.of<Auth>(context,listen: false).token??'';
                        var reqBody = {
                          "startLocation":locations[0],
                          "locations":locations,
                          "startDate":selectedDate.toIso8601String(),
                          "guests":guestCount
                        };
                        await tripService.postTrip(token,reqBody);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Trip Created Successfully!")));
                        setState(() {
                          pendingRequest = false;
                        });
                        Navigator.pushNamed(context, '/myTripsPage');
                      } catch(e){
                        setState(() {
                          pendingRequest = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent, content: Text('${e.toString()}. Try Again!')));
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