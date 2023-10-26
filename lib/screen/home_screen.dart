import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/auth.dart';
import 'package:flutter_text_recognition/core/product/product_data.dart';
import 'package:flutter_text_recognition/text_scanner.dart';

import '../core/User/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userInfo;
  Future<UserModel?> getUser() async {
    try {
      var user = Auth().currentUser;
      final docUser =
          FirebaseFirestore.instance.collection("Users").doc(user!.uid);
      final snapshot = await docUser.get();
      if (snapshot.exists) {
        var userInfo = UserModel.fromFirestore(snapshot.data()!);
        return userInfo;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Auth().currentUser;
    Stream<List<UserModel>> getUserInfo() => FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .asStream()
        .map((event) => [UserModel.fromFirestore(event.data()!)]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.jpg', // Resmin yolu
              fit: BoxFit.contain,
              height: 50,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Auth().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Welcome ",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(snapshot.data![0].name,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text("Email : ${snapshot.data![0].email}",
                      style: TextStyle(fontSize: 24)),
                  Text("Point : ${snapshot.data![0].point.toString()}",
                      style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: productData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.grey[200],
                          leading: Image.asset(
                            productData[index].image,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(productData[index].name),
                          subtitle: Text(
                              " Cost : ${productData[index].point.toString()} points"),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (snapshot.data![0].point >=
                                  productData[index].point) {
                                FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(user!.uid)
                                    .update({
                                  "point": snapshot.data![0].point -
                                      productData[index].point
                                });
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "You don't have enough points to buy this product"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextScanner(
                                      point: snapshot.data![0].point,
                                    )));
                      },
                      child: const Text(
                        'Open Camera to scan',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.jpg', // Resmin yolu
            fit: BoxFit.contain,
            height: 50,
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            print('Sign Out Tıklandı');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
