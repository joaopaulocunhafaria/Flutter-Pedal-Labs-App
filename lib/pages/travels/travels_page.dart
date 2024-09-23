import 'package:bike/models/bike_model.dart';
import 'package:bike/services/bike_service.dart';
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
  Future<List<Bike>> getBikeFromDb() async {
    BikeService bikeService = BikeService();
    return await bikeService.getBikes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      drawer: const DefaultDrawer(),
      body: Container(
        decoration: const BoxDecoration(),
        child: Card()
      ),
      bottomNavigationBar: const BottomBar(selectedIndex: 2),
    );
  }
}
