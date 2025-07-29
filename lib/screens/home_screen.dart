import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_managemet/model/bookings_model.dart';
import 'package:event_managemet/model/user_model.dart';
import 'package:event_managemet/screens/BookingScreen.dart';
import 'package:event_managemet/screens/login_screen.dart';
import 'package:event_managemet/screens/my_bookings.dart';
import 'package:event_managemet/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool _showLogoutButton = false;
  final ScrollController _horizontalScrollController = ScrollController();
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data()!);
      setState(() {
        _showLogoutButton =
            true; // Show the logout button once user data is fetched
      });
    });
    // Start auto-scrolling
    _ticker = this.createTicker((_) => _autoScroll(Duration(seconds: 1)));
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _autoScroll(Duration duration) {
    if (_horizontalScrollController.hasClients) {
      final maxScrollExtent =
          _horizontalScrollController.position.maxScrollExtent;
      final currentPosition = _horizontalScrollController.offset;
      final nextPosition =
          currentPosition + 1.0; // Adjust scroll speed by changing this value

      if (nextPosition >= maxScrollExtent) {
        _horizontalScrollController
            .jumpTo(0.0); // Restart scrolling from the beginning
      } else {
        _horizontalScrollController.jumpTo(nextPosition);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to Event Management",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${loggedInUser.clubName} ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${loggedInUser.PresidentName}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),
                  Text(
                    "Upcoming Events",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Times New Roman'),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 140, // Adjust height according to content
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bookings')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Text('No upcoming events found.');
                        } else {
                          return ListView.builder(
                            controller: _horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot eventDoc =
                                  snapshot.data!.docs[index];
                              Bookings event = Bookings.fromMap(
                                  eventDoc.data()! as Map<String, dynamic>);
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  width:
                                      200, // Increased width to accommodate spacing
                                  padding: EdgeInsets.all(
                                      12), // Increased padding for inner spacing
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        event.eventName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              8), // Increased space between title and icons
                                      Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  10), // Space from left border to icon
                                          Icon(
                                            Icons.event,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                          SizedBox(
                                              width:
                                                  6), // Space between icon and text
                                          Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(event.date.toDate()),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              1), // Adjusted space between rows
                                      Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  8), // Space from left border to icon
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                          SizedBox(
                                              width:
                                                  6), // Space between icon and text
                                          Text(
                                            '${DateFormat('HH:mm').format(event.startTime.toDate())} - ${DateFormat('HH:mm').format(event.endTime.toDate())}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              1), // Adjusted space between rows
                                      Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  8), // Space from left border to icon
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                          SizedBox(
                                              width:
                                                  6), // Space between icon and text
                                          Text(
                                            event.auditorium,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20), // Adjust the height as needed
                  Text(
                    "Polular Events",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Event Cards wrapped in a horizontal scrollable view
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // EventCard widget for each event
                        EventCard(
                          imageUrl: 'assets/dj.jpg',
                          eventName: 'DJ Night',
                          eventDate: '',
                        ),
                        SizedBox(width: 20), // Adjust spacing between cards
                        EventCard(
                          imageUrl: 'assets/Seminars-1.jpg',
                          eventName: 'Conference',
                          eventDate: '',
                        ),
                        SizedBox(width: 20), // Adjust spacing between cards
                        EventCard(
                          imageUrl: 'assets/workshop.jpg',
                          eventName: 'Workshop',
                          eventDate: '',
                        ),
                        // Add more EventCard widgets as needed
                      ],
                    ),
                  ),
                  SizedBox(height: 30), // Space above the Book Event button
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight - 45),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to booking screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingScreen()),
            );
          },
          child: Text(
            "Book Event",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 0, 0, 255),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
            shadowColor: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Color.fromARGB(255, 0, 0, 255),
        unselectedItemColor: Colors.black,
        onTap: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              // Home
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookings()),
              );
              break;
            case 3:
              logout(context);
              break;
          }
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String eventName;
  final String eventDate;

  const EventCard({
    Key? key,
    required this.imageUrl,
    required this.eventName,
    required this.eventDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 250, // Adjust this width to change the size of each card
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: 160,
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Text(
              eventName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              eventDate,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
