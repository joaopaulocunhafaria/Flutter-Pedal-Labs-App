class Part {
  String? nome;
  String? marca;
  bool? necessitaManutencao;
  int? limiteKm;

  Part(
      {this.nome, this.marca, this.necessitaManutencao, this.limiteKm});

  Part.fromJson(Map<String, dynamic> json) {
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
