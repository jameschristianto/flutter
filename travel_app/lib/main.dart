import 'package:flutter/material.dart';
import 'package:travel_app/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bandung Travel',
      theme: ThemeData(),
      home: MainScreen(),
    );
  }
}