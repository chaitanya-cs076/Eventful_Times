import 'package:flutter/material.dart';

class AuditoriumPage extends StatefulWidget {
  @override
  _AuditoriumPageState createState() => _AuditoriumPageState();
}

class _AuditoriumPageState extends State<AuditoriumPage> {
  // Mock data for auditoriums
  List<Map<String, String>> auditoriums = [
    {'imagePath': 'assets/audi1.jpg', 'name': 'Auditorium 1'},
    {'imagePath': 'assets/audi 2.jpg', 'name': 'Auditorium 2'},
    {'imagePath': 'assets/audi 3.jpg', 'name': 'Auditorium 3'},
    {'imagePath': 'assets/audi 4.jpg', 'name': 'Auditorium 4'},
    {'imagePath': 'assets/audi 5.jpg', 'name': 'Auditorium 5'},
    {'imagePath': 'assets/audi1.jpg', 'name': 'Auditorium 6'},
  ];

  List<Map<String, String>> filteredAuditoriums = [];
  bool auditoriumsFound =
      true; // Flag to track if any auditoriums match the query

  @override
  void initState() {
    super.initState();
    filteredAuditoriums =
        List.from(auditoriums); // Initialize with all auditoriums
  }

  void filterAuditoriums(String query) {
    final List<Map<String, String>> results = auditoriums.where((auditorium) {
      final String name = auditorium['name']!.toLowerCase();
      final String input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    setState(() {
      filteredAuditoriums = results;
      auditoriumsFound = results.isNotEmpty; // Update auditoriumsFound flag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 20.0, 16.0, 16.0), // Adjust top padding here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0), // Space above the search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: filterAuditoriums,
                  decoration: InputDecoration(
                    hintText: 'Search auditoriums...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0), // Space between search bar and images
            Expanded(
              child: filteredAuditoriums.isEmpty
                  ? Center(
                      child: Text(
                        'Auditorium not found.',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredAuditoriums.length,
                      itemBuilder: (context, index) {
                        return buildRow(index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build a single AuditoriumCard
  Widget buildRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AuditoriumCard(
        imagePath: filteredAuditoriums[index]['imagePath']!,
        auditoriumName: filteredAuditoriums[index]['name']!,
      ),
    );
  }
}

class AuditoriumCard extends StatelessWidget {
  final String imagePath;
  final String auditoriumName;

  AuditoriumCard({required this.imagePath, required this.auditoriumName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 180, // Reduced the height slightly
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            auditoriumName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
