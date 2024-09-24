import 'package:cloud_firestore/cloud_firestore.dart';

class Travel {
  Timestamp? start;
  Timestamp? end;
  int? duration;
  int? distance;
  String? bikeId;
  String? randomIdentifier;

  Travel(
      {this.start,
      this.end,
      this.duration,
      this.distance,
      this.bikeId,
      this.randomIdentifier});

  Travel.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    duration = json['duration'];
    distance = json['distance'];
    bikeId = json['bikeId'];
    randomIdentifier = json['randomIdentifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    data['bikeId'] = this.bikeId;
    data['randomIdentifier'] = this.randomIdentifier;
    return data;
  }
}
