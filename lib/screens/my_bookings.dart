import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_managemet/model/bookings_model.dart';
import 'package:event_managemet/model/user_model.dart';
import 'package:event_managemet/screens/login_screen.dart';
import 'package:event_managemet/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart'; // Assuming HomeScreen is in the same directory

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data()!);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 0, 0, 255),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('clubName', isEqualTo: loggedInUser.clubName)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot bookingDoc = snapshot.data!.docs[index];
                Bookings booking = Bookings.fromMap(
                    bookingDoc.data()! as Map<String, dynamic>);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ListTile(
                          title: Text(
                            booking.eventName,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 21),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(booking.date.toDate())}',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 20, 20, 20),
                                    fontSize: 18),
                              ),
                              SizedBox(height: 4), // Add a small space
                              Text(
                                'Time: ${DateFormat('HH:mm').format(booking.startTime.toDate())} - ${DateFormat('HH:mm').format(booking.endTime.toDate())}',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                              SizedBox(height: 4), // Add a small space
                              Text(
                                'Auditorium: ${booking.auditorium}',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
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
        currentIndex: 2,
        selectedItemColor: Color.fromARGB(255, 0, 0, 255),
        unselectedItemColor: Colors.black,
        onTap: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              break;
            case 2:
              // My Bookings
              // No action needed as already on My Bookings screen
              break;
            case 3:
              // Logout
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }).catchError((e) {
                print(e);
              });
              break;
          }
        },
      ),
    );
  }
}
