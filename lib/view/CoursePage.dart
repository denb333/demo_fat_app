import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fat_app/view/widgets/search_bar.dart';
import 'package:fat_app/view/widgets/subject_chips.dart';
import 'package:fat_app/view/widgets/custom_app_bar.dart';
import 'package:fat_app/view/widgets/custom_bottom_navigation_bar.dart';
import 'package:fat_app/Model/Courses.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  _CoursePage createState() => _CoursePage();
}

class _CoursePage extends State<CoursePage> {
  String username = 'Trần Đức Vũ';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Course> courses = [];
  List<String> registeredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _fetchRegisteredCourses();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        username = user.displayName ?? '';
      });
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final result = await _firestore.collection('Courses').get();
      setState(() {
        courses =
            result.docs.map((doc) => Course.fromDocumentSnapshot(doc)).toList();
      });
    } catch (e) {
      print('Failed to fetch courses: $e');
    }
  }

  Future<void> _fetchRegisteredCourses() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        setState(() {
          registeredCourses =
              List<String>.from(userDoc.data()?['registeredCourses'] ?? []);
        });
      } catch (e) {
        print('Failed to fetch registered courses: $e');
      }
    }
  }

  Future<void> _registerCourse(String courseId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('Users').doc(user.uid).update({
          'registeredCourses': FieldValue.arrayUnion([courseId]),
        });
        _fetchRegisteredCourses();
      } catch (e) {
        print('Failed to register course: $e');
      }
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
      body: Column(
        children: [
          // Search bar and subject chips
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
          Container(
            width: double.infinity,
            color: Colors.lightBlue.shade100,
            padding: const EdgeInsets.all(16.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expected class',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7,
              children: courses.map((course) {
                bool isRegistered = registeredCourses.contains(course.id);
                return _buildClassCard(
                    course.subject,
                    course.teacher,
                    '${course.startTime} - ${course.endTime}',
                    course.price,
                    course.description,
                    isRegistered,
                    course.id);
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
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
              Navigator.of(context).pushNamed('/listlecture');
              break;
          }
        },
      ),
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
      child: Container(
        color: Colors.green,
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
                      Navigator.of(context)
                          .pushNamed('/listlecture', arguments: {
                        'courseId': courseId,
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Join'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(
                          context, price, courseId, subject);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Buy for \$$price'),
                  ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, double price, String courseId, subject) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Purchase'),
            content: Text("Bạn xác nhận mua khóa học với giá \$$price?"),
            actions: <Widget>[
              TextButton(
                  child: Text("Không"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                child: Text('Có'),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                  _registerCourse(courseId); // Đăng ký khóa học
                  Navigator.of(context).pushNamed('/payment', arguments: {
                    'price': price,
                    'courseId': courseId,
                    'subject': subject,
                    'username': username,
                  });
                },
              ),
            ],
          );
        });
  }
}
