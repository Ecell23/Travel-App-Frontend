import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  final List<ItineraryStep> steps = [
    ItineraryStep(
      place: "Gangtok (Your Location)",
      time: "07:00 am",
      modeDetails: "Drive a Car 30 min (15 km)",
      modeIcon: Icons.directions_car,
    ),
    ItineraryStep(
      place: "GTK Airport",
      time: "07:30 am",
      modeDetails: "By Flight 03 h 30 min (300 km)",
      modeIcon: Icons.flight,
    ),
    ItineraryStep(
      place: "DEL Airport",
      time: "11:00 am",
      modeDetails: "Drive a Car 01 h (30 km)",
      modeIcon: Icons.directions_car,
    ),
    ItineraryStep(
      place: "DEL Railway Station",
      time: "01:00 pm",
      modeDetails: "By Train 06 h (150 km)",
      modeIcon: Icons.train,
    ),
    ItineraryStep(
      place: "Shimla",
      time: "06:00 pm",
      modeDetails: "Drive a Car 01 h (30 km)",
      modeIcon: Icons.directions_car,
    ),
    ItineraryStep(
      place: "ABC Hotel",
      time: "07:00 pm",
      modeDetails: "Drive a Car 01 h (30 km)",
      modeIcon: Icons.directions_car,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Itinerary",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF536982),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  minHeight: 300,
                  maxHeight: screenHeight * 0.8,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: steps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          return _ItineraryStepWidget(step: step);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'See More',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Safety Board",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF536982),
                ),
              ),
              const SizedBox(height: 16),
              const SafetyBoardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}


class ItineraryStep {
  final String place;
  final String time;
  final String modeDetails;
  final IconData modeIcon;

  ItineraryStep({
    required this.place,
    required this.time,
    required this.modeDetails,
    required this.modeIcon,
  });
}

class _ItineraryStepWidget extends StatelessWidget {
  final ItineraryStep step;

  const _ItineraryStepWidget({required this.step});

  @override
  Widget build(BuildContext context) {
    const double timelineWidth = 50;
    const double timelineBarHeight = 40;
    const double topCircleDiameter = 50;
    const double bottomCircleDiameter = 16;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimelineItem(
          icon: step.modeIcon,
          barColor: const Color(0xFF6393F2),
          width: timelineWidth,
          barHeight: timelineBarHeight,
          topCircleDiameter: topCircleDiameter,
          bottomCircleDiameter: bottomCircleDiameter,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        step.place,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF536982),
                        ),
                      ),
                    ),
                    Text(
                      step.time,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF536982),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  step.modeDetails,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF536982),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final IconData icon;
  final Color barColor;
  final double width;
  final double barHeight;
  final double topCircleDiameter;
  final double bottomCircleDiameter;

  const TimelineItem({
    super.key,
    required this.icon,
    this.barColor = const Color(0xFF6393F2),
    this.width = 10,
    this.barHeight = 100.00,
    this.topCircleDiameter = 20,
    this.bottomCircleDiameter = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 100.0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: topCircleDiameter / 4,
            child: Container(
              width: width / 2,
              height: barHeight * 2,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(width / 2),
              ),
            ),
          ),
          Container(
            width: topCircleDiameter / 2,
            height: topCircleDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: topCircleDiameter * 0.4,
              color: Colors.blueGrey,
            ),
          ),
          Positioned(
            bottom: 12,
            child: Container(
              width: bottomCircleDiameter,
              height: bottomCircleDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SafetyButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
              color: const Color(0xFF536982),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF536982),
          ),
        ),
      ],
    );
  }
}

class SafetyBoardWidget extends StatelessWidget {
  const SafetyBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400, // Increased height to fit incident field
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SafetyButton(
                      icon: Icons.phone,
                      label: 'Call',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling emergency...')),
                        );
                      },
                    ),
                    _SafetyButton(
                      icon: Icons.warning_amber_rounded,
                      label: 'Alert',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sending warning...')),
                        );
                      },
                    ),
                    _SafetyButton(
                      icon: Icons.location_on,
                      label: 'Locate',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enabling live location...')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/placeholder_map.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'ENABLE LIVE LOCATION',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Report Incident',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incident reported!')),
                  );
                },
                child: const Icon(Icons.send, size: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}
