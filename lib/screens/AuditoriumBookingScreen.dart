import 'package:event_managemet/model/database_service.dart';
import 'package:flutter/material.dart';

class AuditoriumBookingScreen extends StatefulWidget {
  final String date;
  final String startTime;
  final String endTime;

  AuditoriumBookingScreen(
      {required this.date, required this.startTime, required this.endTime});

  @override
  _AuditoriumBookingScreenState createState() =>
      _AuditoriumBookingScreenState();
}

class _AuditoriumBookingScreenState extends State<AuditoriumBookingScreen> {
  final List<String> auditoriums = [
    "Auditorium 1",
    "Auditorium 2",
    "Auditorium 3"
  ];
  List<String> _availableAuditoriums = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableAuditoriums();
  }

  void _fetchAvailableAuditoriums() async {
    DatabaseService databaseService = DatabaseService();
    List<String> bookedAuditoriums = await databaseService
        .fetchBookedAuditoriums(widget.date, widget.startTime, widget.endTime);

    // Debugging: Print booked auditoriums to check the data
    print('Booked Auditoriums: $bookedAuditoriums');

    // Filter out booked auditoriums from the list of all auditoriums
    setState(() {
      _availableAuditoriums = auditoriums
          .where((auditorium) => !bookedAuditoriums.contains(auditorium))
          .toList();

      // Debugging: Print available auditoriums to check the filtering
      print('Available Auditoriums: $_availableAuditoriums');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _availableAuditoriums.isEmpty
          ? Center(
              child: Text('No auditoriums available for the selected time.'))
          : PageView.builder(
              itemCount: _availableAuditoriums.length,
              itemBuilder: (context, index) {
                return buildAuditoriumBookingScreen(index);
              },
            ),
    );
  }

  Widget buildAuditoriumBookingScreen(int index) {
    final String auditorium = _availableAuditoriums[index];

    return Stack(
      children: [
        // Static Image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
            child: Image.asset(
              "assets/audi 1.jpg", // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Scrolling content
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  ${auditorium}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This is a beautiful auditorium suitable for various events, such as conferences, seminars, and cultural activities. The auditorium is equipped with state-of-the-art facilities, including a high-quality sound system, comfortable seating, and modern lighting. It can accommodate a large number of guests and provides a perfect setting for memorable events.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'The auditorium is located in a prime area, easily accessible by public transportation. It also offers ample parking space for visitors. The venue management ensures that all events are conducted smoothly, providing all necessary support to the event organizers.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 20),
                          // Book Event Button
                          Center(
                            child: Container(
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, auditorium);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 24.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Select',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 2, 2, 160),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
