import 'package:bike/models/bike_model.dart';
import 'package:bike/models/travel_model.dart';
import 'package:bike/pages/bikes/bikes_page.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TravelInfo extends StatefulWidget {
  final Travel travel;
  final Bike bike;
  const TravelInfo({Key? key, required this.travel, required this.bike})
      : super(key: key);

  @override
  State<TravelInfo> createState() => _TravelInfoState();
}

class _TravelInfoState extends State<TravelInfo> {
  late Travel travel;
  late Bike bike;
  late String start;
  late String end;
  late BikeService bikeService;

  @override
  void initState() {
    super.initState();
    travel = widget.travel;
    bike = widget.bike;
    start = DateFormat("dd/MM/yyyy hh:mm a").format(travel.start!.toDate());
    end = DateFormat("dd/MM/yyyy hh:mm a").format(travel.end!.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DefaultDrawer(),
      appBar: const DefaultAppBar(),
      bottomNavigationBar: const BottomBar(selectedIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Informações da Viagem",
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        )),
                    Text("Inicio: " + start,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        )),
                    Text("Fim: " + end,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        )),
                    Text("Duração: " + travel.duration.toString() + " hr",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        )),
                    Text(
                        "Distancia Percorrida: " +
                            travel.distance.toString() +
                            " km",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        )),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Bike Utilizada",
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Bikes(),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.blueGrey,
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.pedal_bike_sharp,
                                        size: 40,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      bike.label!,
                                      style: GoogleFonts.inter(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(
                                      bike.model!,
                                      style: GoogleFonts.inter(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      "KM:" + bike.traveledKm!.toString(),
                                      style: GoogleFonts.inter(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
