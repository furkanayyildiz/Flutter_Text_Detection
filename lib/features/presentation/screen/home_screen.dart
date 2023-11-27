import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_text_recognition/features/data/datasources/auth.dart';
import 'package:flutter_text_recognition/core/constants/product_data.dart';
import 'package:flutter_text_recognition/features/data/datasources/remote_data_source.dart';
import 'package:flutter_text_recognition/features/presentation/bloc/user_bloc.dart';
import 'package:flutter_text_recognition/features/presentation/widget/custom_elevated_button.dart';
import 'package:flutter_text_recognition/features/presentation/widget/text_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../data/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    //getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Auth().currentUser;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
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
              PopupMenuButton(
                  icon: Icon(Icons.person_2_rounded, color: Colors.white),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("My Account"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Exit"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      Navigator.pushNamed(context, '/profile');
                    } else if (value == 1) {
                      context.read<UserBloc>().add(const LogoutEvent());
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: StreamBuilder<List<UserModel>>(
              stream: RemoteDataSource().getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text("Opportunities",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Text(
                        //       "Welcome ",
                        //       style: TextStyle(
                        //           fontSize: 30, fontWeight: FontWeight.bold),
                        //     ),
                        //     Text(snapshot.data![0].name,
                        //         style: TextStyle(
                        //             fontSize: 30, fontWeight: FontWeight.bold)),
                        //   ],
                        // ),
                        // Text("Email : ${snapshot.data![0].email}",
                        //     style: TextStyle(fontSize: 24)),
                        // Text("Point : ${snapshot.data![0].point.toString()}",
                        //     style: TextStyle(fontSize: 24)),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: productData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.grey.shade50,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        productData[index].image,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                        ),
                                        child: Text(
                                          productData[index].name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow),
                                          SizedBox(width: 4),
                                          Text(
                                            '${productData[index].point}', // Puan
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      CustomElevatedButton(
                                        title: "Get Product",
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
                                            successAlert(context).show();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "You don't have enough points to buy this product"),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                            // return Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: ListTile(
                            //     tileColor: Colors.grey[200],
                            //     leading: Image.asset(
                            //       productData[index].image,
                            //       width: 50,
                            //       height: 50,
                            //     ),
                            //     title: Text(productData[index].name),
                            //     subtitle: Text(
                            //         " Cost : ${productData[index].point.toString()} points"),
                            //     trailing: IconButton(
                            //       icon: Icon(Icons.add),
                            //       onPressed: () {
                            //         if (snapshot.data![0].point >=
                            //             productData[index].point) {
                            //           FirebaseFirestore.instance
                            //               .collection("Users")
                            //               .doc(user!.uid)
                            //               .update({
                            //             "point": snapshot.data![0].point -
                            //                 productData[index].point
                            //           });
                            //           setState(() {});
                            //           Alert(
                            //             context: context,
                            //             type: AlertType.success,
                            //             title: "Congratulations",
                            //             desc: "You got the product",
                            //             buttons: [
                            //               DialogButton(
                            //                 child: Text(
                            //                   "OK",
                            //                   style: TextStyle(
                            //                       color: Colors.white, fontSize: 20),
                            //                 ),
                            //                 onPressed: () => Navigator.pop(context),
                            //                 width: 120,
                            //               )
                            //             ],
                            //           ).show();
                            //         } else {
                            //           ScaffoldMessenger.of(context).showSnackBar(
                            //             SnackBar(
                            //               content: Text(
                            //                   "You don't have enough points to buy this product"),
                            //             ),
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                            child: CustomElevatedButton(
                                title: "Open Camera to Scan",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TextScanner(
                                                point: snapshot.data![0].point,
                                              )));
                                })),
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
          ),
        );
      },
    );
  }

  Alert successAlert(BuildContext context) {
    return Alert(
      context: context,
      type: AlertType.success,
      title: "Congratulations",
      desc: "You got the product",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    );
  }
}
