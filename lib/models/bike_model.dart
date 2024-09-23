class Bike {
  String? id;
  String? label;
  String? model;
  int? traveledKm; 

  Bike(
      {this.id,
      this.label,
      this.model,
      this.traveledKm});

  Bike.fromJson(Map<String, dynamic> json,String newId) {
    id = newId;
    label = json['label'];
    model = json['model'];
    traveledKm = json['traveledKm'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['model'] = this.model;
    data['traveledKm'] = this.traveledKm;
    
    return data;
  }

  @override
  String toString() {
    return 'Bike{id: $id, label: $label, model: $model, traveledKm: $traveledKm }';
  }
} 