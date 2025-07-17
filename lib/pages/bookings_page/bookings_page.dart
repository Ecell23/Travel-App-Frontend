import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel_app/pages/bookings_page/widgets/hotel_card.dart';
import 'package:travel_app/widgets/bottom_nav.dart';
import 'package:travel_app/secrets.dart'; // Add your TripAdvisor API key here

class BookingPage extends StatefulWidget {
  final String? prefillLocation;
  final DateTime? prefillStartDate;
  final DateTime? prefillEndDate;
  final int? prefillAdults;

  const BookingPage({
    Key? key,
    this.prefillLocation,
    this.prefillStartDate,
    this.prefillEndDate,
    this.prefillAdults,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}



class _BookingPageState extends State<BookingPage> {
  String selectedCategory = 'Hotel';
  int adults = 2;
  int children = 0;
  int rooms = 1;
  DateTimeRange? selectedDate;
  late FocusNode locationFocusNode;


  final TextEditingController cityController = TextEditingController();

  List<Hotel> fetchedHotels = [];
  bool isLoading = false;
  String? errorMsg;

  String? selectedGeoId;
  List<Map<String, String>> locationResults = [];
  bool isLocationTyping = false;

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) return 'Select Date';
    DateFormat format = DateFormat("d MMM");
    return "${format.format(range.start)} - ${format.format(range.end)}";
  }

