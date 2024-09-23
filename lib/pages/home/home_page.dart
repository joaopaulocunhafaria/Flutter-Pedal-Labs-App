import 'package:bike/models/bike_model.dart';
import 'package:bike/models/travel_model.dart';
import 'package:bike/pages/bikes/bikes_page.dart';
import 'package:bike/pages/profile/profile_page.dart';
import 'package:bike/pages/travels/travels_page.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: Container(
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: () => {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Bikes(),
                                ),
                              )
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color:
                                      const Color.fromARGB(255, 232, 225, 225)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.pedal_bike_sharp,
                                    size: 45,
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Color.fromARGB(255, 232, 225, 225),
                                    height: 20,
                                  ),
                                  Text("Bikes",
                                      style: GoogleFonts.acme(
                                        color: Colors.blue,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: () => {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Travels(),
                                ),
                              )
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color:
                                      const Color.fromARGB(255, 232, 225, 225)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.travel_explore,
                                    size: 45,
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Color.fromARGB(255, 232, 225, 225),
                                    height: 20,
                                  ),
                                  Text("Viagens",
                                      style: GoogleFonts.acme(
                                        color: Colors.blue,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 8,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color:
                                    const Color.fromARGB(255, 232, 225, 225)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.settings,
                                  size: 45,
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Color.fromARGB(255, 232, 225, 225),
                                  height: 20,
                                ),
                                Text("Manutenção",
                                    style: GoogleFonts.acme(
                                      color: Colors.blue,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: () => {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Profile(),
                                ),
                              )
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color:
                                      const Color.fromARGB(255, 232, 225, 225)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.supervised_user_circle,
                                    size: 45,
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Color.fromARGB(255, 232, 225, 225),
                                    height: 20,
                                  ),
                                  Text("Perfil",
                                      style: GoogleFonts.acme(
                                        color: Colors.blue,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(selectedIndex: 0),
      drawer: const DefaultDrawer(),
    );
  }
}
