import 'dart:async';
import 'dart:io';

import 'package:bike/models/bike_model.dart';
import 'package:bike/models/travel_model.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class NewTravelPage extends StatefulWidget {
  final Bike bike;
  const NewTravelPage({Key? key, required this.bike}) : super(key: key);

  @override
  State<NewTravelPage> createState() => _NewTravelPageState();
}

class _NewTravelPageState extends State<NewTravelPage>
    with TickerProviderStateMixin {
  Timer? _timer;
  Position? currentPosition;
  Position? lastPosition;
  Position? position;
  bool isRuning = false;
  double meters = 0;
  double auxiliaryMeters = 0;

  late Bike bike;
  late Travel travel;

  @override
  void initState() {
    super.initState();
    bike = widget.bike;
  }

  void _startRefreshingLocation()async {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await  _getCurrentLocation();
    });
  }

  void _stopRefreshingLocation()async { 

    _timer = Timer.periodic(Duration.zero, (timer) {});
    _timer?.cancel();

    lastPosition = currentPosition;
    position = lastPosition;

    meters = 0;
    auxiliaryMeters = 0;
    sleep(Duration(seconds: 1));
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (erro) {
      position = lastPosition;
      print("Não foi possível obter a localização :");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DefaultDrawer(),
      bottomNavigationBar: const BottomBar(selectedIndex: 2),
      appBar: const DefaultAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text("Viagem com: " + bike.model!,
                  style: GoogleFonts.acme(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  )),
            ),
            Expanded(
                flex: 4,
                child: isRuning
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Distancia em metros: ${isRuning == true ? meters.toStringAsFixed(2) : 0} ',
                              style: GoogleFonts.acme(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              )),
                         
                        ],
                      )
                    : Center()),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: isRuning
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : Colors.white),
                  margin: EdgeInsets.all(10),
                  child: IconButton(
                    icon: isRuning
                        ? const Icon(
                            Icons.stop,
                            color: Color.fromARGB(255, 255, 0, 0),
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Colors.blue,
                          ),
                    onPressed: () async{
                      if (isRuning) {
                        //termina a corrida
                        _stopRefreshingLocation();
                        setState(() {
                          isRuning = false;
                        });
                        return;
                      }
                      if (!isRuning) {
                        //comeca a corrida
                        _startRefreshingLocation();

                        setState(() {
                          isRuning = true;
                        });
                        return;
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
