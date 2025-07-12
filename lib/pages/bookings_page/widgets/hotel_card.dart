import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Hotel {
  final String name;
  final String location;
  final String imageUrl;
  final double price;
  final List<String> amenities;
  final String? bookingUrl;

  Hotel({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.amenities,
    this.bookingUrl,
  });
}

Widget buildHotelCard(Hotel hotel) {
  return Container(
    width: double.infinity,
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
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey,
                child: Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotel.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(hotel.location, style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: -4,
                        children: hotel.amenities.map((amenity) => Chip(
                          label: Text(amenity),
                          backgroundColor: Colors.grey[200],
                        )).toList(),
                      ),
                    ),
                    Text(
                      "₹${hotel.price.toStringAsFixed(0)}",
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

          // ✅ Booking button only if URL is available
          if (hotel.bookingUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.open_in_new),
                  label: Text("View on Tripadvisor"),
                  onPressed: () async {
                    final url = Uri.parse(hotel.bookingUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint("Could not launch URL");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}