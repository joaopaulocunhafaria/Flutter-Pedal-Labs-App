import 'package:bike/models/bike_model.dart';
import 'package:bike/models/travel_model.dart';
import 'package:bike/pages/travels/new_travel_page.dart';
import 'package:bike/pages/travels/travel_info_page.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/services/travels_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Travels extends StatefulWidget {
  const Travels({Key? key}) : super(key: key);

  @override
  State<Travels> createState() => _TravelsState();
}

class _TravelsState extends State<Travels> {
  late TravelService travelService;
  late BikeService bikeService;
  Widget build(BuildContext context) {
    travelService = Provider.of<TravelService>(context);
    bikeService = Provider.of<BikeService>(context);

    return Scaffold(
      appBar: const DefaultAppBar(),
      drawer: const DefaultDrawer(),
      body: Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Center(
                      child: Text("Histórico de Viagens",
                          style: GoogleFonts.acme(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          )),
                    ),
                  )),
              Expanded(
                flex: 8,
                child: FutureBuilder<List<Travel>>(
                  future: travelService.getTravels(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erro ao carregar viagens",
                          style: GoogleFonts.acme(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<Travel> travels = snapshot.data!;
                      if (travels.isEmpty) {
                        return Center(
                          child: Text(
                            "Você não tem nenhuma viagem registrada.",
                            style: GoogleFonts.acme(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: travels.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              Bike? bike = await bikeService
                                  .getBikeById(travels[index].bikeId!);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => TravelInfo(
                                    travel: travels[index],
                                    bike: bike!,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              margin: const EdgeInsets.all(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            DateFormat("dd/MM/yyyy").format(
                                                travels[index].start!.toDate()),
                                            style: GoogleFonts.acme(
                                              color: Colors.blue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          Text(
                                            travels[index]
                                                    .distance!
                                                    .toString() +
                                                " Km Percorridos",
                                            style: GoogleFonts.acme(
                                              color: Colors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    // Caso nenhum dado esteja disponível
                    return Center(
                        child: Text(
                      "Nenhum dado disponível.",
                      style: GoogleFonts.acme(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1.2,
                      ),
                    ));
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.blue),
                    margin: EdgeInsets.all(10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Center(
                              child: Text(
                                "Escolha uma bike!",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                            actions: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    FutureBuilder<List<Bike>>(
                                      future: bikeService.getBikes(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              "Erro ao carregar bikes",
                                              style: GoogleFonts.acme(
                                                color: Colors.blue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          List<Bike> bikes = snapshot.data!;
                                          if (bikes.isEmpty) {
                                            return Center(
                                              child: Text(
                                                "Você não tem nenhuma bike registrada.",
                                                style: GoogleFonts.acme(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            );
                                          }
                                          // ListView baseado no número de bikes
                                          return Container(
                                            width: 250,
                                            height: 400,
                                            child: ListView.builder(
                                              itemCount: bikes.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewTravelPage(
                                                          bike: bikes[index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Card(
                                                    elevation: 8,
                                                    margin:
                                                        const EdgeInsets.all(12),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                              flex: 2,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .pedal_bike_sharp,
                                                                    size: 40,
                                                                  ),
                                                                ],
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  bikes[index]
                                                                      .label!,
                                                                  style:
                                                                      GoogleFonts
                                                                          .acme(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        2,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  bikes[index]
                                                                      .model!,
                                                                  style:
                                                                      GoogleFonts
                                                                          .acme(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "KM:" +
                                                                      bikes[index]
                                                                          .traveledKm!
                                                                          .toString(),
                                                                  style:
                                                                      GoogleFonts
                                                                          .acme(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        // Caso nenhum dado esteja disponível
                                        return Center(
                                            child: Text(
                                          "Nenhum dado disponível.",
                                          style: GoogleFonts.acme(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -1.2,
                                          ),
                                        ));
                                      },
                                    ),
                                 
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          )),
      bottomNavigationBar: const BottomBar(selectedIndex: 2),
    );
  }
}
