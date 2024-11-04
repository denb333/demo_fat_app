class UserModel {
  final String userName;
  final String email;
  final String role;
  final String userClass;
  final String position;

  UserModel({
    required this.userName,
    required this.email,
    required this.role,
    required this.userClass,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': userName,
      'email' : email,
      'role' : role,
      'class': userClass,
      'position': position,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['username'] ?? '',
      email: map['email']??'',
      role: map['role']??'',
      userClass: map['class'] ?? '',
      position: map['position'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User{username: $userName, email: $email, role: $role, class: $userClass, position: $position}';
  }
}


