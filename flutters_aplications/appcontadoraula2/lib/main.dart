import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); //Roda a aplicação 
  //precisa ter 

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int numero = 0;

  void aumentar(){
    setState(() { //Muda o estado da variavel 
      numero++;
    });
  }

  void diminuir(){
    setState(() {
      numero--;
    });
  }

  void resetar(){
    setState(() {
      numero = 0;
    });
  
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title:Text("App Contador do Vini",
        style: TextStyle(color: Colors.white)),
        centerTitle: true, //deixo o titulo no centro 
        backgroundColor: Colors.blue, //muda a cor de fundo
        toolbarHeight: 180, //aumenta o tamanho da appbar
        ) ,
        body: Center( //deixa tudo centralizado
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${numero.toInt()}",style: TextStyle(fontSize: 70)),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                  onPressed: (){
                  aumentar();
                }, child: Text("Aumentar")),
                SizedBox(width: 20),
                ElevatedButton(onPressed: (){
                  diminuir();
                }, child: Text("Diminuir")),
                SizedBox(width: 20),
                ElevatedButton(onPressed: (){
                  resetar();
                }, child: Text("Resetar")),
                
              ],)

            ],
          )


        )
      )
    );
  }
}