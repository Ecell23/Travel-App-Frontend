// ignore_for_file: empty_catches, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_app/secrets.dart';
import 'package:travel_app/widgets/bottom_nav.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController;
  final apiKey = googlePlacesApi;
  late GooglePlace googlePlace;
  Set<Marker> _markers = {};
  LatLng? _userLocation; // Store the user's real location
  LatLng? _currentLocation; // Store the current map focus location
  bool _isLoading = true;
  String? _selectedCategory;
  bool _disposed = false;
  final TextEditingController _searchController = TextEditingController();
  List<AutocompletePrediction> _predictions = [];
  final FocusNode _searchFocus = FocusNode();
  bool _isSearchOpen = false;
  List<SearchResult>? _nearbyResults; // Store nearby search results for the list
  // Add a controller for the DraggableScrollableSheet
  final DraggableScrollableController _sheetController = DraggableScrollableController();


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
    _sheetController.dispose();
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

      _safeSetState(() {
        _markers.add(Marker(
          markerId: MarkerId(prediction.placeId!),
          position: position,
          infoWindow: InfoWindow(title: details.result!.name),
        ));
        _predictions = [];
        _searchController.clear();
        _searchFocus.unfocus();
      });
      // Set current location to the selected place, clear nearby results, and shrink sheet
      _setCurrentLocation(position, moveCamera: true, clearNearby: true);
    }
  }


  // Safe setState that checks if the widget is still mounted
  void _safeSetState(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  // Centralized function to set current location
  void _setCurrentLocation(LatLng newLocation, {bool moveCamera = true, bool clearNearby = false}) {
    _safeSetState(() {
      _currentLocation = newLocation;
      if (clearNearby) {
        //_nearbyResults = null;
        _selectedCategory = null;
        _markers.clear();
      }
    });
    if (_sheetController.isAttached) {
      _sheetController.animateTo(0.18, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
    Future.delayed(Duration(milliseconds: 350), () {
        _safeSetState(() {
          _nearbyResults = null;
        }); 
    });
    if (moveCamera && mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(newLocation));
    }
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _safeSetState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        Position position = await Geolocator.getCurrentPosition()
            .timeout(const Duration(seconds: 15), onTimeout: () {
              throw TimeoutException();
            });
        final LatLng userLatLng = LatLng(position.latitude, position.longitude);
        _safeSetState(() {
          _userLocation = userLatLng;
          _isLoading = false;
        });
        // Set both user and current location on first load
        _setCurrentLocation(userLatLng, moveCamera: false, clearNearby: true);
        // Move camera if map is already created
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(userLatLng),
          );
        }
      } catch (e) {
        if (e is TimeoutException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location service timed out. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _safeSetState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _safeSetState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  Future<void> searchNearby(String category) async {
    if (_currentLocation == null || !mounted) return;
    String placeType = _getPlaceType(category);
    _safeSetState(() {
      _selectedCategory = category;
      _markers.clear();
      _nearbyResults = null;
    });
    try {
      var result = await googlePlace.search.getNearBySearch(
        Location(lat: _currentLocation!.latitude, lng: _currentLocation!.longitude),
        5000,
        type: placeType,
      );
      if (!mounted || _disposed) return;
      if (result == null || result.results == null || result.results!.isEmpty) {
        // Shrink the sheet if no results
        if (_sheetController.isAttached) {
          _sheetController.animateTo(0.18, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
        }
        return;
      }
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
        _nearbyResults = result.results!;
      });
      // Expand the sheet to max height when data is loaded
      if (_sheetController.isAttached) {
        _sheetController.animateTo(0.85, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_sheetController.isAttached) {
            _sheetController.animateTo(0.85, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
          }
        });
      }
    } catch (e) {
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
      ),
      body: Stack(
        children: [
          // Map background
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation ?? _defaultPosition,
                      zoom: 12.0,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
          ),
          // Floating location button
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                if (_userLocation != null) {
                  _setCurrentLocation(_userLocation!, moveCamera: true, clearNearby: true);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ),
          // Restore floating search bar widget
          Positioned(
            top: 12,
            left: 12,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isSearchOpen ? MediaQuery.of(context).size.width - 84 : 50,
              height: 50,
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                    icon: Icon(_isSearchOpen ? Icons.arrow_back : Icons.search,color:  Theme.of(context).colorScheme.onSurface),
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
          // DraggableScrollableSheet for bottom sheet
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.18, // Smaller when no data
            minChildSize: 0.18,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color:  Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Search Nearby header (always visible)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Text('Search Nearby', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Restaurants', 'Hotels', 'Malls', 'Parks', 'Banks', 'Markets']
                            .map((category) {
                          bool isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              onPressed: () => searchNearby(category),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? Theme.of(context).colorScheme.secondaryContainer :  Theme.of(context).colorScheme.surface,
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey.withOpacity(0.2))
                                ),
                              ),
                              child: Text(category),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Attractions-style list below header
                    Expanded(
                      child: _nearbyResults == null
                          ? SizedBox.shrink() // No space when no data
                          : _nearbyResults!.isEmpty
                              ? Center(child: Text('No places found.', style: Theme.of(context).textTheme.bodyMedium))
                              : ListView.separated(
                                  controller: scrollController,
                                  padding: EdgeInsets.only(top: 12, bottom: 16),
                                  itemCount: _nearbyResults!.length,
                                  separatorBuilder: (_, __) => Container(height: 18,color:  Colors.grey.withOpacity(0.1)),
                                  itemBuilder: (context, index) {
                                    final place = _nearbyResults![index];
                                    final imageUrl = place.photos != null && place.photos!.isNotEmpty
                                        ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photos!.first.photoReference}&key=$apiKey'
                                        : 'https://via.placeholder.com/400x200?text=No+Image';
                                    return _NearbyAttractionTile(
                                      place: place,
                                      imageUrl: imageUrl,
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(currentindex: 2),
    );
  }
}

class TimeoutException implements Exception {
  @override
  String toString() => 'The operation timed out.';
}

// Add a new widget for the nearby attraction tile styled like the attractions list (no save/bookmark)
class _NearbyAttractionTile extends StatelessWidget {
  final SearchResult place;
  final String imageUrl;

  const _NearbyAttractionTile({required this.place, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel (only one image for now)
          SizedBox(
            height: 160,
            width: double.infinity,
            child: PageView(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: screenWidth,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  ),
                ),
              ],
            ),
          ),
          // Content Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - Name, Type, Address
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name ?? 'Unknown',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          place.types?.isNotEmpty == true 
                              ? _formatTypes(place.types!)
                              : 'Tourist Attraction',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (place.vicinity != null)
                          Text(
                            place.vicinity!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondary,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right Column - Rating and Hours
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (place.rating != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' ${place.rating}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      if (place.openingHours?.openNow != null)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: place.openingHours!.openNow!
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            place.openingHours!.openNow! ? 'Open Now' : 'Closed',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: place.openingHours!.openNow!
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTypes(List<String> types) {
    final formattedTypes = types.map((type) {
      return type.replaceAll('_', ' ').split(' ').map((word) {
        return word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '';
      }).join(' ');
    }).toList();
    return formattedTypes.take(2).join(' • ');
  }
}
