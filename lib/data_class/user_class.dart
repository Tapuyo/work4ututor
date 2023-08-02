class Users {
  final String? uid;
  final String role;

  Users({required this.uid, required this.role});
}

class UserData {
  final String uid;
  final String email;
  final String password;
  final String role;
  UserData({
    required this.uid,
    required this.email,
    required this.password,
    required this.role,
  });
}
