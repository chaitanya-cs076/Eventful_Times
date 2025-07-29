import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_managemet/screens/home_screen.dart';
import 'package:event_managemet/screens/login_screen.dart';
import 'package:event_managemet/screens/my_bookings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController presidentNameController = TextEditingController();
  final TextEditingController clubEmailController = TextEditingController();
  final TextEditingController clubPhoneNumberController =
      TextEditingController();

  // Define a list of departments
  List<String> departments = [
    'Engineering',
    'Arts and Sciences',
    'Business',
    'Education',
    // Add more departments as needed
  ];

  // Define a variable to hold the selected department
  String? selectedDepartment;

  bool _isEditing = false;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;
          if (userData != null) {
            setState(() {
              clubNameController.text = userData['clubName'] ?? '';
              selectedDepartment = userData['department'] ?? departments.first;
              presidentNameController.text = userData['PresidentName'] ?? '';
              clubEmailController.text = userData['email'] ?? '';
              clubPhoneNumberController.text = userData['phoneNO'] ?? '';
            });
          }
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'clubName': clubNameController.text,
          'department': selectedDepartment,
          'PresidentName': presidentNameController.text,
          'email': clubEmailController.text,
          'phoneNO': clubPhoneNumberController.text,
        });
        if (_imageFile != null) {
          // TODO: Save the image to your storage and update the profile image URL in Firestore
        }
        print('Profile updated successfully');
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 255),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isEditing = false;
                  });
                  // Save changes
                  await _saveChanges();
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider<Object>
                          : AssetImage('assets/dp.jpg')
                              as ImageProvider<Object>,
                    ),
                    if (_isEditing)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color.fromARGB(255, 0, 0, 255),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: clubNameController,
                decoration: InputDecoration(
                  labelText: 'Club Name',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 19),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 19,
                ),
                enabled: false, // Disable editing for club name
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Department',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 19),
                ),
                items: departments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _isEditing
                    ? (String? value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                      }
                    : null,
                value: selectedDepartment,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: presidentNameController,
                decoration: InputDecoration(
                  labelText: 'President Name',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 19),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 19,
                ),
                enabled: _isEditing,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: clubEmailController,
                decoration: InputDecoration(
                  labelText: 'Club Email',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 19),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 19,
                ),
                enabled: false, // Disable editing for email
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: clubPhoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Club Phone Number',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 19),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 19,
                ),
                enabled: _isEditing,
                validator: _isEditing
                    ? (value) {
                        // Validate phone number only if editing
                        if (value != null && value.isNotEmpty) {
                          // Check if the entered value is either null or exactly 10 digits and contains only numbers
                          if (value.length != 10 ||
                              int.tryParse(value) == null) {
                            return 'Enter a valid 10-digit phone number';
                          }
                        }
                        return null;
                      }
                    : null,
                keyboardType: TextInputType.phone, // Set keyboard type to phone
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Allow only digits input
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: 1,
          onTap: (index) {
            // Handle navigation
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
                break;
              case 2:
                // My Booking
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookings()),
                );
                break;
              case 3:
                // Logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                break;
            }
          },
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Color.fromARGB(255, 0, 0, 255),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 255)),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event, color: Colors.black),
              label: 'My Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout, color: Colors.black),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProfilePage(),
  ));
}
