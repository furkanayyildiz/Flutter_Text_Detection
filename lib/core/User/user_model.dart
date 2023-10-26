class UserModel {
  final String name;
  final String phone;
  final String email;
  final String uId;
  final int point;

  UserModel(
      {required this.name,
      required this.phone,
      required this.email,
      required this.uId,
      required this.point});

  static UserModel fromFirestore(Map<String, dynamic> firestore) {
    return UserModel(
        name: firestore['name'],
        phone: firestore['phone'],
        email: firestore['email'],
        uId: firestore['uId'],
        point: firestore['point']);
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'uId': uId,
      'point': point
    };
  }
}
