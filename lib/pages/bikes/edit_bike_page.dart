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

class EditBikePage extends StatefulWidget {
  final String marca;
  final String modelo;
  final String id;
  final int km;

  const EditBikePage({
    Key? key,
    required this.marca,
    required this.modelo,
    required this.km,
    required this.id,
  }) : super(key: key);

  @override
  State<EditBikePage> createState() => _EditBikePageState();
}

class _EditBikePageState extends State<EditBikePage> {
  final marcaControler = TextEditingController();
  final modeloControler = TextEditingController();
  final kmControler = TextEditingController();
  late BikeService bikeService;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    marcaControler.text = widget.marca;
    modeloControler.text = widget.modelo;
    kmControler.text = widget.km.toString();

  }

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
                  Text("Editar Bike",
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
                            traveledKm: int.parse(kmControler.text));
                        await bikeService.updateBike(widget.id,newBike);

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
                      'ATUALIZAR',
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
