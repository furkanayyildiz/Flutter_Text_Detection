import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_text_recognition/features/presentation/bloc/user_bloc.dart';
import 'package:flutter_text_recognition/features/presentation/screen/register_screen.dart';
import 'package:flutter_text_recognition/features/presentation/widget/custom_gesture_detector.dart';
import 'package:flutter_text_recognition/features/presentation/widget/custom_text_field.dart';

import '../../data/datasources/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await Auth().signInWithEmailAndPassword(email, password);

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
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
                            Text('Email', style: loginTextStyle()),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: "Email",
                              controller: emailController,
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Password',
                              style: loginTextStyle(),
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
                              title: "Log In",
                              onTap: () async {
                                context.read<UserBloc>().add(
                                      LoginEvent(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                                const Duration(milliseconds: 500);
                                state.isLogin
                                    ? Navigator.pushReplacementNamed(
                                        context, '/home')
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Email or Password is wrong"),
                                        ),
                                      );
                              },
                            ),
                            Center(
                              child: TextButton(
                                child: Text(
                                  "Register",
                                  style: loginTextStyle(),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen()),
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
            );
          },
        ),
      ),
    );
  }

  TextStyle loginTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
}
