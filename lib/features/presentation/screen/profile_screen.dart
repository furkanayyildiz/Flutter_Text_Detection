import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/features/data/datasources/auth.dart';
import 'package:flutter_text_recognition/features/data/datasources/remote_data_source.dart';
import 'package:flutter_text_recognition/features/data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: RemoteDataSource().getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          Image.asset('assets/images/user_avatar.png').image,
                    ),
                    SizedBox(height: 20),
                    Text(
                      snapshot.data![index].name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Regular Member',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    profileItem(snapshot.data![index].email, Icons.email),
                    profileItem(snapshot.data![index].phone, Icons.phone),
                    profileItem(
                        "${snapshot.data![index].point.toString()} Points",
                        Icons.star_border),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Auth().signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ListTile profileItem(String title, IconData iconData) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
    );
  }
}
