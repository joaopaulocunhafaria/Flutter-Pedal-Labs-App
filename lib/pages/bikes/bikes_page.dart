import 'package:bike/models/bike_model.dart';
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



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      drawer: const DefaultDrawer(),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder<List<Bike>>(
                future:
                
                 Provider.of<BikeService>(context).getBikes(),
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Exibe o indicador de carregamento enquanto os dados estão sendo buscados
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
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
                      return ListView.builder(
                        itemCount: bikes.length,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.pedal_bike_sharp),
                                    Text(
                                      bikes[index].marca!,
                                      style: GoogleFonts.acme(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -1.5,
                                      ),
                                    ),
                                    Text(
                                      bikes[index].model!,
                                      style: GoogleFonts.acme(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
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
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(selectedIndex: 1),
    );
  }
}
