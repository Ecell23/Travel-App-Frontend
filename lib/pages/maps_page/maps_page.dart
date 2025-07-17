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
  GoogleMapController? mapController;
  final apiKey = 'AIzaSyBYT-fkNAw0IKd2dRwOhKompwSMNqUJBrM';
  late GooglePlace googlePlace;
  Set<Marker> _markers = {};
  Position? _currentPosition;
  final double _mapHeight = 0.50;
  bool _isLoading = true;
  String? _selectedCategory;
  bool _disposed = false;
  TextEditingController _searchController = TextEditingController();
  List<AutocompletePrediction> _predictions = [];
  FocusNode _searchFocus = FocusNode();
  bool _isSearchOpen = false;
  double _searchBarWidth = 0;



  // Default position for Delhi, India if location is unavailable
  final LatLng _defaultPosition = LatLng(28.6139, 77.2090);

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(apiKey);
    _determinePosition();
  }

  @override
  void dispose() {
    _disposed = true;
    mapController?.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) async {
    if (value.isEmpty) {
      _safeSetState(() => _predictions = []);
      return;
    }

    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      _safeSetState(() {
        _predictions = result.predictions!;
      });
    }
  }

  Future<void> _selectPrediction(AutocompletePrediction prediction) async {
    final details = await googlePlace.details.get(prediction.placeId!);
    if (details != null && details.result != null && details.result!.geometry?.location != null) {
      final loc = details.result!.geometry!.location!;
      final LatLng position = LatLng(loc.lat!, loc.lng!);

      mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 15));

      final marker = Marker(
        markerId: MarkerId(prediction.placeId!),
        position: position,
        infoWindow: InfoWindow(title: details.result!.name),
      );

      _safeSetState(() {
        _markers.add(marker);
        _predictions = [];
        _searchController.clear();
        _searchFocus.unfocus();
      });
    }
  }


  // Safe setState that checks if the widget is still mounted
  void _safeSetState(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // If permission is denied forever, exit loading state
        _safeSetState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
            .timeout(const Duration(seconds: 5));
        
        _safeSetState(() {
          _currentPosition = position;
          _isLoading = false;
        });
        
        // Move camera to current position if map is already created
        if (mapController != null && _currentPosition != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            ),
          );
        }
      } catch (e) {
        print("Error getting position: $e");
        _safeSetState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error in determine position: $e");
      _safeSetState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  Future<void> searchNearby(String category) async {
    if (_currentPosition == null || !mounted) return;

    String placeType = _getPlaceType(category);
    _safeSetState(() {
      _selectedCategory = category;
      _markers.clear();
    });

    try {
      var result = await googlePlace.search.getNearBySearch(
        Location(lat: _currentPosition!.latitude, lng: _currentPosition!.longitude),
        5000,
        type: placeType,
      );

      if (!mounted || _disposed) return;
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

      _safeSetState(() {
        _markers = markers.toSet();
      });
    } catch (e) {
      print("Error searching nearby places: $e");
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps', style: Theme.of(context).textTheme.titleLarge),
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
                          : _defaultPosition,
                      zoom: 12.0,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _isSearchOpen ? MediaQuery.of(context).size.width - 84 : 50,
                    height: 50,
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(_isSearchOpen ? Icons.arrow_back : Icons.search),
                          onPressed: () {
                            setState(() {
                              if (_isSearchOpen) {
                                _searchController.clear();
                                _predictions.clear();
                                _searchFocus.unfocus();
                              }
                              _isSearchOpen = !_isSearchOpen;
                              if (_isSearchOpen) {
                                Future.delayed(Duration(milliseconds: 300), () {
                                  _searchFocus.requestFocus();
                                });
                              }
                            });
                          },
                        ),
                        if (_isSearchOpen)
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocus,
                              onChanged: _onSearchChanged,
                              decoration: InputDecoration(
                                hintText: 'Search place...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_isSearchOpen && _predictions.isNotEmpty)
                  Positioned(
                    top: 65,
                    left: 12,
                    right: 12,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _predictions.length,
                        itemBuilder: (context, index) {
                          final prediction = _predictions[index];
                          return ListTile(
                            title: Text(prediction.description ?? ''),
                            onTap: () {
                              _selectPrediction(prediction);
                              setState(() {
                                _isSearchOpen = false;
                              });
                            },
                          );
                        },
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
                      if (_currentPosition != null && mapController != null) {
                        mapController!.animateCamera(
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
    );
  }
}

class TimeoutException implements Exception {
  String toString() => 'The operation timed out.';
}
