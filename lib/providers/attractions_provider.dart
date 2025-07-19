import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:travel_app/services/trip_services.dart';
import '../config/constants.dart';
import '../models/place_model.dart';

class AttractionsProvider extends ChangeNotifier {
  final PlaceModel place;
  final String? apiKey;
  late GooglePlace _googlePlace;
  final TripService tripService ;
  final String tripId;
  final int locationIndex;

  List<SearchResult>? _attractions;
  bool _loading = true;
  String? _error;
  Set<String> _savedAttractions = {};
  final Map<String, List<String>> _attractionImages = {};
  final Map<String, bool> _loadingAdditionalImages = {};
  final Map<String, List<String>?> _attractionOpeningHours = {};

  List<SearchResult>? get attractions => _attractions;
  bool get loading => _loading;
  String? get error => _error;

  AttractionsProvider({
    required this.place, 
    this.apiKey,
    required this.tripService,
    required this.tripId,
    required this.locationIndex
    }) {

    _googlePlace = GooglePlace(apiKey ?? Constants.googlePlacesApiKey);
    _savedAttractions = place.attractions?.map((a) => a.placeId).toSet() ?? {};
    fetchNearbyAttractions();
  }

  void fetchNearbyAttractions({String? query}) async {
    if (place.latitude == null || place.longitude == null) {
      _loading = false;
      _error = "Location coordinates not available.";
      notifyListeners();
      return;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _googlePlace.search.getNearBySearch(
        Location(lat: place.latitude!, lng: place.longitude!),
        50000,
        type: "tourist_attraction",
        keyword: (query != null && query.isNotEmpty) ? query : null,
      );
      _attractions = response?.results;
      _loading = false;
      _error = null;
      notifyListeners();
      // Initialize image maps for each attraction
      if (_attractions != null) {
        for (var attraction in _attractions!) {
          if (attraction.placeId != null) {
            _loadingAdditionalImages[attraction.placeId!] = true;
            // Initialize with the first photo if available
            if (attraction.photos != null && attraction.photos!.isNotEmpty) {
              _attractionImages[attraction.placeId!] = [
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${attraction.photos![0].photoReference}&key=${apiKey ?? Constants.googlePlacesApiKey}'
              ];
            } else {
              _attractionImages[attraction.placeId!] = ['https://via.placeholder.com/400x200?text=No+Image'];
            }
            _fetchAdditionalImages(attraction.placeId!);
          }
        }
      }
    } catch (e) {
      _loading = false;
      _error = "Failed to fetch attractions.";
      notifyListeners();
    }
  }

  void _fetchAdditionalImages(String placeId) async {
    try {
      final details = await _googlePlace.details.get(placeId);
      if (details != null && details.result != null) {
        // Get photos
        if (details.result!.photos != null) {
          final photos = details.result!.photos!;
          final photoUrls = photos.take(5).map((photo) =>
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo.photoReference}&key=${apiKey ?? Constants.googlePlacesApiKey}'
          ).toList();
          _attractionImages[placeId] = photoUrls;
        }
        // Get opening hours
        if (details.result!.openingHours != null &&
            details.result!.openingHours!.weekdayText != null) {
          _attractionOpeningHours[placeId] = details.result!.openingHours!.weekdayText;
        }
        _loadingAdditionalImages[placeId] = false;
        notifyListeners();
      } else {
        _loadingAdditionalImages[placeId] = false;
        notifyListeners();
      }
    } catch (e) {
      _loadingAdditionalImages[placeId] = false;
      notifyListeners();
    }
  }

  void toggleSaveAttraction(
    AttractionModel attraction,
    BuildContext context,
    ) async {
    try{
      String msg = await tripService.addRemoveAttractionToTrip(tripId, attraction, locationIndex);
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green,
        ),
      );
      }
    } catch(e){
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
        );
      }
      return;
    }

    if (_savedAttractions.contains(attraction.placeId)) {
      _savedAttractions.remove(attraction.placeId);
    } else {
      _savedAttractions.add(attraction.placeId);
    }
    notifyListeners();
    // TODO: Call API to persist saved attractions if needed
  }

  bool isAttractionSaved(String? attractionId) {
    if (attractionId == null) return false;
    return _savedAttractions.contains(attractionId);
  }

  List<String> getAttractionImages(String? attractionId) {
    if (attractionId == null) return ['https://via.placeholder.com/400x200?text=No+Image'];
    return _attractionImages[attractionId] ?? ['https://via.placeholder.com/400x200?text=No+Image'];
  }

  bool isLoadingAdditionalImages(String? attractionId) {
    if (attractionId == null) return false;
    return _loadingAdditionalImages[attractionId] ?? false;
  }

  List<String>? getAttractionOpeningHours(String? attractionId) {
    if (attractionId == null) return null;
    return _attractionOpeningHours[attractionId];
  }
} 