import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  _CoursePage createState() => _CoursePage();
}

class _CoursePage extends State<CoursePage> {
  String username = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> courses = [];
  List<String> registeredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _fetchRegisteredCourses();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Load username if needed
    }
  }

  Future<void> _fetchCourses() async {
    final result = await _firestore.collection('Courses').get();
    setState(() {
      courses = result.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _fetchRegisteredCourses() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();
      setState(() {
        registeredCourses =
            List<String>.from(userDoc.data()?['registeredCourses'] ?? []);
      });
    }
  }

  Future<void> _registerCourse(String courseId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'registeredCourses': FieldValue.arrayUnion([courseId]),
      });
      _fetchRegisteredCourses();
    }
  }

  Future<void> _addCourse(String name, String teacher, String startTime,
      String endTime, String description) async {
    try {
      await _firestore.collection('Courses').add({
        'name': name,
        'teacher': teacher,
        'startTime': startTime,
        'endTime': endTime,
        'description': description,
      });
      _fetchCourses(); // Refresh the list after adding
    } catch (e) {
      print('Failed to add course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/students.png'),
            ),
            const SizedBox(width: 10),
            const Text(
              'Trần Đức Vũ',
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              color: Colors.black,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expected class',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2,
              children: courses.map((course) {
                bool isRegistered = registeredCourses.contains(course['id']);
                return _buildClassCard(
                  course['name'],
                  course['teacher'],
                  '${course['startTime']} - ${course['endTime']}',
                  course['price'] ?? 0.0,
                  course['description'],
                  isRegistered,
                  course['id'],
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Example: Add a new course
              _addCourse('Math', 'Mr. Smith', '14:00', '15:00',
                  'An introductory math course');
            },
            child: const Text('Add Course'),
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
            icon: _buildIconWithBackground(
                Icons.person_search, Colors.green.shade100),
            label: 'Find a tutor',
          ),
        ],
        onTap: (index) {
          // Navigation logic here
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: 2,
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

  Widget _buildClassCard(
    String subject,
    String teacher,
    String time,
    double price,
    String description,
    bool isRegistered,
    String courseId,
  ) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            subject,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('Teacher: $teacher'),
          const SizedBox(height: 5),
          Text(time),
          const SizedBox(height: 10),
          Text(description),
          const SizedBox(height: 5),
          isRegistered
              ? ElevatedButton(
                  onPressed: () {
                    // User has registered, implement join functionality
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Join'),
                )
              : ElevatedButton(
                  onPressed: () {
                    _registerCourse(courseId);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Buy for \$$price'),
                ),
        ],
      ),
    );
  }
}
