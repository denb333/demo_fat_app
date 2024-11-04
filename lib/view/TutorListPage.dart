import 'package:fat_app/Model/courses.dart';
import 'package:fat_app/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/UserModel.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  State<TutorListPage> createState() => _TutorListPageState();
}

class TutorData {
  final Course course;
  final UserModel user;

  TutorData({required this.course, required this.user});
}

class _TutorListPageState extends State<TutorListPage> {
  List<TutorData> tutors = [];
  String searchQuery = "";

  Future<void> fetchTutors() async {
    if (searchQuery.isEmpty) {
      setState(() {
        tutors.clear();
      });
      return;
    }

    final lowercaseQuery = searchQuery.toLowerCase();

    final queryResult =
        await FirebaseFirestore.instance.collection('Courses').get();

    final filteredDocs = queryResult.docs.where((doc) {
      final subject = doc['subject'].toString().toLowerCase();
      final teacher = doc['teacher'].toString().toLowerCase();
      return subject.contains(lowercaseQuery) ||
          teacher.contains(lowercaseQuery);
    }).toList();

    List<TutorData> loadedTutors = [];
    for (var doc in filteredDocs) {
      Course course = Course.fromDocumentSnapshot(doc);

      // Fetch user data
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(course.creatorId)
          .get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        loadedTutors.add(TutorData(course: course, user: user));
      }
    }

    setState(() {
      tutors = loadedTutors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search subject or teacher',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onChanged: (value) {
            searchQuery = value;
            fetchTutors();
          },
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.person_pin_circle, size: 24),
                SizedBox(width: 5),
                Text(
                  'Found tutors',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tutors.length,
              itemBuilder: (context, index) {
                final tutorData = tutors[index];
                return _buildTutorCard(
                  tutorData.course.teacher,
                  tutorData.course.subject,
                  "https://example.com/image.png",
                  "5 km",
                  tutorData.course.startTime,
                  tutorData.course.endTime,
                  tutorData.course.price.toString(),
                  tutorData.course.description,
                  tutorData.user.position,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _buildIconWithBackground(
                Icons.play_circle_filled, Colors.green.shade100),
            label: 'Interact Learning',
          ),
          BottomNavigationBarItem(
            icon:
                _buildIconWithBackground(Icons.schedule, Colors.green.shade100),
            label: 'Class Schedule',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithBackground(Icons.book, Colors.green.shade100),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithBackground(Icons.chat, Colors.green.shade100),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithBackground(
                Icons.person_search, Colors.green.shade100),
            label: 'Find a tutor',
          ),
        ],
        onTap: (int index) {
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
              Navigator.of(context).pushNamed('/chat');
              break;
            case 4:
              Navigator.of(context).pushNamed('/findatutor');
              break;
          }
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: 4,
      ),
    );
  }
}

Widget _buildTutorCard(
    String name,
    String subject,
    String imagePath,
    String distance,
    String startTime,
    String endTime,
    String price,
    String description,
    String position) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imagePath),
      ),
      title: Text('$name ($subject)'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Position: $position'),
          Text('Time: $startTime - $endTime'),
          Text('Price: \$${price}'),
          Text('Description: $description'),
          Text(distance),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    ),
  );
}

Widget _buildIconWithBackground(IconData icon, Color color) {
  return CircleAvatar(
    backgroundColor: color,
    radius: 20,
    child: Icon(
      icon,
      size: 25,
      color: Colors.green.shade900,
    ),
  );
}
