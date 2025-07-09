import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:travel_app/config/constants.dart';
import 'package:travel_app/models/place_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String apiKey = Constants.googlePlacesApiKey;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Places',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: _textController,
              googleAPIKey: apiKey,
              inputDecoration: InputDecoration(
                hintText: "Search places...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              debounceTime: 400,
              countries: const ["in"], // Add your country codes here
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                print(prediction.lat);
                Navigator.pop(
                  context,
                  PlaceModel(
                    placeId: prediction.placeId ?? '',
                    placeName: prediction.description ?? '',
                    day: 1,
                    latitude: double.tryParse(prediction.lat ?? ''),
                    longitude: double.tryParse(prediction.lng ?? ''),
                  ),
                );
              },
              itemClick: (Prediction prediction) {},
              seperatedBuilder: Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
              itemBuilder: (context, index, Prediction prediction) {
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(prediction.description ?? ''),
                );
              },
              isCrossBtnShown: true,
            ),
          ],
        ),
      ),
    );
  }
}
