import 'package:bike/models/bike_model.dart';
import 'package:bike/models/part_model.dart';
import 'package:bike/pages/bikes/add_bike_page.dart';
import 'package:bike/pages/bikes/edit_bike_page.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/services/parts_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PartsPage extends StatefulWidget {
  final Bike bike;
  const PartsPage({Key? key, required this.bike}) : super(key: key);

  @override
  State<PartsPage> createState() => _PartsPageState();
}

class _PartsPageState extends State<PartsPage> {
  late Bike currentBike;

  late PartService partService;

  @override
  void initState() {
    super.initState();
    currentBike = widget.bike;
  }

  @override
  Widget build(BuildContext context) {
    partService = Provider.of<PartService>(context);
    partService.setBikeId(currentBike.id!);

    return Scaffold(
      appBar: const DefaultAppBar(),
      drawer: const DefaultDrawer(),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentBike.label!,
                              style: GoogleFonts.acme(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              currentBike.model!,
                              style: GoogleFonts.acme(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              "KM:" + currentBike.traveledKm!.toString(),
                              style: GoogleFonts.acme(
                                color: Colors.blue,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: FutureBuilder<List<Part>>(
                future: partService.getParts(),
                builder: (context, snapshot) {
                  print("snapshot.data");
                  print(snapshot.data);
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar peças",
                        style: GoogleFonts.acme(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<Part> parts = snapshot.data!;
                    if (parts.isEmpty) {
                      return Center(
                        child: Text(
                          "Você não tem nenhuma peças registrada.",
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
                    return ListView.builder(
                      itemCount: parts.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navegar para outra tela
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
                                            Icons.settings,
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
                                          parts[index].name!,
                                          style: GoogleFonts.acme(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        Text(
                                          parts[index].label!,
                                          style: GoogleFonts.acme(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          "Limit Km:" +
                                              parts[index].maxKm!.toString(),
                                          style: GoogleFonts.acme(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          "Km:" +
                                              parts[index]
                                                  .traveledKm!
                                                  .toString(),
                                          style: GoogleFonts.acme(
                                            color: Colors.blue,
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
                                              onPressed: () => {},
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () => {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                            "Excluir peça?",
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
                                                                            Colors.red),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    partService.deletePart(
                                                                        parts[index]
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
                                                color: Color.fromARGB(
                                                    255, 199, 97, 89),
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
