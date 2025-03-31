import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/pages/my_trips_page/widgets/trip_tile.dart';
import 'package:travel_app/services/trip_services.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/bottom_nav.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  List<Trip> trips = [];
  bool pendingFetch = true;
  String? fetchError ;
  TripService tripService = TripService();

  Future<void> loadTrips() async {
    setState(() {
      pendingFetch = true;
      fetchError=null;
    });
    try{
      String token = Provider.of<Auth>(context,listen: false).token??'';
      trips = await tripService.getALlTrips(token);
      setState(() {
        pendingFetch = false;
      });
    } catch(e){
      setState(() {
        pendingFetch = false;
        fetchError = e.toString();
      });
    }
  }
  @override
  void initState() {
    loadTrips();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trips', style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
      ),
      body: RefreshIndicator(onRefresh: loadTrips, child: pendingFetch? Center(child: CircularProgressIndicator())
          : fetchError!=null? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fetchError!,style: TextStyle(fontSize: 15),),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: loadTrips,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh),
                    Text('Retry')
                  ],
                ),
            )
          ],
        ),
      )
          : ListView.builder(
        itemCount: trips.length,
          itemBuilder: (context,index) => TripTile(trip: trips[index]),
      )),
      bottomNavigationBar: BottomNav(currentindex: 1,),
    );
  }
}
