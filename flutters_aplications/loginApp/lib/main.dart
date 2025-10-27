import 'package:flutter/material.dart';
import 'package:loginapp/api.dart';
import 'package:loginapp/apiAll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();

  String correctUser = 'takashi';
  String correctPassword = 'azumi';
  String erro = '';

  void Login(){
    if(user.text == correctUser && password.text == correctPassword){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ApiPage()));

      setState(() {
        erro = '';
      });
    } else {
      setState(() {
        erro = "Existem credenciais incorretas";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Icon(Icons.person, size: 150),
              TextField(
                controller: user,
                decoration: InputDecoration(
                  hintText: 'Insira aqui o seu nome de usuário'
                ),
              ),

              TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Insira aqui a sua senha'
                ),
                obscureText: true,
              ),

              ElevatedButton(onPressed: Login, child: Text("Logar")),
              ElevatedButton(onPressed: (){
                Navigator.push(context,
                 MaterialPageRoute(builder: (context) => ApiAllPage())
                 );
              }, child: Text("Api All")),
              Text("$erro")
            ],
          ),
        ),
      ),
    );
  }
}
