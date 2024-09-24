import 'package:bike/models/bike_model.dart';
import 'package:bike/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BikeException implements Exception {
  String message;
  BikeException(this.message);
}

class BikeService extends ChangeNotifier {
  List<Bike>? bike;

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
      int? id = _authService!.dbUser!.id;

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
      int? userId = _authService!.dbUser!.id;

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
      int? userId = _authService!.dbUser!.id;

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
      int? userId = _authService!.dbUser!.id;

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
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }

    return bikes;
  }

  Future<Bike?> getBikeById(String bikeID) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Bike bike;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      int? userId = _authService!.dbUser!.id;

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

        bike =
            Bike.fromJson(bikeDoc.data() as Map<String, dynamic>, bikeDoc.id);
        return bike;
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }
}
