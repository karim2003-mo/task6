import 'package:flutter/material.dart';
import 'package:task6/screens/mainpage.dart';
import 'package:task6/screens/mynote.dart';
import 'package:task6/screens/notepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
'/main': (context) =>MainPage(),
'/main/notes': (context) =>NotePage(),
'/main/notes/mynote': (context) =>MyNote(),

      },
      home:MainPage()
    );
  }
}
