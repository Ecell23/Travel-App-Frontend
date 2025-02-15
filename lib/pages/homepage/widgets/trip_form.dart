import 'package:flutter/material.dart';

class TripForm extends StatelessWidget {
  const TripForm({
    super.key,
    required this.locations,
  });

  final List<List<String>> locations;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 7,
          ),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
          child:Column(
            spacing: 15,
            children: [
              Column(
                  spacing: 15,
                  children: List.generate(locations.length, (index) => GestureDetector(
                    onTap: (){},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12)
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color:
                              Theme.of(context).colorScheme.onSurface,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locations[index][0],
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                ),
                                Text(locations[index][1],
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),)
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                    ),
                    child: Text('ADD LOCATION',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),)
                ),
              ),
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12)
                        ),
                        //width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('START AT',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  Text('20 July',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12)
                        ),
                        //width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.people_alt_outlined,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GUESTS  ',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  Text('1',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Theme.of(context).colorScheme.primary)
                        ),
                        //width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Text('FILTER',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Theme.of(context).colorScheme.primary)
                        ),
                        //width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.arrow_drop_down,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              Text('BUDGET',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              )
                            ],
                          ),

                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                    ),
                    child: Text('CREATE TRIP',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),)
                ),
              ),
            ],
          )
      ),
    );
  }
}