
import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import 'widgets/trip_form.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<List<dynamic>> services = [[Icons.hotel, 'Hotels'],[Icons.flight , 'Flights'],[Icons.train_outlined,'Trains'],[Icons.car_rental_outlined,'Cars']];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 35,
            child: Image.asset('assets/images/planit-high-resolution-logo-transparent.png')
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(15.0),
          child: IconButton(
            icon: Icon(Icons.notifications_none_rounded,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {},
          ),
        )],
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0,vertical: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip Details',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              TripForm(),
              SizedBox(height: 5,),
              Text(
                'Services',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              Row(
                spacing: 15,
                children: List.generate(4, (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12)
                      ),
                      //width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                        child: Column(
                          spacing: 5,
                          children: [
                            Icon(services[index][0],
                              color:
                              Theme.of(context).colorScheme.onSurface,),
                            Text(services[index][1],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentindex: 0,),
    );
  }
}