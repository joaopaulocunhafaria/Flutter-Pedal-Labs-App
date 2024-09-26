import 'package:bike/models/bike_model.dart';
import 'package:bike/models/part_model.dart';
import 'package:bike/pages/bikes/bikes_page.dart';
import 'package:bike/pages/parts/part_page.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/services/parts_service.dart';
import 'package:bike/widgets/app_bar.dart';
import 'package:bike/widgets/bottom_navigation_barr.dart';
import 'package:bike/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditPartPage extends StatefulWidget {
  final Bike bike;
  final Part part;
  const EditPartPage({
    Key? key,
    required this.bike,
    required this.part,
  }) : super(key: key);

  @override
  State<EditPartPage> createState() => _EditPartPageState();
}

class _EditPartPageState extends State<EditPartPage> {
  final labelControler = TextEditingController();
  final nameControler = TextEditingController();
  final maxkmControler = TextEditingController();
  final traveledkmControler = TextEditingController();
  late PartService partService;
  late Bike currentBike;
  late Part currentPart;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    currentBike = widget.bike;
    currentPart = widget.part;
    labelControler.text = currentPart.label!;
    nameControler.text = currentPart.name!;
    maxkmControler.text = currentPart.maxKm.toString();
    traveledkmControler.text = currentPart.traveledKm.toString();

  }

  @override
  void dispose() {
    labelControler.dispose();
    nameControler.dispose();
    maxkmControler.dispose();
    traveledkmControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    partService = Provider.of<PartService>(context);
    partService.setBikeId(currentBike.id!);

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
                  Text("Editar Peça",
                      style: GoogleFonts.acme(
                        color: Colors.blue,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      )),
                  const SizedBox(height: 40.0),
                  TextFormField(
                    controller: nameControler,
                    decoration: InputDecoration(
                      label: const Text('Nome'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        gapPadding: 10.0,
                      ),
                      hintText: 'Digite o nome de sua peça',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "O nome de sua peça";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: labelControler,
                    decoration: InputDecoration(
                      label: const Text('Marca'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        gapPadding: 10.0,
                      ),
                      hintText: 'Digite a marca de sua peça',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "A marca de sua peça";
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
                    controller: traveledkmControler,
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
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: maxkmControler,
                    decoration: InputDecoration(
                        label: const Text('Kilometragem Maxima'),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          gapPadding: 10.0,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Quantos Kilometros Pode Rodar";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Part newPart = Part(
                            name: nameControler.text,
                            label: labelControler.text,
                            maxKm: int.parse(maxkmControler.text),
                            traveledKm: double.parse(traveledkmControler.text));
                        await partService.updatePart(widget.part.id!, newPart);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PartsPage(
                              bike: currentBike,
                            ),
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
