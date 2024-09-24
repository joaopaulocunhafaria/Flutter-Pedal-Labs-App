class Part {
  String? id;
  String? name;
  String? label;
  bool? needRepair;
  int? maxKm;
  int? traveledKm;

  Part({this.id, this.name, this.label, this.maxKm, this.traveledKm}) {
    if (traveledKm! > maxKm!) {
      this.needRepair = true;
    } else {
      this.needRepair = false;
    }
  }

  Part.fromJson(Map<String, dynamic> json, String partId) {
    id = partId;
    name = json['name'];
    label = json['label'];
    needRepair = json['needRepair'];
    maxKm = json['maxKm'];
    traveledKm = json['traveledKm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data['name'] = name;
    data['label'] = label;
    data['needRepair'] = needRepair;
    data['maxKm'] = maxKm;
    data['traveledKm'] = traveledKm;
    return data;
  }

  @override
  String toString() {
    return 'Part{id: $id, name: $name, label: $label, needRepair: $needRepair, maxKm: $maxKm, traveledKm: $traveledKm}';
  }
}
