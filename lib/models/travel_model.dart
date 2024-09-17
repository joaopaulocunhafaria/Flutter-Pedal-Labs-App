class Travel {
  String? start;
  String? end;
  int? bikeId;
  int? distance;

  Travel({this.start, this.end, this.bikeId, this.distance});

  Travel.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    bikeId = json['bike_id'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['bike_id'] = this.bikeId;
    data['distance'] = this.distance;
    return data;
  }
}