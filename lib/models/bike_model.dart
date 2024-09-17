class Bike {
  int? id;
  String? marca;
  String? model;
  int? kmPercorridos;
  Roda? roda;
  Roda? quadro;
  Roda? catacra;
  Roda? corrente;
  Roda? coroa;
  Roda? peDeVela;

  Bike(
      {this.id,
      this.marca,
      this.model,
      this.kmPercorridos,
      this.roda,
      this.quadro,
      this.catacra,
      this.corrente,
      this.coroa,
      this.peDeVela});

  Bike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marca = json['marca'];
    model = json['model'];
    kmPercorridos = json['km_percorridos'];
    roda = json['roda'] != null ? new Roda.fromJson(json['roda']) : null;
    quadro = json['quadro'] != null ? new Roda.fromJson(json['quadro']) : null;
    catacra =
        json['catacra'] != null ? new Roda.fromJson(json['catacra']) : null;
    corrente =
        json['corrente'] != null ? new Roda.fromJson(json['corrente']) : null;
    coroa = json['coroa'] != null ? new Roda.fromJson(json['coroa']) : null;
    peDeVela =
        json['peDeVela'] != null ? new Roda.fromJson(json['peDeVela']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['marca'] = this.marca;
    data['model'] = this.model;
    data['km_percorridos'] = this.kmPercorridos;
    if (this.roda != null) {
      data['roda'] = this.roda!.toJson();
    }
    if (this.quadro != null) {
      data['quadro'] = this.quadro!.toJson();
    }
    if (this.catacra != null) {
      data['catacra'] = this.catacra!.toJson();
    }
    if (this.corrente != null) {
      data['corrente'] = this.corrente!.toJson();
    }
    if (this.coroa != null) {
      data['coroa'] = this.coroa!.toJson();
    }
    if (this.peDeVela != null) {
      data['peDeVela'] = this.peDeVela!.toJson();
    }
    return data;
  }
}

class Roda {
  String? nome;
  String? marca;
  bool? necessitaManutencao;
  int? limiteKm;

  Roda({this.nome, this.marca, this.necessitaManutencao, this.limiteKm});

  Roda.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    marca = json['marca'];
    necessitaManutencao = json['necessitaManutencao'];
    limiteKm = json['limiteKm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['marca'] = this.marca;
    data['necessitaManutencao'] = this.necessitaManutencao;
    data['limiteKm'] = this.limiteKm;
    return data;
  }
}