import 'package:flutter/material.dart';
import 'package:travel_app/models/place_model.dart';
import 'package:google_place/google_place.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/auth_provider.dart';
import 'package:travel_app/services/trip_services.dart';
import '../../providers/attractions_provider.dart';

class NearbyAttractionsPage extends StatelessWidget {
  final PlaceModel place;
  final String? apiKey;
  final String tripId;
  final int locationIndex;

  const NearbyAttractionsPage({
    super.key,
    required this.place,
    this.apiKey,  
    required this.tripId,
    required this.locationIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AttractionsProvider>(
      create: (_) => AttractionsProvider(
        place: place, 
        apiKey: apiKey,
        tripService: TripService(auth: Provider.of<Auth>(context, listen: false)),
        tripId: tripId,
        locationIndex: locationIndex,
        ),
      child: const _NearbyAttractionsView(),
    );
  }
}

class _NearbyAttractionsView extends StatefulWidget {
  const _NearbyAttractionsView({Key? key}) : super(key: key);

  @override
  State<_NearbyAttractionsView> createState() => _NearbyAttractionsViewState();
}

class _NearbyAttractionsViewState extends State<_NearbyAttractionsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttractionsProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${provider.place.placeName}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'Nearby Attractions',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 8.0, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search attractions...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      isDense: true,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          provider.fetchNearbyAttractions(query: _searchController.text.trim());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withOpacity(0.9),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(0),
                              right: Radius.circular(9),
                            ),
                          ),
                          child: const Icon(
                            Icons.search, 
                            color: Colors.white,
                            size: 20,
                            ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text(provider.error!, style: theme.textTheme.bodyMedium))
                    : provider.attractions == null || provider.attractions!.isEmpty
                        ? Center(child: Text('No attractions found.', style: theme.textTheme.bodyMedium))
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: provider.attractions!.length,
                            separatorBuilder: (_, __) => Container(
                              height: 18,
                              color: Colors.grey.shade200,
                            ),
                            itemBuilder: (context, index) {
                              final attraction = provider.attractions![index];
                              final isSaved = provider.isAttractionSaved(attraction.placeId);
                              final images = provider.getAttractionImages(attraction.placeId);
                              final isLoadingMore = provider.isLoadingAdditionalImages(attraction.placeId);
                              final openingHours = provider.getAttractionOpeningHours(attraction.placeId);
                              return _AttractionTile(
                                attraction: attraction,
                                isSaved: isSaved,
                                onSaveTap: () => provider.toggleSaveAttraction(
                                  AttractionModel(
                                    placeId: attraction.placeId ?? '',
                                    name: attraction.name ?? '',
                                    image: attraction.photos?.firstOrNull?.photoReference ?? '',
                                    rating: attraction.rating ?? 0,
                                    type: attraction.types?.firstOrNull ?? '',
                                  ), context,
                                  ),
                                imageUrls: images,
                                isLoadingMore: isLoadingMore,
                                openingHours: openingHours,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _AttractionTile extends StatefulWidget {
  final SearchResult attraction;
  final bool isSaved;
  final VoidCallback onSaveTap;
  final List<String> imageUrls;
  final bool isLoadingMore;
  final List<String>? openingHours;

  const _AttractionTile({
    required this.attraction,
    required this.isSaved,
    required this.onSaveTap,
    required this.imageUrls,
    required this.isLoadingMore,
    this.openingHours,
  });

  @override
  State<_AttractionTile> createState() => _AttractionTileState();
}

class _AttractionTileState extends State<_AttractionTile> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  
  String? _getCurrentDayOpeningHours() {
    if (widget.openingHours == null || widget.openingHours!.isEmpty) {
      return null;
    }
    
    // Get current day of week (0 = Sunday, 1 = Monday, etc.)
    final now = DateTime.now();
    final dayOfWeek = now.weekday % 7; // Convert to 0-based where 0 is Sunday
    
    // Days in the API are ordered from Sunday (0) to Saturday (6)
    if (dayOfWeek < widget.openingHours!.length) {
      return widget.openingHours![dayOfWeek];
    }
    
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Get current day's opening hours
    final todayHours = _getCurrentDayOpeningHours();
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel
          Stack(
            children: [
              CarouselSlider(
                carouselController: _carouselController,
                items: _buildCarouselItems(screenWidth),
                options: CarouselOptions(
                  height: 160,
                  viewportFraction: 0.5,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  padEnds: false,
                ),
              ),
              
              // Navigation Controls
              if (widget.imageUrls.length > 2)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Button
                      if (_currentImageIndex > 0)
                        GestureDetector(
                          onTap: () {
                            _carouselController.animateToPage(
                              _currentImageIndex - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),
                        
                      // Next Button
                      if (_currentImageIndex < widget.imageUrls.length - 2)
                        GestureDetector(
                          onTap: () {
                            _carouselController.animateToPage(
                              _currentImageIndex + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),
                    ],
                  ),
                ),
                
              // Image Counter
              if (widget.imageUrls.length > 1)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/${widget.imageUrls.length-1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Content Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - Name, Type, Address
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.attraction.name ?? 'Unknown',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.attraction.types?.isNotEmpty == true 
                              ? _formatTypes(widget.attraction.types!)
                              : 'Tourist Attraction',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (widget.attraction.vicinity != null)
                          Text(
                            widget.attraction.vicinity!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondary,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Right Column - Save Button, Rating, Hours
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Save Button
                      Column(
                        children: [
                          InkWell(
                            onTap: widget.onSaveTap,
                            child: Icon(
                              widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: widget.isSaved ? theme.colorScheme.primary : Colors.grey,
                              size: 24,
                            ),
                          ),
                          Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 10,
                              color: widget.isSaved ? theme.colorScheme.primary : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      const Spacer(),
                      
                      // Rating and Hours
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.attraction.rating != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(
                                  ' ${widget.attraction.rating}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          if (todayHours != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.attraction.openingHours?.openNow == true
                                    ? Colors.green.shade50
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                todayHours.split(': ')[1], // Extract just the hours part
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.attraction.openingHours?.openNow == true
                                      ? Colors.green.shade700
                                      : Colors.blue.shade700,
                                ),
                              ),
                            )
                          else if (widget.attraction.openingHours?.openNow != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.attraction.openingHours!.openNow!
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.attraction.openingHours!.openNow! ? 'Open Now' : 'Closed',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.attraction.openingHours!.openNow!
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildCarouselItems(double screenWidth) {
    final List<String> displayImages = [...widget.imageUrls];
    
    // Ensure we have at least 2 images
    while (displayImages.length < 2) {
      displayImages.add('https://via.placeholder.com/400x200?text=No+Image');
    }
    
    return displayImages.map((imageUrl) {
      return SizedBox(
        width: screenWidth / 2 - 1, // Half screen width minus separator
        child: widget.isLoadingMore && displayImages.indexOf(imageUrl) > 0
            ? _buildLoadingImagePlaceholder()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorImagePlaceholder(),
              ),
      );
    }).toList();
  }
  
  Widget _buildLoadingImagePlaceholder() {
    return Container(
      height: 160,
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Widget _buildErrorImagePlaceholder() {
    return Container(
      height: 160,
      color: Colors.grey.shade300,
      child: const Center(child: Icon(Icons.image, size: 40)),
    );
  }
  
  String _formatTypes(List<String> types) {
    // Format the types to be more readable
    final formattedTypes = types.map((type) {
      return type.replaceAll('_', ' ').split(' ').map((word) {
        return word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '';
      }).join(' ');
    }).toList();
    
    // Return only the first two types
    return formattedTypes.take(2).join(' • ');
  }
} 