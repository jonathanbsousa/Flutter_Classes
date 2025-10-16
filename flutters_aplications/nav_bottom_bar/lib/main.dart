import 'package:flutter/material.dart';
import 'package:nav_bottom_bar/Tela1.dart';
import 'package:nav_bottom_bar/Tela2.dart';
import 'package:nav_bottom_bar/Tela3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavBar(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int i = 0;
  
  void changeIndex(int index) {
    setState(() {
      i = index;
    });
  }

  List<Widget> screens = [
    Tela1(),
    Tela2(),
    Tela3()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens.elementAt(i),
        bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(label: "Tela 1", icon: Icon(Icons.waterfall_chart)),
          BottomNavigationBarItem(label: "Tela 2", icon: Icon(Icons.waterfall_chart_outlined)),
          BottomNavigationBarItem(label: "Tela 3", icon: Icon(Icons.waterfall_chart_rounded)),          
        ],
        currentIndex: i,
        onTap: changeIndex,
        ),
      ),
    );
  }
}