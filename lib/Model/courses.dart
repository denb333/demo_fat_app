import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String teacher;
  final String startTime;
  final String endTime;
  final String subject;
  final String description;
  final double price;

  Course({
    required this.id,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.description,
    required this.price,
  });

  factory Course.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Course(
      id: doc.id,
      teacher: doc['teacher'] ?? '',
      startTime: doc['startTime'] ?? '',
      endTime: doc['endTime'] ?? '',
      subject: doc['subject'] ?? '',
      description: doc['description'] ?? '',
      price: doc['price']?.toDouble() ?? 0.0,
    );
  }
}
