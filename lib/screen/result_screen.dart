import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResultScreen extends StatefulWidget {
  final String text;
  ResultScreen({Key? key, required this.text}) : super(key: key);

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
    for (String word in searchedTexts) {
      if (mainText.contains(word)) {
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
              ElevatedButton(
                onPressed: () {
                  aramaYap();
                  isFinded
                      ? getAlert(context, "pozitif", "kelime bulundu",
                              AlertType.success)
                          .show()
                      : getAlert(context, "negatif", "kelime bulunamadi",
                              AlertType.error)
                          .show();
                },
                child: Text('Collect Points'),
              ),
              SizedBox(height: 20),
              Text("OR ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(onPressed: () {}, child: Text('Recapture'))
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
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    );
  }
}
