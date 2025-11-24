import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'DeletePage.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  
  TextEditingController novaTemperatura = TextEditingController();

  @override
  void initState() {
    super.initState();
    postValue();
  }

  String? erro;
  Future<void> postValue() async {
    try {
      FirebaseFirestore.instance.collection("temparuture").add(
        {
          "temperature": novaTemperatura.text
        }
      );
    } catch (e) {
      setState(() {
        erro = "Erro ao enviar dados";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Teste"),),
        body: Center(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Text("Insira a temperatura dessejada"),
                    TextField(
                      controller: novaTemperatura,
                    ),
                    ElevatedButton(onPressed: postValue, child: Text("Enviar Dados")),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeletePage()));
                    }, child: Text("Delete Page"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}