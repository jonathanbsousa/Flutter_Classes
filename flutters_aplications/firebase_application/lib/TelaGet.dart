import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'PostPage.dart';

class TelaGet extends StatefulWidget {
  const TelaGet({super.key});

  @override
  State<TelaGet> createState() => _TelaGetState();
}

class _TelaGetState extends State<TelaGet> {
  String? temperatura;

  @override
  void initState() {
    super.initState();
    getValue();
  }

  void getValue() {
    FirebaseFirestore.instance.collection("temparuture").snapshots().listen((
      snapshot,
    ) {
      final data = snapshot.docs.first.data();
      setState(() {
        temperatura = data["temperature"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("App Bar")),
        body: Center(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Text("Essa é sua temperatura do banco: "),
                    Text("$temperatura"),

                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage()));
                    }, child: Text("Ir para POST"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
