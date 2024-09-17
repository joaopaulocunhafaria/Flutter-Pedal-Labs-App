import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:flutter/material.dart';

class Bikes extends StatefulWidget {
  const Bikes({Key? key}) : super(key: key);

  @override
  State<Bikes> createState() => _BikesState();
}

class _BikesState extends State<Bikes> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: const DefaultAppBar(),
        body:   Container(
          decoration: const BoxDecoration(
            
          ), 
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,

          ),
        ),
        bottomNavigationBar: const BottomBar(selectedIndex: 1),
      );
  }
}