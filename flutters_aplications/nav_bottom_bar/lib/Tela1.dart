import 'package:flutter/material.dart';

class Tela1 extends StatefulWidget {
  const Tela1({super.key});

  @override
  State<Tela1> createState() => _Tela1State();
}

class _Tela1State extends State<Tela1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF2F5C73),
        title: Text(
          "Ocean",
          style: TextStyle(
            fontSize: 30
          ),
          ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Tela 1")
          ],
        ),
      ),
    );
  }
}