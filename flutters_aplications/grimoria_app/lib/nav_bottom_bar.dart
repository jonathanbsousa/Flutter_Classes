import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  ];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens.elementAt(i),
        bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(label: "", icon: Icon(Icons.waterfall_chart)),
          BottomNavigationBarItem(label: "", icon: Icon(Icons.waterfall_chart_outlined)),
          BottomNavigationBarItem(label: "", icon: Icon(Icons.waterfall_chart_rounded))
        ],
        currentIndex: i,
        onTap: changeIndex,        
        ),
      ),
    );
  }
}