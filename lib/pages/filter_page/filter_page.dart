import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _budget = 1000;
  final List<String> ratings = ["Very Good (4+)", "Average (3+)"];
  final List<String> otherRatings = [
    "Free Cancellation",
    "Room Service",
    "Restaurant Service",
    "Kitchen",
    "Air Conditioning",
    "Balcony"
  ];
  final List<String> propertyTypes = [
    "Hotel",
    "Villa",
    "Homestay",
    "Resort",
    "Guesthouse",
    "Lodge"
  ];

  Map<String, bool> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    for (var filter in [...ratings, ...otherRatings, ...propertyTypes]) {
      selectedFilters[filter] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8ECF4),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter By", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Budget", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 10),
                      Text("Rs10 - Rs${_budget.toInt()}",
                          style: TextStyle(color: Colors.orange, fontSize: 14)),
                      Slider(
                        value: _budget,
                        min: 10,
                        max: 1000,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey[300],
                        onChanged: (value) {
                          setState(() {
                            _budget = value;
                          });
                        },
                      ),
                      _buildSection("Ratings", ratings),
                      _buildSection("Other Ratings", otherRatings),
                      _buildSection("Property Type", propertyTypes),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                          ),
                          onPressed: () {},
                          child: Text("SEARCH BY FILTERS", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2, // Keep 2 columns
          childAspectRatio: 3, // Increase row height for multiline text
          crossAxisSpacing: 10, // Add spacing between items
          mainAxisSpacing: 10, // Add vertical spacing
          children: options.map((option) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding for better spacing
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text at the top
                children: [
                  Checkbox(
                    value: selectedFilters[option],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedFilters[option] = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(fontSize: 14),
                      maxLines: 2, // Allow multi-line text
                      overflow: TextOverflow.visible, // Ensure text is fully displayed
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
