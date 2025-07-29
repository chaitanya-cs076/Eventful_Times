import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
  final String clubName;
  final String? department;
  final String? eventCategory;
  final String eventName;
  final int? guests;
  final int? audience;
  final Timestamp date;
  final Timestamp startTime;
  final Timestamp endTime;
  final String auditorium;

  Bookings({
    required this.clubName,
    this.department,
    this.eventCategory,
    required this.eventName,
    this.guests,
    this.audience,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.auditorium,
  });

  Map<String, dynamic> toMap() {
    return {
      'clubName': clubName,
      'department': department,
      'eventCategory': eventCategory,
      'eventName': eventName,
      'guests': guests,
      'audience': audience,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'auditorium': auditorium,
    };
  }

  factory Bookings.fromMap(Map<String, dynamic> map) {
    return Bookings(
      clubName: map['clubName'],
      department: map['department'],
      eventCategory: map['eventCategory'],
      eventName: map['eventName'],
      guests: map['guests'],
      audience: map['audience'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      auditorium: map['auditorium'],
    );
  }
}

// Example usage:
void exampleUsage() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .doc('bookingId')
      .get();
  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Bookings bookings = Bookings.fromMap(data);

    // Accessing timestamp fields
    Timestamp date = bookings.date;
    Timestamp startTime = bookings.startTime;
    Timestamp endTime = bookings.endTime;

    // Convert Timestamp to DateTime if needed
    DateTime dateDateTime = date.toDate();
    DateTime startTimeDateTime = startTime.toDate();
    DateTime endTimeDateTime = endTime.toDate();

    print('Date: $dateDateTime');
    print('Start Time: $startTimeDateTime');
    print('End Time: $endTimeDateTime');
  } else {
    print('Document does not exist');
  }
}
