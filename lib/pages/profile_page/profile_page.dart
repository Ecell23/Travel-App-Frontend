import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Profile', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 255, 98, 0).withOpacity(0.4),
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/profile.jpg'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('David Gill', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
                    Text('davidgill1@gmail.com',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('+91-9999999999',
                        style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      ),
                      onPressed: () {},
                      child: Text("EDIT PROFILE",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.add_box_outlined),
                        title: Text("Safety Settings"),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.language),
                        title: Text("Languages"),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                      Divider(),
                      SwitchListTile(
                        secondary: Icon(Icons.dark_mode_outlined),
                        title: Text("Dark Mode"),
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text("Logout", style: TextStyle(color: Colors.red)),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentindex: 4),
    );
  }
}