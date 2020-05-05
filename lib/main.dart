import 'package:sturrd_flutter/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sturrd_flutter/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sturrd',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: LoginSignupPage());
  }
}