  @override
  void initState() {
    super.initState();
    locationFocusNode = FocusNode();

    if (widget.prefillLocation != null) {
      cityController.text = widget.prefillLocation!;
    }

    if (widget.prefillStartDate != null && widget.prefillEndDate != null) {
      selectedDate = DateTimeRange(start: widget.prefillStartDate!, end: widget.prefillEndDate!);
    }

    if (widget.prefillAdults != null) {
      adults = widget.prefillAdults!;
    }

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        setState(() {
          isLocationTyping = false;
          locationResults = [];
        });
      }
    });
  }


  Future<void> fetchHotelsWithGeoId(String geoId, String checkIn, String checkOut) async {
    setState(() {
      isLoading = true;
      errorMsg = null;
      fetchedHotels = [];
    });

    final url = Uri.parse(
        'https://travel-app-premansh.fly.dev/api/hotels/searchByGeoId?geoId=$geoId&checkIn=$checkIn&checkOut=$checkOut');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> hotelList = data['hotels']?['data']?['hotels'] ?? [];

        setState(() {
          fetchedHotels = hotelList.map((h) {
            final rawName = h['cardTitle']?['string'] ?? 'Unnamed Hotel';
            final cleanedName = rawName.replaceFirst(RegExp(r'^\d+\.\s*'), '');

            final priceString = h['commerceInfo']?['priceForDisplay']?['string'] ?? '';
            final usdPrice = double.tryParse(priceString.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            final inrPrice = usdPrice * 83;

            final template = h['cardPhotos']?[0]?['sizes']?['urlTemplate'];
            final imageUrl = template != null
                ? template.replaceAll('{width}', '600').replaceAll('{height}', '400')
                : 'https://via.placeholder.com/600x400?text=No+Image';

            return Hotel(
              name: cleanedName,
              location: '', // fallback if no location available
              imageUrl: imageUrl,
              price: inrPrice,
              amenities: [
                h['bubbleRating']?['rating'] != null
                    ? "${h['bubbleRating']['rating']}⭐"
                    : "Rating N/A",
                h['bubbleRating']?['numberReviews']?['string'] ?? "0 Reviews"
              ],
            );
          }).toList();
        });
      } else {
        setState(() => errorMsg = "Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => errorMsg = "Error fetching hotels: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showTravelerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Travelers"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Adults"),
                  DropdownButton<int>(
                    value: adults,
                    items: List.generate(6, (index) => index + 1)
                        .map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                    onChanged: (value) {
                      setState(() => adults = value!);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Children"),
                  DropdownButton<int>(
                    value: children,
                    items: List.generate(6, (index) => index)
                        .map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                    onChanged: (value) {
                      setState(() => children = value!);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _selectRooms() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Rooms"),
          content: DropdownButton<int>(
            value: rooms,
            items: List.generate(5, (index) => index + 1)
                .map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
            onChanged: (value) {
              setState(() => rooms = value!);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.black54),
                      SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          focusNode: locationFocusNode,
                          onChanged: _onLocationInputChanged,
                          decoration: InputDecoration.collapsed(hintText: 'Enter location'),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildFilterButton(Icons.people, '$adults Adults, $children Children', onTap: _showTravelerDialog),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFilterButton(Icons.calendar_today, _formatDateRange(selectedDate), onTap: _selectDateRange),
              _buildFilterButton(Icons.hotel, '$rooms Room', onTap: _selectRooms),
            ],
          ),
        ],
      ),
    );
  }

  void _onLocationInputChanged(String input) async {
    if (!locationFocusNode.hasFocus || input.trim().isEmpty) {
      setState(() {
        isLocationTyping = false;
        locationResults = [];
      });
      return;
    }

    setState(() {
      isLocationTyping = true;
      selectedGeoId = null;
    });

    final response = await http.get(
      Uri.parse(
        'https://api.content.tripadvisor.com/api/v1/location/search?key=$tripadvisorApiKey&searchQuery=${Uri.encodeComponent(input)}&category=geos&language=en',
      ),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'] ?? [];

      setState(() {
        locationResults = results
            .map<Map<String, String>>((item) {
          final name = item['name'] ?? '';
          final address = item['address_obj']?['address_string'] ?? '';
          final cleanedAddress = (address.toLowerCase().startsWith(name.toLowerCase()))
              ? address.substring(name.length).trim().replaceFirst(RegExp(r'^,?\s*'), '')
              : address;
          final displayName = cleanedAddress.isNotEmpty ? "$name, $cleanedAddress" : name;
          return {
            'location_string': displayName,
            'location_id': item['location_id']?.toString() ?? '',
          };
        })
            .take(3)
            .toList();
      });
    } else {
      setState(() => locationResults = []);
    }
  }


  void _onSearchPressed() async {
    if (selectedGeoId == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete location and date selection")),
      );
      return;
    }

    await fetchHotelsWithGeoId(
      selectedGeoId!,
      DateFormat('yyyy-MM-dd').format(selectedDate!.start),
      DateFormat('yyyy-MM-dd').format(selectedDate!.end),
    );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Bookings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    body: GestureDetector(
    behavior: HitTestBehavior.opaque, // Makes sure taps are detected even on empty space
    onTap: () {
    FocusScope.of(context).unfocus(); // This will trigger the FocusNode listener
    },
    child: Stack(
    children: [
    SingleChildScrollView(
    child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Filter By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildFilterSection(),
                  SizedBox(height: 12),
                  Center(
                    child: ElevatedButton.icon(
                        icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                      label: Text('Search Hotels'),
                      onPressed: _onSearchPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Hotels", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (errorMsg != null)
                    Center(child: Text(errorMsg!))
                  else if (fetchedHotels.isEmpty)
                      Center(child: Text("No hotels found"))
                    else
                      Column(
                        children: fetchedHotels.map((hotel) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: buildHotelCard(hotel),
                        )).toList(),
                      ),
                ],
              ),
            ),
          ),

          // 👇 Location suggestions overlay
          if (isLocationTyping && locationResults.isNotEmpty)
            Positioned(
              top: 165, // Adjust depending on layout
              left: 20,
              right: 100,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 130),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: locationResults.length,
                    itemBuilder: (context, index) {
                      final result = locationResults[index];
                      return ListTile(
                        title: Text(result['location_string'] ?? '', style: TextStyle(fontSize: 14)),
                        onTap: () {
                          cityController.text = result['location_string']!;
                          setState(() {
                            selectedGeoId = result['location_id'];
                            isLocationTyping = false;
                            locationResults.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
      bottomNavigationBar: BottomNav(currentindex: 3),
    );
  }

  @override
  void dispose() {
    locationFocusNode.dispose();
    cityController.dispose();
    super.dispose();
  }

  Widget _buildFilterButton(IconData icon, String text, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.black54),
              SizedBox(width: 6),
              Flexible(child: Text(text, style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

}
