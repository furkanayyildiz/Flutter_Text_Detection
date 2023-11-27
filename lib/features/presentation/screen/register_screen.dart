import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/features/presentation/screen/login_screen.dart';
import 'package:flutter_text_recognition/features/presentation/widget/custom_gesture_detector.dart';
import 'package:flutter_text_recognition/features/presentation/widget/custom_text_field.dart';

import '../../data/datasources/auth.dart';
import '../../data/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> createUserWithEmailAndPassword(
    String name,
    String email,
    String phone,
  ) async {
    try {
      var user = await Auth().createUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      final docUser =
          FirebaseFirestore.instance.collection("Users").doc(user.uid);
      final userModel = UserModel(
          name: name, email: email, phone: phone, uId: user.uid, point: 50);
      final toFirestoreUser = userModel.toFirestore();
      await docUser.set(toFirestoreUser);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              child: Image.asset('assets/images/logo.jpg'),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name-Surname',
                          style: registerTextStyle(),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Name-Surname",
                          controller: nameController,
                          icon: Icons.person,
                        ),
                        Text(
                          'Phone',
                          style: registerTextStyle(),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Phone",
                          controller: phoneController,
                          icon: Icons.phone,
                        ),
                        Text(
                          'Email',
                          style: registerTextStyle(),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Email",
                          controller: emailController,
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Password',
                          style: registerTextStyle(),
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: "Password",
                          controller: passwordController,
                          obscureText: true,
                          icon: Icons.lock,
                        ),
                        const SizedBox(height: 35),
                        CustomGestureDetector(
                          title: "Register",
                          onTap: () async {
                            await createUserWithEmailAndPassword(
                              nameController.text,
                              emailController.text,
                              phoneController.text,
                            );
                          },
                        ),
                        Center(
                          child: TextButton(
                            child: Text("Log In", style: registerTextStyle()),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle registerTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
}
