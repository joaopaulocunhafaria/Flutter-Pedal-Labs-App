//OLá Daniel
// modificaçao 2

// import 'dart:js_util';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dart:async';
import 'dart:io';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  bool a = false;
  Position? currentPosition;
  Position? lastPosition;
  Position? position;
  double Meters = 0;
  double auxiliaryMeters = 0;
  Timer? _timer;
  Timer? _timing;
  bool turn = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    // _controller.repeat();
  }

  void _startRefreshingLocation() {
    _controller.repeat();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _getCurrentLocation();
    });
    // _timing = Timer.periodic(Duration(milliseconds: 2300), (timing) {
    //   _getCurrentLocation();
    // });
  }

  void _stopRefreshingLocation() {
    _controller.stop();
    if (Meters > 20) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Alerta!'),
          content: Text('Troque o pneu'),
          actions: [
            TextButton(
              child: Text('Entendi'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    _timer = Timer.periodic(Duration.zero, (timer) {});
    _timer?.cancel();

    // _timing = Timer.periodic(Duration.zero, (timing) {});
    // _timing?.cancel();

    lastPosition = currentPosition;
    position = lastPosition;

    Meters = 0;
    auxiliaryMeters = 0;
    sleep(Duration(seconds: 1));
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (erro) {
      position = lastPosition;
      print("Não foi possível obter a localização :");
      exit(1);
    }

    setState(() {
      lastPosition = currentPosition;
      currentPosition = position;
      auxiliaryMeters = Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          currentPosition!.latitude,
          currentPosition!.longitude);

      if (a == false) {
      } else {
        if ((lastPosition != null) && (auxiliaryMeters < 8.33333)) {
          Meters += 0;
          auxiliaryMeters = 0;
        } else {
          Meters += auxiliaryMeters;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Medidor de Deslocamento',
            style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (currentPosition != null)
              Text(
                'Distancia em metros: ${a == true ? Meters.toStringAsFixed(2) : 0} \n\nLatitude: ${currentPosition!.latitude}\nLongitude: ${currentPosition!.longitude} \n\n segundos: ${_timer!.tick}',
                textAlign: TextAlign.center,
              ),
            RotationTransition(
              turns: _animation,
              child: SizedBox(
                height: 127,
                width: 120,
                child: Image.asset('lib/pics/wheel2.png'),
              ),
            ),
            SizedBox(
                height: 230,
                width: 120,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_timer != null && _timer!.isActive) {
                      _stopRefreshingLocation();
                      a = false;
                    } else {
                      a = true;
                      _startRefreshingLocation();
                    }
                    ;
                  },
                  child: Text(a == true ? 'Parar de localizar' : 'Localizar',
                      style: TextStyle(color: Colors.white)),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _timing?.cancel();
    super.dispose();
  }
}
