import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/Model/User.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<bool> checkUserExits(String userId) async {
    try {
      DocumentSnapshot snapshot = await _userCollection.doc(userId).get();
      return snapshot.exists;
    } catch (e) {
      print('Error check user exist: $e');
      return false;
    }
  }

  Future<List<User>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _userCollection.get();
      return snapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      throw e;
    }
  }

  Future<void> updateUser(String userId, User user) async {
    try {
      await _userCollection.doc(userId).update(user.toMap());
      print('Username: ${user.userName}');
      print('Class: ${user.userClass}');
      print('Position: ${user.position}');
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
