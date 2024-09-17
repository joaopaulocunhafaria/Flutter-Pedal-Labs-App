import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const DefaultAppBar(),
      body:   Container(
        decoration: const BoxDecoration(
          
        ), 
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,

        ),
      ),
      bottomNavigationBar: const BottomBar(selectedIndex: 0),
      drawer: const DefaultDrawer(),
    );
  }
}
