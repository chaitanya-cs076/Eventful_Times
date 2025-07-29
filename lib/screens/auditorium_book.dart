import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_managemet/screens/BookingScreen.dart';
import 'package:flutter/material.dart';

class AuditoriumBooking extends StatefulWidget {
  final String date;
  final String startTime;
  final String endTime;

  AuditoriumBooking({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  @override
  _AuditoriumBookingState createState() => _AuditoriumBookingState();
}

class _AuditoriumBookingState extends State<AuditoriumBooking> {
  final List<Map<String, String>> auditoriums = [
    {
      "image": "assets/audi1.jpg",
      "name": "Auditorium 1",
      "details": "This is Auditorium A with a seating capacity of 500 people.",
      "location": "P J Block",
      "seats": "500 seats",
      "size": "2000 sqft",
    },
    {
      "image": "assets/audi 4.jpg",
      "name": "Auditorium 2",
      "details": "This is Auditorium B with a seating capacity of 300 people.",
      "location": "P G Block",
      "seats": "300 seats",
      "size": "1500 sqft",
    },
    {
      "image": "assets/audi 3.jpg",
      "name": "PG Lab",
      "details": "This is Auditorium B with a seating capacity of 300 people.",
      "location": "P J Block",
      "seats": "300 seats",
      "size": "1500 sqft",
    },
    // Add more auditoriums as needed
  ];

  bool isSpecialCase(String auditoriumName) {
    if (auditoriumName == "Auditorium 1" &&
        widget.date == "2024-08-27" &&
        widget.startTime == "16:00" &&
        widget.endTime == "17:00") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Select Auditorium",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.9,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
              ),
              items: auditoriums.map((auditorium) {
                bool isAvailable = !isSpecialCase(auditorium['name']!);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                auditorium['image']!,
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.8,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auditorium['name']!,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 20),
                                    SizedBox(width: 7),
                                    Text(
                                      auditorium['location']!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.event_seat, size: 20),
                                    SizedBox(width: 7),
                                    Text(
                                      auditorium['seats']!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.aspect_ratio, size: 20),
                                    SizedBox(width: 7),
                                    Text(
                                      auditorium['size']!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          Center(
                            child: ElevatedButton(
                              onPressed: isAvailable
                                  ? () {
                                      Navigator.pop(
                                          context, auditorium['name']);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isAvailable
                                    ? Color.fromARGB(255, 0, 0, 255)
                                    : Colors.grey,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                isAvailable ? 'Select' : 'Not Available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BookingScreen(),
  ));
}
