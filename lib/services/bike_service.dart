import 'package:bike/models/bike_model.dart';
import 'package:bike/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike/services/log_service.dart';

class BikeException implements Exception {
  String message;
  BikeException(this.message);
}

class BikeService extends ChangeNotifier {
  List<Bike>? bike;
  LogService ls = LogService();

  AuthService? _authService;

  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  _getBikes() async {
    bike = await getBikes();
  }

  _setBikes(List<Bike> bikes) {
    bike = bikes;
    notifyListeners();
  }

  Future<void> addBike(Bike newBike) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? id = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: id).get();

      if (userSnapshot.docs.isNotEmpty) {
        print("Documento encontrado");
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bikes');

        print("Colecao encontrada");

        await bikeCollection.add(newBike.toJson());
        print("Adicioanado com sucesso");

        List<Bike>? bikes;
        QuerySnapshot bikeSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .get();

        bikes = bikeSnapshot.docs.map((doc) {
          return Bike.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        _setBikes(bikes);
      }

      notifyListeners();
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<void> updateBike(String bikeId, Bike updatedBike) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bikes');

        DocumentSnapshot bikeDoc = await bikeCollection.doc(bikeId).get();

        if (bikeDoc.exists) {
          await bikeCollection.doc(bikeDoc.id).update(updatedBike.toJson());

          List<Bike>? bikes;
          QuerySnapshot bikeSnapshot = await db
              .collection("user")
              .doc(userDoc.id)
              .collection('bikes')
              .get();

          bikes = bikeSnapshot.docs.map((doc) {
            return Bike.fromJson(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
          _setBikes(bikes);
          notifyListeners();
        } else {
          print("Bicicleta com ID $bikeId não encontrada.");
        }
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<void> deleteBike(String bikeId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bikes');

        DocumentSnapshot bikeDoc = await bikeCollection.doc(bikeId).get();
        if (bikeDoc.exists) {
          await bikeCollection.doc(bikeId).delete();

          List<Bike>? bikes;
          QuerySnapshot bikeSnapshot = await db
              .collection("user")
              .doc(userDoc.id)
              .collection('bikes')
              .get();

          bikes = bikeSnapshot.docs.map((doc) {
            return Bike.fromJson(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
          _setBikes(bikes);

          notifyListeners();
        } else {
          print("Bicicleta com ID $bikeId não encontrada.");
        }
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<List<Bike>> getBikes() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Bike> bikes = [];

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            await db.collection("user").doc(userDoc.id).collection('bikes');

        QuerySnapshot bikeSnapshot = await bikeCollection.get();

        bikes = bikeSnapshot.docs.map((doc) {
          return Bike.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        _setBikes(bikes);
      } else {
        print("Usuário não encontrado. aqui");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }

    return bikes;
  }

  Future<Bike?> getBikeById(String bikeID) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;
      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        DocumentSnapshot bikeDoc = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeID)
            .get();

        return Bike.fromJson(
            bikeDoc.data() as Map<String, dynamic>, bikeDoc.id);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
    return null;
  }

  Future<void> increaseKm(String bikeId, double km) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;
      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        DocumentSnapshot bikeSnap = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .get();

        DocumentReference bikeDoc = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId);

        Bike bikeToBeUpdated =
            Bike.fromJson(bikeSnap.data() as Map<String, dynamic>, bikeSnap.id);

        ls.log("Old Km", "Testing increase function");
        ls.log(
            bikeToBeUpdated.traveledKm.toString(), "Testing increase function");

        //aumenta a kilometragem da bike
        bikeToBeUpdated.traveledKm = (bikeToBeUpdated.traveledKm ?? 0) + km;

        ls.log("Old Km", "Testing increase function");
        ls.log(
            bikeToBeUpdated.traveledKm.toString(), "Testing increase function");

        //atualiza a bike no banco
        bikeDoc.update(bikeToBeUpdated.toJson());

        //seta as bike apartir da atualizacao
        List<Bike> newBikes = await getBikes();
        _setBikes(newBikes);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
    return null;
  }
}
