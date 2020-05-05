import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sturrd_flutter/date_list/list.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final widgetOptions = [
    new DateListPage(),
    Text('Home'),
    Text('Dates Nearby'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Browse')),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home'))
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.pink,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
