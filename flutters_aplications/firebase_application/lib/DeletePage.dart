import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  List<dynamic>? dados;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() {
    FirebaseFirestore.instance.collection("temparuture").snapshots().listen((
      snapshot,
    ) {
      final data = snapshot.docs;
      setState(() {
        dados = data;
      });
    });
  }

  Future<void> deleteValue(String id) async {
    await FirebaseFirestore.instance.collection("temparuture").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Tela Delete")),
        body: dados == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: dados?.length,
                itemBuilder: (context, index) {
                  final item = dados![index];

                  return ListTile(
                    title: Text("Temperatura do banco:"),
                    subtitle: Text("${item["temperature"]}"),
                    trailing: GestureDetector(
                      child: Icon(Icons.remove),
                      onTap: () {
                        deleteValue(item.id);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
