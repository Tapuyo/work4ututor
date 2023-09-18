class Users {
  final String? uid;
  final String role;

  Users({required this.uid, required this.role});
}

class UserData {
  final String uid;
  final String email;
  final String status;
  final String role;
  UserData({
    required this.uid,
    required this.email,
    required this.status,
    required this.role,
  });
}
