import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/view/widgets/custom_bottom_navigation_bar.dart';
import 'package:fat_app/view/widgets/search_bar.dart';
import 'package:fat_app/view/widgets/subject_chips.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fat_app/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class InteractLearningPage extends StatefulWidget {
  const InteractLearningPage({Key? key}) : super(key: key);

  @override
  _InteractLearningPageState createState() => _InteractLearningPageState();
}

class _InteractLearningPageState extends State<InteractLearningPage> {
  String username = '';
  int currentIndex = 0;

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
        }
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
        onNotificationTap: () {},
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureIcon(Icons.person_search, 'Find a tutor'),
                _buildFeatureIcon(Icons.question_answer, 'Q & A'),
                _buildFeatureIcon(Icons.search, 'Look up'),
              ],
            ),
          ),
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'This week\'s school schedule',
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildSchedule(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Group classes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildClassCard('Science and Technology',
                        'Class Standard 8', 'Studying', Colors.purple),
                    _buildClassCard('Math class 8', '(1vs1)', 'Focusing',
                        Colors.deepPurple),
                  ],
                )
              ],
            ),
          )
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

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade100,
          radius: 30,
          child: Icon(
            icon,
            size: 30,
            color: Colors.green.shade900,
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _buildSchedule() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green.shade900,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _buildScheduleRow(Icons.school, 'History', '14h:00 - 15h:00', true),
          _buildScheduleRow(
              Icons.school, 'Geographic', '15h:30 - 16h:30', false),
          _buildScheduleRow(
              Icons.science, 'Chemistry', '17h:00 - 18h:00', false),
          _buildScheduleRow(Icons.calculate, 'Math', '18h:30 - 19h:30', true),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(
      IconData icon, String subject, String time, bool isOddRow) {
    return Container(
      color: isOddRow ? Colors.green.shade50 : Colors.green.shade200,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.green.shade900),
          Text(subject),
          Text(time),
        ],
      ),
    );
  }

  Widget _buildClassCard(
      String title, String subtitle, String status, Color backgroundColor) {
    return Expanded(
      child: Card(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
