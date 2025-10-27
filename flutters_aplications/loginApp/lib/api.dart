import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  String? valor;

  @override
  void initState() {
    super.initState();
    getValor();
  }

  void getValor() async {
    final response = await http.get(Uri.parse("https://swapi.dev/api/people/1"));

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        valor = data["name"]; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: valor == null ? Center(child: CircularProgressIndicator()) : 
        Center(child: Text("$valor"),),
      ),
    );
  }
}