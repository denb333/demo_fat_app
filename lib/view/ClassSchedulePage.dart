import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/view/widgets/custom_app_bar.dart';
import 'package:fat_app/view/widgets/custom_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fat_app/view/widgets/search_bar.dart';
import 'package:fat_app/view/widgets/subject_chips.dart';

class ClassSchedulePage extends StatefulWidget {
  const ClassSchedulePage({super.key});

  @override
  State<StatefulWidget> createState() => _ClassSchedulePage();
}

class _ClassSchedulePage extends State<ClassSchedulePage> {
  String username = '';
  int currentIndex = 1;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            username = doc.get('username') as String? ?? '';
          });
          print('Logged in user: $username');
        } else {
          print('User document does not exist');
        }
      } else {
        print('No user is currently logged in');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          username: username,
          onAvatarTap: () {
            Navigator.of(context).pushNamed('/updateinformation');
          },
          onNotificationTap: () {}),
      body: Column(
        children: [
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchBarWidget(
                  onSearch: (query) {
                    // Handle search logic
                    print("Search query: $query");
                  },
                ),
                const SizedBox(height: 12.0),
                SubjectChipsWidget(subjects: [
                  'Chemistry',
                  'Physics',
                  'Math',
                  'Geography',
                  'History',
                ]),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tran Duc Vu! Study well, don\'t get lower grades than me',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  backgroundColor: Colors.redAccent,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Class',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
          // Class Details
          Expanded(
            child:
                _buildClassCard('Math', 'Mr John', '18:30 - 21:00 Wednesday'),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          _navigateToPage(index);
        },
      ),
    );
  }

  Widget _buildIconWithBackground(IconData icon, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.green, size: 30),
    );
  }

  // Widget to build a chip for course categories
  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // Widget to build the class details card
  Widget _buildClassCard(String subject, String teacher, String time) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.green[300],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Tutor\'s Name: $teacher',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                time,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Tabs for assignments, documents, and comments
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: 'Assignments'),
                        Tab(text: 'Documents'),
                        Tab(text: 'Comments'),
                      ],
                    ),
                    Container(
                      height: 50, // Height of the tab content
                      child: const TabBarView(
                        children: [
                          Center(
                              child: Text(
                                  'The assignment will be assigned by the teacher after the end of the lesson')),
                          Center(child: Text('No documents uploaded')),
                          Center(child: Text('No comments yet')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/interactlearning');
        break;
      case 1:
        Navigator.of(context).pushNamed('/classschedule');
        break;
      case 2:
        Navigator.of(context).pushNamed('/course');
        break;
      case 3:
        Navigator.of(context).pushNamed('/inbox');
        break;
      case 4:
        Navigator.of(context).pushNamed('/findtutor');
        break;
    }
  }
}
