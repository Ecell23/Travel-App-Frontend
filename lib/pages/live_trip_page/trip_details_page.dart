import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/config/constants.dart';
import 'package:travel_app/models/place_model.dart';
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/pages/attractions_page/attractions_page.dart';
import 'package:travel_app/pages/live_trip_page/widgets/safety_board_widget.dart';
import 'package:travel_app/providers/auth_provider.dart';
import 'package:travel_app/services/trip_services.dart';
import 'package:travel_app/pages/bookings_page/bookings_page.dart';

class TripDetailsPage extends StatefulWidget {
  final Trip trip;
  
  const TripDetailsPage({
    super.key, 
    required this.trip,
  });

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  late List<PlaceModel> _places;
  late TripService tripService;

  @override
  void initState() {
    super.initState();
    _places = widget.trip.locations;
    tripService = TripService(auth: Provider.of<Auth>(context, listen: false));
  }

  Future<void> _refreshTrip() async {
    try{
      final trip = await tripService.getTrip(widget.trip.id);
      setState(() {
        _places = trip.locations;
      });
    } catch(e){
      if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );}
    } 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Trip to ${_places[1].placeName}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          Tooltip(
            message: 'Number of guests',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people, 
                    color: theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.trip.guests}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Locations",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildLocationsList(),
            const SizedBox(height: 24),
            Text(
              "Safety Board",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            const SafetyBoardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationsList() {
    int cumulativeDays = 0;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index];
        final isStartLocation = index == 0;

        // Calculate arrival day number and date
        final arrivalDay = cumulativeDays + 1;
        final arrivalDate = widget.trip.startDate.add(Duration(days: cumulativeDays));
        final departureDay = arrivalDay + place.day - 1;

        // Prepare for next iteration
        cumulativeDays += place.day;

        return _LocationCard(
          place: place,
          isStartLocation: isStartLocation,
          arrivalDay: arrivalDay,
          departureDay: departureDay,
          arrivalDate: arrivalDate,
          onHotelsTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingPage(
                  prefillLocation: place.placeName,
                  prefillStartDate: arrivalDate,
                  prefillEndDate: arrivalDate.add(Duration(days: place.day - 1)),
                  prefillAdults: widget.trip.guests,
                ),
              ),
            );
          },
          onAttractionsTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyAttractionsPage(
              place: place,
              apiKey: Constants.googlePlacesApiKey,
              tripId: widget.trip.id,
              locationIndex: index,
            ))).then((value) {
              _refreshTrip();
            });
          },
        );
      },
    );
  }
}

class _LocationCard extends StatefulWidget {
  final PlaceModel place;
  final bool isStartLocation;
  final int arrivalDay;
  final int departureDay;
  final DateTime arrivalDate;
  final VoidCallback onHotelsTap;
  final VoidCallback onAttractionsTap;

  const _LocationCard({
    required this.place,
    required this.isStartLocation,
    required this.arrivalDay,
    required this.departureDay,
    required this.arrivalDate,
    required this.onHotelsTap,
    required this.onAttractionsTap,
  });

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final datezformat = DateFormat('d MMM yyyy');
    String dayRangeText;
    if (widget.isStartLocation) {
      dayRangeText = 'Start Date: ${datezformat.format(widget.arrivalDate)}';
    } else if (widget.arrivalDay == widget.departureDay) {
      dayRangeText = 'Day ${widget.arrivalDay}: ${datezformat.format(widget.arrivalDate)}';
    } else {
      dayRangeText = 'Day ${widget.arrivalDay}-${widget.departureDay}: ${datezformat.format(widget.arrivalDate)}';
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Location Header
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            title: Text(
              dayRangeText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            
            subtitle: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              widget.place.placeName,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                overflow: TextOverflow.ellipsis,
              ),
            ),
                      if (!widget.isStartLocation)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Bookmarks',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Icon(
                                _isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: theme.colorScheme.primary,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
              ],
            ),
            trailing: widget.isStartLocation
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Tooltip(
                        message: 'Find Hotels',
                        child: InkWell(
                          onTap: widget.onHotelsTap,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.hotel,
                                color: theme.colorScheme.onSurface,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: 'Nearby Attractions',
                        child: GestureDetector(
                          onTap: widget.onAttractionsTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: widget.onAttractionsTap,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.attractions,
                                  color: theme.colorScheme.onSurface,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: (!widget.isStartLocation && _isExpanded)
            ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16,top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 1,
                  ),
                  SizedBox(height: 6,),
                  // Hotels Section
                  Text(
                    'Hotels',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.place.hotels == null || widget.place.hotels!.isEmpty)
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hotel_outlined,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                          Text(
                            'No hotels saved yet',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: widget.onHotelsTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search, 
                                    size: 18,
                                    color: theme.colorScheme.onSurface,
                                    ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Find Hotels',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.place.hotels!.length,
                        itemBuilder: (context, index) {
                          final hotel = widget.place.hotels![index];
                          return _HotelCard(hotel: hotel);
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  // Attractions Section
                  Text(
                    'Attractions',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.place.attractions == null || widget.place.attractions!.isEmpty)
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attractions_outlined,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No attractions saved yet',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: widget.onAttractionsTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search, 
                                    size: 18,
                                    color: theme.colorScheme.onSurface,
                                    ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Find Attractions',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                     
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.place.attractions!.length,
                        itemBuilder: (context, index) {
                          final attraction = widget.place.attractions![index];
                          return _AttractionCard(attraction: attraction);
                        },
                      ),
                    ),
                ],
              ),
            ):SizedBox(),
          ),
        ],
      ),
    );
  }
  
}

class _HotelCard extends StatelessWidget {
  final HotelModel hotel;

  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              hotel.imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Hotel Details
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      ' ${hotel.rating}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${hotel.price.toInt()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  final AttractionModel attraction;

  const _AttractionCard({required this.attraction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attraction Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${attraction.image}&key=${Constants.googlePlacesApiKey}',
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.bookmark,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          // Attraction Details
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      attraction.type.replaceAll('_', ' '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      ' ${attraction.rating}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 