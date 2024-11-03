// import 'package:flutter/material.dart';

// class NearbyTutorsScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> tutors = [
//     {
//       'name': 'Messi',
//       'subjects': 'Math & Chemistry',
//       'distance': 'Within 1km',
//       'image': 'https://link-to-messi-image.jpg',
//     },
//     {
//       'name': 'Trần Đức Vũ',
//       'subjects': 'Math & Chemistry',
//       'distance': 'Within 1km',
//       'image': 'https://link-to-vu-image.jpg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Icon(Icons.location_on),
//                 SizedBox(width: 8),
//                 Text('Found ${tutors.length} tutors near you'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: tutors.length,
//               itemBuilder: (context, index) {
//                 final tutor = tutors[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(tutor['image']),
//                   ),
//                   title: Text('${tutor['name']} (${tutor['subjects']})'),
//                   subtitle: Text(tutor['distance']),
//                   trailing: Icon(Icons.arrow_forward),
//                   onTap: () {
//                     // Xử lý khi người dùng nhấn vào gia sư
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
