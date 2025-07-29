import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  Future<List<String>> fetchBookedAuditoriums(
      String date, String startTime, String endTime) async {
    List<String> bookedAuditoriums = [];
    QuerySnapshot snapshot = await bookingsCollection
        .where('date', isEqualTo: date)
        .where('startTime', isLessThan: endTime)
        .where('endTime', isGreaterThan: startTime)
        .get();

    snapshot.docs.forEach((doc) {
      bookedAuditoriums.add(doc['auditorium']);
    });

    return bookedAuditoriums;
  }
}
