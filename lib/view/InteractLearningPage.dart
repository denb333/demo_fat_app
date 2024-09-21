import 'package:flutter/material.dart';

class InteractLearningPage extends StatefulWidget {
  const InteractLearningPage({super.key});

  @override
  State<InteractLearningPage> createState() => _InteractLearningPageState();
}

class _InteractLearningPageState extends State<InteractLearningPage> {
  @override
  Widget build(BuildContext context) {
    final String? email = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/students.png'),
            ),
            Text(email as String),
            const Icon(Icons.notifications),
          ],
        ),
        backgroundColor: Colors.green.shade100,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Wrap(
                  spacing: 10,
                  children: [
                    Chip(label: Text('Chemistry')),
                    Chip(label: Text('Physics')),
                    Chip(label: Text('Math')),
                    Chip(label: Text('Geographic')),
                    Chip(label: Text('History')),
                  ],
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
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/interactLearning');
              break;
            case 1:
              Navigator.of(context).pushNamed('/classschedule');
              break;
            case 2:
              Navigator.of(context).pushNamed('/course');
              break;
            case 3:
              Navigator.of(context).pushNamed('/findatutor');
              break;
          }
        },
      ),
    );
  }
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
    String className, String classLevel, String status, Color color) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          className,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(classLevel),
      ],
    ),
  );
}

Widget _buildSchedule() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(15.0),
    child: const Column(
      children: [
        Text('26', style: TextStyle(fontSize: 28, color: Colors.orange)),
        Text('T2'),
        SizedBox(height: 5),
        Text('Không có lớp học hôm nay'),
        SizedBox(height: 5),
        Text(
          'Buổi học tiếp theo diễn ra vào ngày 27/08',
          style: TextStyle(color: Colors.grey),
        )
      ],
    ),
  );
}

Widget _buildFeatureIcon(IconData iconData, String label) {
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: Colors.green.shade100,
        child: Icon(iconData, color: Colors.green, size: 30),
      ),
      const SizedBox(height: 5),
      Text(label),
    ],
  );
}
