
import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import 'widgets/trip_form.dart';
import 'widgets/popular_carousel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 30,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Image.asset('assets/images/planit-high-resolution-logo-transparent.png'),
            )
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
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
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
                'Popular Destinations',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(height: 10),
              PopularDestinationsCarousel(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentindex: 0,),
    );
  }
}