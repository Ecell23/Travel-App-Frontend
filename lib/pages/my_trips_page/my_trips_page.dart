import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/pages/my_trips_page/widgets/trip_tile.dart';
import 'package:travel_app/services/trip_services.dart';
import 'package:travel_app/widgets/empty_widget.dart';
import 'package:travel_app/widgets/error_widget.dart';

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
  late final TripService tripService;
  late final Auth auth;

  Future<void> loadTrips() async {
    setState(() {
      pendingFetch = true;
      fetchError=null;
    });
    try{
      String token = Provider.of<Auth>(context,listen: false).token??'';
      trips = await tripService.getAllTrips(token);
      if(mounted){
      setState(() {
        pendingFetch = false;
      });
      }
    } catch(e){
      if(mounted){
      setState(() {
        pendingFetch = false;
          fetchError = e.toString();
        });
      }
    }
  }
  @override
  void initState() {
    auth = Provider.of<Auth>(context,listen: false);
    tripService = TripService(auth: auth);
    loadTrips();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trips', style: Theme.of(context).textTheme.titleLarge),
        elevation: 0,
      ),
      body: RefreshIndicator(onRefresh: loadTrips, child: pendingFetch? Center(child: CircularProgressIndicator())
          : fetchError!=null? Center(
        child: ErrorDisplayWidget(errorMessage: fetchError!, onRefresh: loadTrips)
      )
          : trips.isEmpty 
          ? EmptyDisplayWidget(message: 'No trips found', onRefresh: loadTrips)
          : ListView.builder(
        itemCount: trips.length,
          itemBuilder: (context,index) => TripTile(
            trip: trips[index],
            onRefresh: loadTrips,
            auth: auth,
            ),
      )),
      bottomNavigationBar: BottomNav(currentindex: 1,),
    );
  }
}
