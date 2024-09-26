import 'package:bike/models/bike_model.dart';
import 'package:bike/pages/bikes/bikes_page.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddBikePage extends StatefulWidget {
  const AddBikePage({Key? key}) : super(key: key);

  @override
  State<AddBikePage> createState() => _AddBikePageState();
}

class _AddBikePageState extends State<AddBikePage> {
  final marcaControler = TextEditingController();
  final modeloControler = TextEditingController();
  final kmControler = TextEditingController();
  late BikeService bikeService;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    marcaControler.dispose();
    modeloControler.dispose();
    kmControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bikeService = Provider.of<BikeService>(context);

    return Scaffold(
      drawer: const DefaultDrawer(),
      appBar: const DefaultAppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 16, bottom: 16, right: 16, top: 4),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Adicionar nova Bike",
                      style: GoogleFonts.acme(
                        color: Colors.blue,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      )),
                  const SizedBox(height: 40.0),
                  TextFormField(
                    controller: marcaControler,
                    decoration: InputDecoration(
                      label: const Text('Marca'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        gapPadding: 10.0,
                      ),
                      hintText: 'Digite a marca de sua bicicleta',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "A marca de sua bicicleta";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: modeloControler,
                    decoration: InputDecoration(
                      label: const Text('Modelo'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        gapPadding: 10.0,
                      ),
                      hintText: 'Digite o modelo de sua bicicleta',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "O modelo de sua bicicleta";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: kmControler,
                    decoration: InputDecoration(
                        label: const Text('Kilometros Rodados'),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          gapPadding: 10.0,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Quantos Kilometros Rodados";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Bike newBike = Bike(
                            model: modeloControler.text,
                            label: marcaControler.text,
                            traveledKm: double.parse(kmControler.text));
                        await bikeService.addBike(newBike);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Bikes(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'ADICIONAR',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: const BottomBar(selectedIndex: 1),
    );
  }
}
