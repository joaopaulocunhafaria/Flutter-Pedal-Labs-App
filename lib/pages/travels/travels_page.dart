import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Travels extends StatefulWidget {
  const Travels({Key? key}) : super(key: key);

  @override
  State<Travels> createState() => _TravelsState();
}

class _TravelsState extends State<Travels> {
 Widget build(BuildContext context) {
      return Scaffold(
        appBar: const DefaultAppBar(),
        drawer: const DefaultDrawer(),
        body:   Container(
          decoration: const BoxDecoration(
            
          ), 
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,

          ),
        ),
        bottomNavigationBar: const BottomBar(selectedIndex: 3),
      );
  }
}