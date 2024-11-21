import 'package:bike/models/bike_model.dart';
import 'package:bike/pages/bikes/add_bike_page.dart';
import 'package:bike/pages/bikes/edit_bike_page.dart';
import 'package:bike/pages/parts/part_page.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Bikes extends StatefulWidget {
  const Bikes({Key? key}) : super(key: key);

  @override
  State<Bikes> createState() => _BikesState();
}

class _BikesState extends State<Bikes> {
  late BikeService bikeService;

  @override
  Widget build(BuildContext context) {
    bikeService = Provider.of<BikeService>(context);

    return Scaffold(
      appBar: const DefaultAppBar(),
      drawer: const DefaultDrawer(),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 8,
              child: FutureBuilder<List<Bike>>(
                future: bikeService.getBikes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar bikes",
                        style: GoogleFonts.inter(
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
                          style: GoogleFonts.inter(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    }
                    // ListView baseado no número de bikes
                    return ListView.builder(
                      itemCount: bikes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PartsPage(bike: bikes[index]),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.blueGrey,
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
                                          bikes[index].label!,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        Text(
                                          bikes[index].model!,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          "KM:" +
                                              bikes[index]
                                                  .traveledKm!
                                                  .toString(),
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () => {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditBikePage(
                                                          id: bikes[index].id!,
                                                          km: bikes[index]
                                                              .traveledKm!,
                                                          marca: bikes[index]
                                                              .label!,
                                                          modelo: bikes[index]
                                                              .model!,
                                                        ),
                                                      ),
                                                    )
                                                  },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () => {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                            "Excluir bike?",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0)),
                                                          ),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: const Text(
                                                                      "Cancelar")),
                                                              TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Color.fromARGB(255, 255, 0, 0)),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    bikeService.deleteBike(
                                                                        bikes[index]
                                                                            .id!);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Excluir",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Color.fromARGB(255, 255, 17, 0),
                                              ))
                                        ],
                                      )),
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
                    style: GoogleFonts.inter(
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
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AddBikePage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(selectedIndex: 1),
    );
  }
}
