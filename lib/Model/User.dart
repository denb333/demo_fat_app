class User {
  final String userName;
  final String userClass;
  final String position;

  User({
    required this.userName,
    required this.userClass,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': userName,
      'class': userClass,
      'position': position,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userName: map['username'] ?? '',
      userClass: map['class'] ?? '',
      position: map['position'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User{username: $userName, class: $userClass, position: $position}';
  }
}
