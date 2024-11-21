import 'dart:async';

import 'package:geolocator/geolocator.dart';

final LocationSettings locationSettings =  LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
  print(position == null
      ? 'Unknown'
      : '${position.latitude.toString()}, ${position.longitude.toString()}');
});