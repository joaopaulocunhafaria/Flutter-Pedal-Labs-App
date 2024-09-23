class Part {
  String? id;
  String? name;
  String? label;
  bool? needRepair;
  int? maxKm;
  int? traveledKm;

  Part(
      {this.id,
      this.name,
      this.label,
      this.needRepair,
      this.maxKm,
      this.traveledKm});

  Part.fromJson(Map<String, dynamic> json, String partId) {
    id = partId;
    name = json['name'];
    label = json['label'];
    needRepair = json['needRepair'];
    maxKm = json['maxKm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data['name'] = name;
    data['label'] = label;
    data['needRepair'] = needRepair;
    data['maxKm'] = maxKm;
    return data;
  }
}
