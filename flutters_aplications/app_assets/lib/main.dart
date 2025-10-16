import 'package:app_assets/tela2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppAssets(),
    );
  }
}

class AppAssets extends StatelessWidget {
  const AppAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tela Assets"),
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset("assets/images/sky2.jpg", width: 500, height: 350   ),

              Text("This is the text with a font of the project", style: TextStyle(fontFamily: "Roboto")),

              Text("This is the text with the library of Google Fonts", style: GoogleFonts.roboto()),

              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Tela2()));
              }, child: Icon(Icons.play_arrow))

            ],
          ),
        ),
      ),
    );
  }
}