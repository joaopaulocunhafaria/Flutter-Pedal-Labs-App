import 'package:bike/models/part_model.dart';
import 'package:bike/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PartsException implements Exception {
  String message;
  PartsException(this.message);
}

class PartService extends ChangeNotifier {
  List<Part>? part;
  String? bikeId;
  AuthService? _authService;

  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  setBikeId(String id) {
    bikeId = id;
  }

  _getPart() async {
    part = await getParts();
  }

  _setParts(List<Part> parts) {
    part = parts;
    notifyListeners();
  }

  Future<void> addPart(Part newPart) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? id = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: id).get();

      if (userSnapshot.docs.isNotEmpty) {
        print("Documento encontrado");
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference partCollection = db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts");

        print("Colecao encontrada");

        await partCollection.add(newPart.toJson());
        print("Adicioanado com sucesso");

        List<Part> parts;
        QuerySnapshot partSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts")
            .get();

        parts = partSnapshot.docs.map((part) {
          return Part.fromJson(part.data() as Map<String, dynamic>, part.id);
        }).toList();

        _setParts(parts);
      }

      notifyListeners();
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<void> updatePart(String partId, Part updatedPart) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference partCollection = db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts");

        DocumentSnapshot partDoc = await partCollection.doc(partId).get();

        if (partDoc.exists) {
          await partCollection.doc(partDoc.id).update(updatedPart.toJson());

          List<Part> parts;
          QuerySnapshot partSnapshot = await db
              .collection("user")
              .doc(userDoc.id)
              .collection('bikes')
              .doc(bikeId)
              .collection("parts")
              .get();

          parts = partSnapshot.docs.map((part) {
            return Part.fromJson(part.data() as Map<String, dynamic>, part.id);
          }).toList();

          _setParts(parts);
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

  Future<void> deletePart(String partId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Part> parts;
    print("\n\n\n");
    print("\n\n\n");
    print("Entrou em Delete");
    print(partId);
    print("\n\n\n");
    print("\n\n\n");

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        CollectionReference partCollection = db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts");

        DocumentSnapshot partDoc = await partCollection.doc(partId).get();
        if (partDoc.exists) {
          await partCollection.doc(partId).delete();

          QuerySnapshot partSnapshot = await db
              .collection("user")
              .doc(userDoc.id)
              .collection('bikes')
              .doc(bikeId)
              .collection("parts")
              .get();

          parts = partSnapshot.docs.map((part) {
            return Part.fromJson(part.data() as Map<String, dynamic>, part.id);
          }).toList();

          _setParts(parts);
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

  Future<List<Part>> getParts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Part> parts = [];

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        QuerySnapshot bikeSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts")
            .get();

        parts = bikeSnapshot.docs.map((part) {
          print("part.data()");
          print(part.data());
          return Part.fromJson(part.data() as Map<String, dynamic>, part.id);
        }).toList();

        print("Parts length");
        print(parts.length);
        _setParts(parts);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }

    return parts;
  }

  Future<void> increaseKm(String bikeId, double km) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Part> parts = [];

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        QuerySnapshot bikeSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts")
            .get();

        CollectionReference bikeCollectionReference = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts");

        parts = bikeSnapshot.docs.map((part) {
          return Part.fromJson(part.data() as Map<String, dynamic>, part.id);
        }).toList();

        print("Parts length");
        print(parts.length);
        _setParts(parts);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }

  Future<void> updateSinglePartKm(
      String bikeId, String partId, double km) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    late Part part;

    if (_authService!.dbUser != null && _authService!.dbUser!.id != null) {
      String? userId = _authService!.dbUser!.id;

      QuerySnapshot userSnapshot =
          await db.collection('user').where('id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        DocumentSnapshot bikeSnapshot = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts")
            .doc(partId)
            .get();

        DocumentReference bikeDocumentReference = await db
            .collection("user")
            .doc(userDoc.id)
            .collection('bikes')
            .doc(bikeId)
            .collection("parts")
            .doc(partId);

        part = Part.fromJson(
            bikeSnapshot.data() as Map<String, dynamic>, bikeSnapshot.id);

        part.traveledKm = (part.traveledKm ?? 0) + km;

        bikeDocumentReference.update(part.toJson());
        List<Part> newParts = await getParts();
        _setParts(newParts);
      } else {
        print("Usuário não encontrado.");
      }
    } else {
      print("Erro: Usuário não encontrado ou ID inválido.");
    }
  }
}
