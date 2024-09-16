import 'package:flutter/material.dart';
import 'package:bike/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medidor de Deslocamento',
      color: Colors.white,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MainScreen(),
    );
  }
}
