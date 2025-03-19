import 'package:flutter/material.dart';

class Hotel {
  final String name;
  final String location;
  final String imageUrl;
  final double price;
  final List<String> amenities;

  Hotel({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.amenities,
  });
}

List<Hotel> hotels = [
  Hotel(
    name: "ABC Hotel",
    location: "Street 14, ABC Nagar, Shimla",
    imageUrl: "https://images.unsplash.com/photo-1561501900-3701fa6a0864?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Replace with actual image URL
    price: 500,
    amenities: ["2 Beds", "4 Guests", "Room Service"],
  ),
  Hotel(
    name: "XYZ Hotel",
    location: "MG Road, Manali",
    imageUrl: "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    price: 450,
    amenities: ["1 Bed", "2 Guests", "Free Breakfast"],
  ),
];

Widget buildHotelCard(Hotel hotel) {
  return Container(
    width: double.infinity, // Ensures it doesn't exceed parent width
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              hotel.imageUrl,
              height: 180,
              width: double.infinity, // Ensures image fits inside the card
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  hotel.location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: -4, // Adjust spacing for better fit
                        children: hotel.amenities
                            .map((amenity) => Chip(
                          label: Text(amenity),
                          backgroundColor: Colors.grey[200],
                        ))
                            .toList(),
                      ),
                    ),
                    Text(
                      "\$${hotel.price}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class HotelListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hotels")),
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: hotels.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 8), // Consistent spacing
          child: buildHotelCard(hotels[index]),
        ),
      ),
    );
  }
}
