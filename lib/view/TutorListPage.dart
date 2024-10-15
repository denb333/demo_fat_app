import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  State<TutorListPage> createState() => _TutorListPageState();
}

class _TutorListPageState extends State<TutorListPage> {
  List<Map<String, dynamic>> tutors = [];
  String searchQuery = "";
//create map save informtion
  Future<void> fetchTutors(String query) async {
    if (query.isEmpty) {
      setState(() {
        tutors.clear();
      });
      return;
    }
    //get name tutors by firebase data
    final result = await FirebaseFirestore.instance
        .collection('Tutors')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    setState(() {
      tutors = result.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
            fetchTutors(value);
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
                  'Found tutor near you',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Expanded(child: ListView.builder(itemBuilder: (context, index) {
            return _buildTutorCard(
              tutors[index]['name'],
              tutors[index]['subjects'],
              tutors[index]['imagePath'],
              tutors[index]['distance'],
            );
          }))
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
        currentIndex: 3,
      ),
    );
  }
}

Widget _buildTutorCard(
    String name, String subject, String imagePath, String distance) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imagePath),
      ),
      title: Text('$name ($subject)'),
      subtitle: Text(distance),
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
