import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_app/widgets/bottom_nav.dart';
import 'package:travel_app/config/theme.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  final apiKey = 'AIzaSyBYT-fkNAw0IKd2dRwOhKompwSMNqUJBrM';
  late GooglePlace googlePlace;
  Set<Marker> _markers = {};
  Position? _currentPosition;
  final double _mapHeight = 0.50;
  bool _isLoading = true;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(apiKey);
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _isLoading = false;
    });
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  Future<void> searchNearby(String category) async {
    if (_currentPosition == null) return;

    String placeType = _getPlaceType(category);
    setState(() {
      _selectedCategory = category;
      _markers.clear();
    });

    var result = await googlePlace.search.getNearBySearch(
      Location(lat: _currentPosition!.latitude, lng: _currentPosition!.longitude),
      5000,
      type: placeType,
    );

    if (result == null || result.results == null || result.results!.isEmpty) return;

    List<Marker> markers = [];
    for (var place in result.results!) {
      if (place.geometry?.location != null && place.placeId != null) {
        final marker = Marker(
          markerId: MarkerId(place.placeId!),
          position: LatLng(
            place.geometry!.location!.lat!,
            place.geometry!.location!.lng!,
          ),
          infoWindow: InfoWindow(
            title: place.name ?? 'No name',
            snippet: place.vicinity ?? 'No address',
          ),
        );
        markers.add(marker);
      }
    }

    setState(() {
      _markers = markers.toSet();
    });
  }

  String _getPlaceType(String category) {
    switch (category.toLowerCase()) {
      case 'restaurants':
        return 'restaurant';
      case 'hotels':
        return 'lodging';
      case 'parks':
        return 'park';
      case 'banks':
        return 'bank';
      case 'markets':
        return 'store';
      case 'malls':
        return 'shopping_mall';
      default:
        return 'point_of_interest';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps', style: Theme.of(context).textTheme.bodyLarge),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueGrey[800],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * _mapHeight,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition != null
                            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                            : LatLng(28.6139, 77.2090),
                        zoom: 12.0,
                      ),
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_currentPosition != null) {
                          mapController.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            ),
                          );
                        }
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Search Nearby', style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Restaurants', 'Hotels', 'Malls', 'Parks', 'Banks', 'Markets']
                              .map((category) {
                            bool isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ElevatedButton(
                                onPressed: () => searchNearby(category),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                                  foregroundColor: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(category),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('See Itinerary On Map', style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 200,
                                margin: EdgeInsets.only(left: 16, right: index == 9 ? 16 : 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNav(currentindex: 2),
      ),
    );
  }
}
