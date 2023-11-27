import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_text_recognition/features/presentation/bloc/user_bloc.dart';
import 'package:flutter_text_recognition/features/presentation/screen/home_screen.dart';
import 'package:flutter_text_recognition/features/presentation/screen/login_screen.dart';
import 'package:flutter_text_recognition/features/presentation/screen/profile_screen.dart';
import 'package:flutter_text_recognition/features/presentation/screen/register_screen.dart';
import 'package:flutter_text_recognition/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Text Recognition App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WidgetTree(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          "/profile": (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
