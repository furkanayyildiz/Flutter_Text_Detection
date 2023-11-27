import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_text_recognition/features/data/datasources/auth.dart';
import 'package:flutter_text_recognition/features/data/models/user_model.dart';

class RemoteDataSource {
  var user = Auth().currentUser;
  Stream<List<UserModel>> getUserInfo() => FirebaseFirestore.instance
      .collection("Users")
      .doc(user!.uid)
      .get()
      .asStream()
      .map((event) => [UserModel.fromFirestore(event.data()!)]);
}
