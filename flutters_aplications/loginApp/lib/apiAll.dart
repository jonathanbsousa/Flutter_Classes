import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiAllPage extends StatefulWidget {
  const ApiAllPage({super.key});

  @override
  State<ApiAllPage> createState() => _ApiAllPageState();
}

class _ApiAllPageState extends State<ApiAllPage> {
  List<dynamic>? valor;

  @override
  void initState() {
    super.initState();
    getValor();
  }

  void getValor() async {
    final response = await http.get(Uri.parse("https://swapi.dev/api/people"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        valor = data["results"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: valor == null
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: ListView.builder(
                  itemCount: valor!.length,
                  itemBuilder: (context, index) {
                    final item = valor![index];
                    return Stack(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Text("${item["name"]}"),
                                    Text("${item["height"]}"),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(height: 2),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
