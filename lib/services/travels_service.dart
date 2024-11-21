import 'package:bike/models/part_model.dart';
import 'package:bike/models/travel_model.dart';
import 'package:bike/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelsException implements Exception {
  String message;
  TravelsException(this.message);
}

class TravelService extends ChangeNotifier {
  List<Travel>? travels;
  AuthService? _authService;

  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  _getTravels() async {
    travels = await getTravels();
  }

  _setTravels(List<Travel> travel) {
    travels = travel;
    notifyListeners();
  }

  Future<void> addTravel(Travel newTravel) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Travel> travel = [];

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? id = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: id).get();

      if (userSnapshot.docs.isNotEmpty) {
        print("Documento encontrado");
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference travelCollection =
            db.collection("user").doc(userDoc.id).collection("travels");

        print("Colecao encontrada");

        await travelCollection.add(newTravel.toJson());
        print("Adicioanado com sucesso");

        QuerySnapshot travelSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection("travels")
            .get();

        travel = travelSnapshot.docs.map((elem) {
          return Travel.fromJson(elem.data() as Map<String, dynamic>);
        }).toList();

        _setTravels(travel);
      }

      notifyListeners();
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<List<Travel>> getTravels() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Travel> travel = [];

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        QuerySnapshot travelSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection("travels")
            .orderBy("start", descending: true)
            .get();

        travel = travelSnapshot.docs.map((elem) {

          return Travel.fromJson(elem.data() as Map<String, dynamic>);
        }).toList();

      
        _setTravels(travel);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }

    return travel;
  }
}
