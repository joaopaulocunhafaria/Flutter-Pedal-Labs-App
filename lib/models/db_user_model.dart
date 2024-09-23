class DbUser {
  String? name;
  String? email;
  String? cellphone;
  int? traveledKm;
  int? id;

  DbUser({this.name, this.email, this.cellphone, this.traveledKm, this.id});

  DbUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    cellphone = json['cellphone'];
    traveledKm = json['traveledKm'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['cellphone'] = this.cellphone;
    data['traveldKm'] = this.traveledKm;
    data['id'] = this.id;
    return data;
  }

  String toString() {
    return "Name: " + name! + " Email: " + email! + "\n\n\n";
  }
}
