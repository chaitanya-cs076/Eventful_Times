import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_managemet/model/bookings_model.dart'; // Assuming correct path
import 'package:event_managemet/screens/auditorium_book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController audienceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedDepartment;
  String? selectedEventCategory;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  String? selectedAuditorium;

  final List<String> departments = [
    "Computer Science",
    "Mechanical Engineering",
    "Electrical Engineering",
    "Civil Engineering",
    "Chemical Engineering"
  ];

  final List<String> eventCategories = [
    "Workshop",
    "Seminar",
    "Conference",
    "Cultural Event",
    "Sports Event"
  ];

  @override
  void initState() {
    super.initState();
    _loadClubName();
  }

  Future<void> _loadClubName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          clubNameController.text = userDoc['clubName'];
        });
      }
    }
  }

  bool _areTimesValid() {
    if (selectedStartTime != null && selectedEndTime != null) {
      return selectedStartTime!.isBefore(selectedEndTime!);
    }
    return true;
  }

  Future<void> _bookEvent() async {
    if (_formKey.currentState!.validate()) {
      if (!_areTimesValid()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter valid time"),
          ),
        );
        return;
      }

      final bookings = Bookings(
        clubName: clubNameController.text,
        department: selectedDepartment,
        eventCategory: selectedEventCategory,
        eventName: eventNameController.text,
        guests: int.tryParse(guestsController.text),
        audience: int.tryParse(audienceController.text),
        date: Timestamp.fromDate(
            DateFormat('yyyy-MM-dd').parse(dateController.text)),
        startTime: Timestamp.fromDate(selectedStartTime!),
        endTime: Timestamp.fromDate(selectedEndTime!),
        auditorium: selectedAuditorium!,
      );

      await FirebaseFirestore.instance
          .collection('bookings')
          .add(bookings.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event booked successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubNameField = TextFormField(
      controller: clubNameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.group, color: Colors.black),
        labelText: "Club Name",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      readOnly: true, // Make the field read-only
    );

    final departmentField = DropdownButtonFormField<String>(
      value: selectedDepartment,
      items: departments.map((String department) {
        return DropdownMenuItem<String>(
          value: department,
          child: Text(department),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDepartment = value;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_balance, color: Colors.black),
        labelText: "Department",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final eventCategoryField = DropdownButtonFormField<String>(
      value: selectedEventCategory,
      items: eventCategories.map((String eventCategory) {
        return DropdownMenuItem<String>(
          value: eventCategory,
          child: Text(eventCategory),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedEventCategory = value;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.category, color: Colors.black),
        labelText: "Event Category",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final eventNameField = TextFormField(
      controller: eventNameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.event, color: Colors.black),
        labelText: "Event Name",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter event name";
        }
        return null;
      },
    );

    final dateField = InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          setState(() {
            dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: dateController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
            labelText: "Date",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please select a date";
            }
            return null;
          },
        ),
      ),
    );

    final timeField = (String label, DateTime? time,
        Function(DateTime) onTimeSelected, Function(String?) validator) {
      return TextFormField(
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            final now = DateTime.now();
            final selectedTime = DateTime(now.year, now.month, now.day,
                pickedTime.hour, pickedTime.minute);
            onTimeSelected(selectedTime);
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.access_time, color: Colors.black),
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorText:
              validator(time != null ? DateFormat('HH:mm').format(time) : null),
        ),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        readOnly: true,
        controller: TextEditingController(
            text: time != null ? DateFormat('HH:mm').format(time) : null),
        validator: (value) {
          if (time == null) {
            return "Please select a time";
          }
          return null;
        },
      );
    };

    final selectAuditoriumField = InkWell(
      onTap: () async {
        if (selectedStartTime != null && selectedEndTime != null) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuditoriumBooking(
                date: dateController.text,
                startTime: DateFormat('HH:mm').format(selectedStartTime!),
                endTime: DateFormat('HH:mm').format(selectedEndTime!),
              ),
            ),
          );

          if (result != null) {
            setState(() {
              selectedAuditorium = result;
            });
          }
        } else {
          // Show error if start time or end time is not selected
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please select both start and end times"),
            ),
          );
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_on, color: Colors.black),
            labelText: "Select Auditorium",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          validator: (value) {
            if (selectedAuditorium == null) {
              return "Please select an auditorium";
            }
            return null;
          },
          controller: TextEditingController(text: selectedAuditorium),
        ),
      ),
    );

    final guestsField = TextFormField(
      controller: guestsController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.black),
        labelText: "Number of Guests",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter number of guests";
        }
        return null;
      },
    );

    final audienceField = TextFormField(
      controller: audienceController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people, color: Colors.black),
        labelText: "Expected Audience",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter expected audience";
        }
        return null;
      },
    );

    final bookEventButton = ElevatedButton(
      onPressed: _bookEvent,
      child: Text(
        "Book Event",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 0, 0, 255), // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book an Event",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 255),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the backward arrow color to white
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              clubNameField,
              SizedBox(height: 16),
              departmentField,
              SizedBox(height: 16),
              eventCategoryField,
              SizedBox(height: 16),
              eventNameField,
              SizedBox(height: 16),
              dateField,
              SizedBox(height: 16),
              timeField("Start Time", selectedStartTime, (DateTime time) {
                setState(() {
                  selectedStartTime = time;
                });
              }, (String? value) {
                if (selectedEndTime != null && selectedStartTime != null) {
                  if (selectedStartTime!.isAfter(selectedEndTime!)) {
                    return 'invalid time';
                  }
                }
                return null;
              }),
              SizedBox(height: 16),
              timeField("End Time", selectedEndTime, (DateTime time) {
                setState(() {
                  selectedEndTime = time;
                });
              }, (String? value) {
                if (selectedStartTime != null && selectedEndTime != null) {
                  if (selectedEndTime!.isBefore(selectedStartTime!)) {
                    return 'invalid time';
                  }
                }
                return null;
              }),
              SizedBox(height: 16),
              selectAuditoriumField,
              SizedBox(height: 16),
              guestsField,
              SizedBox(height: 16),
              audienceField,
              SizedBox(height: 30),
              Center(child: bookEventButton),
            ],
          ),
        ),
      ),
    );
  }
}
