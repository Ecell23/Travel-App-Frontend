import 'package:flutter/material.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<String> locations = ['Delhi', 'Shillong', 'Goa','hydrabad','Silchar','Kohima','Darjeeling','Puri'];
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: locations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              shape: Border(top: BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
              title: Text(locations[index]),
              onTap: (){
                Navigator.pop(context,locations[index]);
              },
            );
          }
      ),
    );
  }
}
