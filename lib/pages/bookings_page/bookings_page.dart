import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel_app/pages/bookings_page/widgets/hotel_card.dart';
import 'package:travel_app/widgets/bottom_nav.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedCategory = 'Hotel';
  int adults = 2;
  int children = 0;
  int rooms = 1;
  DateTimeRange? selectedDate;

  final TextEditingController cityController = TextEditingController(text: 'New York City'); // default value

  List<Hotel> fetchedHotels = [];
  bool isLoading = false;
  String? errorMsg;

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) return 'Select Date';
    DateFormat format = DateFormat("d MMM");
    return "${format.format(range.start)} - ${format.format(range.end)}";
  }

  Future<void> fetchHotels(String city, String checkIn, String checkOut) async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    final url = Uri.parse('http://192.168.1.7:3000/api/hotels/searchByCity?city=$city&checkIn=$checkIn&checkOut=$checkOut');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> hotelList = data['hotels']['data']['data'] ?? [];

        setState(() {
          fetchedHotels = hotelList.map((h) {
            final rawName = h['title'] ?? 'Unnamed Hotel';
            final cleanedName = rawName.replaceFirst(RegExp(r'^\d+\.\s*'), '');
            final template = h['cardPhotos']?[0]?['sizes']?['urlTemplate'];
            final imageUrl = template != null
                ? template
                .replaceAll('{width}', '600')
                .replaceAll('{height}', '400')
                : 'https://via.placeholder.com/600x400?text=No+Image';

            return Hotel(
             name: cleanedName,

            location: h['secondaryInfo'] ?? 'Unknown location',
              imageUrl: imageUrl,
              price: double.tryParse(
                  h['priceForDisplay']?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0') ??
                  0,
              amenities: [
                h['bubbleRating']?['rating'] != null
                    ? "${h['bubbleRating']['rating']}⭐"
                    : "Rating N/A",
                "${h['bubbleRating']?['count'] ?? 0} Reviews"
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
    if (cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a city")));
      return;
    }

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      await fetchHotels(
        cityController.text.trim(),
        DateFormat('yyyy-MM-dd').format(picked.start),
        DateFormat('yyyy-MM-dd').format(picked.end),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Bookings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryButtons(),
              SizedBox(height: 20),
              Text("Filter By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildFilterSection(),
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
      bottomNavigationBar: BottomNav(currentindex: 3),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Hotel', 'Flight', 'Train', 'Car'].map((text) {
        bool isSelected = selectedCategory == text;
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = text),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? Color.fromRGBO(24, 192, 193, 0.4) : Colors.white,
              border: Border.all(
                color: isSelected ? Color.fromRGBO(24, 192, 193, 0.7) : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
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
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter city',
                          ),
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
