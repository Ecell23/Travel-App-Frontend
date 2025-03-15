import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:travel_app/pages/bookings_page/widgets/hotel_card.dart';
import 'package:travel_app/widgets/bottom_nav.dart'; // Import Bottom Navigation Bar

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

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) return 'Select Date';
    DateFormat format = DateFormat("d MMM"); // Format like '10 Mar'
    return "${format.format(range.start)} - ${format.format(range.end)}";
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
                        .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                        .toList(),
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
                        .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                        .toList(),
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
                .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                .toList(),
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
      body: SingleChildScrollView( // Ensures entire page is scrollable
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
              Column(
                children: hotels.map((hotel) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: buildHotelCard(hotel),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentindex: 3), // Added Bottom Navigation Bar
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Hotel', 'Flight', 'Train', 'Car'].map((text) {
        bool isSelected = selectedCategory == text;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = text;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? Color.fromRGBO(24, 192, 193, 0.4) : Colors.white,
              border: Border.all(
                color: isSelected ? Color.fromRGBO(24, 192, 193, 0.7) : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(50), // More circular shape
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black54 : Colors.black54,
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
              _buildFilterButton(Icons.location_on, 'Shimla', onTap: () {}),
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
              Text(text, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
