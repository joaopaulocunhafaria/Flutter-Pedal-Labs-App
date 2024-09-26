import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bike/models/bike_model.dart';
import 'package:bike/models/part_model.dart';
import 'package:bike/models/travel_model.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/services/parts_service.dart';
import 'package:bike/services/travels_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewTravelPage extends StatefulWidget {
  final Bike bike;
  const NewTravelPage({Key? key, required this.bike}) : super(key: key);

  @override
  State<NewTravelPage> createState() => _NewTravelPageState();
}

class _NewTravelPageState extends State<NewTravelPage>
    with TickerProviderStateMixin {
  late DateTime start;
  late DateTime end;
  int duration = 0;
  Position? currentPosition;
  int counter = 0;
  bool isRuning = false;
  double distance = 0;
  double auxiliaryMeters = 0;

  late Bike bike;
  late Travel travel;

  late TravelService travelService;
  late BikeService bikeService;
  late PartService partService;

  @override
  void initState() {
    super.initState();
    Geolocator.checkPermission().then((value) {
      if (value == LocationPermission.denied) {
        Geolocator.requestPermission().then((value) {
          if (value == LocationPermission.denied) {
            Geolocator.requestPermission().then((value) {
              return Future.error(
                  "Habilite o acesso a localizacao no seu aparelho!");
            });
          }
        });
      }
    });
    bike = widget.bike;
  }

  Future<void> _startRefreshingLocation() async {
    setState(() {
      isRuning = true;
      start = DateTime.now();
    });
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      setState(() {
        distance += 10;
        duration = DateTime.now().difference(start).inMinutes;
        currentPosition = position;
        counter++;
      });
    });
  }

  void _stopRefreshingLocation() async {
    setState(() {
      isRuning = false;
      end = DateTime.now();
    });

    //calcula a distancia total em km
    double distanceInKm = distance / 100;

    //calcula o tempo gasto em hrs
    duration = end.difference(start).inHours;

    //cria um identificador aleatorio
    String randomIdentifier = createRandomIdentifier(15);

//atualiza a viagem local
    Timestamp startTime = Timestamp.fromDate(start);
    Timestamp endTime = Timestamp.fromDate(end);
    travel = Travel(
        start: startTime,
        end: endTime,
        randomIdentifier: randomIdentifier,
        bikeId: bike.id,
        duration: duration,
        distance: distanceInKm);
  }

  String createRandomIdentifier(int tamanho) {
    const String caracteres =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    // Gera uma string com 'tamanho' caracteres aleatórios
    return String.fromCharCodes(Iterable.generate(
      tamanho,
      (_) => caracteres.codeUnitAt(random.nextInt(caracteres.length)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    travelService = Provider.of<TravelService>(context);
    bikeService = Provider.of<BikeService>(context);
    partService = Provider.of<PartService>(context);

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
                          Text('Distancia em metros: $distance ',
                              style: GoogleFonts.acme(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              )),
                          Text('Latitude: ${currentPosition?.latitude}',
                              style: GoogleFonts.acme(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              )),
                          Text('Longitude: ${currentPosition?.longitude}',
                              style: GoogleFonts.acme(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              )),
                          Text('Posicao alterada: $counter vezes',
                              style: GoogleFonts.acme(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              )),
                          Text('Duracao da viagem: $duration min',
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
                    onPressed: () async {
                      if (isRuning) {
                        //termina a corrida
                        _stopRefreshingLocation();
                        //salva no banco
                        await travelService.addTravel(travel);

                        //aumenta os kms na bike e nas pecas usadas.
                        bikeService.increaseKm(bike.id!, distance);
                        partService.increaseKm(bike.id!, distance);

                        //reseta as variaveis
                        clearData();
                        return;
                      }
                      if (!isRuning) {
                        //comeca a corrida
                        await _startRefreshingLocation();

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

  void clearData() {
    duration = 0;
    distance = 0.0;
  }
}
