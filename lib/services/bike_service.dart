import 'package:bike/models/bike_model.dart';
import 'package:bike/models/db_user_model.dart';
import 'package:bike/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bike');

        await bikeCollection.add(newBike.toJson());

        List<Bike>? bikes;
        QuerySnapshot bikeSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .get();
        bikeSnapshot.docs.map((bike) =>
            {bikes!.add(Bike.fromJson(bike.data() as Map<String, dynamic>))});
        _setBikes(bikes!);
      }

      notifyListeners();
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<void> updateBike(int bikeId, Bike updatedBike) async {
    FirebaseFirestore db = FirebaseFirestore.instance; 

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      int? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bikes');

        QuerySnapshot bikeSnapshot =
            await bikeCollection.where('id', isEqualTo: bikeId).get();

        if (bikeSnapshot.docs.isNotEmpty) {
          DocumentSnapshot bikeDoc = bikeSnapshot.docs.first;

          await bikeCollection.doc(bikeDoc.id).update(updatedBike.toJson());

          List<Bike>? bikes;
          QuerySnapshot snapshot = await db
              .collection("user")
              .doc(userDoc.id)
              .collection('bikes')
              .get();

          snapshot.docs.map((bike) =>
              {bikes!.add(Bike.fromJson(bike.data() as Map<String, dynamic>))});
          _setBikes(bikes!);
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

  Future<void> deleteBike(int idBike) async {
    FirebaseFirestore db = FirebaseFirestore.instance; 

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      int? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bikes');

        QuerySnapshot bikeSnapshot =
            await bikeCollection.where('id', isEqualTo: idBike).get();

        if (bikeSnapshot.docs.isNotEmpty) {
          DocumentSnapshot bikeDoc = bikeSnapshot.docs.first;

          await bikeCollection.doc(bikeDoc.id).delete();

          List<Bike>? bikes;
          QuerySnapshot snapshot = await db
              .collection("user")
              .doc(userDoc.id)
              .collection('bikes')
              .get();
          snapshot.docs.map((bike) =>
              {bikes!.add(Bike.fromJson(bike.data() as Map<String, dynamic>))});
          _setBikes(bikes!);

          notifyListeners();
        } else {
          print("Bicicleta com ID $idBike não encontrada.");
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

    var userProvid = _authService!.usuario;
    print("User DB: $userProvid ");
    print("\n\n\n");
    print("\n\n\n");
    print(_authService!.dbUser);
    print("\n\n\n");
    print("\n\n\n");

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      int? userId = _authService!.dbUser!.id;

      print("User ID: $userId ");
      print("\n\n\n");

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference bikeCollection =
            db.collection("user").doc(userDoc.id).collection('bikes');

        QuerySnapshot bikeSnapshot = await bikeCollection.get();

        bikes = bikeSnapshot.docs.map((doc) {
          return Bike.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        print("\n\n\n");

        print("bikes");
        print(bikes);
        print("\n\n\n");

        _setBikes(bikes);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }

    return bikes;
  }
}
