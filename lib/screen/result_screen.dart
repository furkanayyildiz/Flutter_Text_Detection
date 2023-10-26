import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../auth.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String text;
  final int point;
  ResultScreen({Key? key, required this.text, required this.point})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String mainText = "";
  List<String> searchedTexts = ["Prima", "Orkid", "Gillette"];
  String resultText = "";
  bool isFinded = false;
  @override
  void initState() {
    mainText = widget.text;
    super.initState();
  }

  void aramaYap() {
    var user = Auth().currentUser;
    for (String word in searchedTexts) {
      if (mainText.contains(word)) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .update({'point': widget.point + 10});
        setState(() {
          resultText = "aranan kelimeler var";
          isFinded = true;
        });
        return;
      }
    }
    setState(() {
      resultText = "aranan kelimeler yok";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Recognition Sample'),
      ),
      body: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              //SingleChildScrollView(child: Text(widget.text)),
              Image.asset("assets/images/completed_photo.jpg"),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "We processed your image, now you can collect your points",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  aramaYap();
                  isFinded
                      ? getAlert(context, "Congratulations",
                              "You got 10 points", AlertType.success)
                          .show()
                      : getAlert(context, "Sorry", "You got 0 points",
                              AlertType.error)
                          .show();
                },
                child: Text('Collect Points'),
              ),
            ],
          )),
    );
  }

  Alert getAlert(
      BuildContext context, String title, String desc, AlertType type) {
    return Alert(
      context: context,
      type: type,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())),
          width: 120,
        )
      ],
    );
  }
}
