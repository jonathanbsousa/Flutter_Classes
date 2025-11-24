import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PutPage extends StatefulWidget {
  const PutPage({super.key});

  @override
  State<PutPage> createState() => _PutPageState();
}

class _PutPageState extends State<PutPage> {

  Map<String, TextEditingController> controllers = {};
  List<dynamic>? values;


  @override
  void initState() {
    super.initState();
    getValues();

  }

  void getValues() {
    FirebaseFirestore.instance.collection("temparuture").snapshots().listen(
      (snapshots) {
        final data = snapshots.docs;

        setState(() {
          values = data;
          for(dynamic doc in data) {
            controllers[doc.id] = TextEditingController();
          }
        });
      }
    );
  }

  Future<void> putValue(String id) async {
    FirebaseFirestore.instance.collection("temparuture").doc(id).set({
      "temperature": controllers[id]!.text,
  });
  }

  @override
  void dispose() {
    for(dynamic value in controllers.values) {
      value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Pagina PUT"),),
        body: values == null ? Center(child: CircularProgressIndicator(),) : 
        ListView.builder(
          itemCount: values!.length,
          itemBuilder: (context, index) {
            final item = values![index];
            return ListTile(
              title: Text("Teperatura atual ${item["temperature"]}"),
              subtitle: Column(
                children: [
                  TextField(
                    controller: controllers[item.id],
                  ),
                  ElevatedButton(onPressed: () {putValue(item.id);}, child: Text("Enviar"))
                ],
              ),
            );
          }   
        )
      ),
    );
  }
}