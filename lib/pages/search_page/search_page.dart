import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'dart:async';

import 'package:travel_app/models/place_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;
  late GooglePlace googlePlace;
  final String apiKey = 'AIzaSyBYT-fkNAw0IKd2dRwOhKompwSMNqUJBrM';

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(apiKey);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (searchController.text.isEmpty) {
        setState(() {
          predictions = [];
        });
      } else {
        _autocompleteSearch(searchController.text);
      }
    });
  }

  Future<void> _autocompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value,types: '(regions)');
    if (result != null && result.predictions != null) {
      print(result.status);
      setState(() {
        predictions = result.predictions!;
      });
    } else {
      print(result?.toString());
      setState(() {
        predictions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary
            )
          ),
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        )],
      ),
      body: searchController.text.isEmpty
          ? Center(child: Text('Search where you want to go', style: TextStyle(fontSize: 16, color: Colors.grey)))
          : predictions.isEmpty
              ? Center(child: Text('No results found', style: TextStyle(fontSize: 16, color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemCount: predictions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final prediction = predictions[index];
                    return ListTile(
                      shape: Border(top: BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
                      title: Text(prediction.description ?? ''),
                      onTap: () {
                        print(prediction.placeId);
                        Navigator.pop(context, PlaceModel(
                          placeId: prediction.placeId!,
                          placeName: prediction.description!,
                          day: 1,
                        ));
                      },
                    );
                  },
                ),
    );
  }
}
