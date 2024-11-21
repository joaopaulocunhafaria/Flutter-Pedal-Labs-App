import 'package:bike/models/db_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? usuario;
  DbUser? dbUser;

  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) async {
      usuario = (user == null) ? null : user;

      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() async {
    if (_auth.currentUser != null) {
      usuario = _auth.currentUser;

      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot result = await db
          .collection('user')
          .where('email', isEqualTo: usuario!.email)
          .get();
      if (result.docs.isEmpty) {
        // Se o usuário não existir no Firestore, adiciona
        DocumentReference newUser = await db.collection('user').add({
          'email': usuario!.email,
          'name': usuario!.displayName,
          'cellphone': '',
          'traveledKm': 0
        });
        String id = newUser.id;
        
        await newUser.update({
          'email': usuario!.email,
          'name': usuario!.displayName,
          'cellphone': '',
          'traveledKm': 0,
          'id': id
        });
      }
      if (usuario != null) {
        
        DbUser? newDbUser = await dbUserFromUser(usuario);
        
        if (newDbUser != null) {
          dbUser = newDbUser;
        }
      }
    }

    notifyListeners();
  }

  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      await _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Esse email já está cadastrado.');
      }
    }
  }

  loginComGoogle() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(_googleAuthProvider);

      await _getUser();

    } catch (e) {
      print(e);
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      _getUser();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      //Adicionar possíveis erros de login
      switch (e.code) {
        case "user-not-found":
          throw AuthException('Email não encontrado. Cadastre-se.');
        case "wrong-password":
          throw AuthException('Senha incorreta. Tente novamente!');
        case "INVALID_LOGIN_CREDENTIALS":
          throw AuthException('Credencias Invalidas!');
        default:
      }
    }
  }

  logout() async {
    dbUser = null;
    await _auth.signOut();
    _getUser();
  }

  Future<DbUser?> dbUserFromUser(User? currentUser) async {
    String? email = currentUser!.email;

    Map<String, dynamic> dbUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot result =
        await db.collection('user').where('email', isEqualTo: email).get();

    late String userId;

    if (result.docs.length == 1) {
      dbUser = result.docs.map((doc) {
        userId = doc.id;
        return doc.data() as Map<String, dynamic>;
      }).toList()[0];

      String? name = dbUser['name'];
      String? cellphone = dbUser['cellphone'];
      int? traveledKm = dbUser['traveledKm'];
      String? id = userId;

      print("USER BANCO DE DADOS: \n");
      print("Name: $name");
      print("Cellphone: $cellphone");
      print("Traveled Km: $traveledKm");
      print("Email: $email");
      print("ID: $id");
      print("\n\n\n");

      return DbUser(
          name: name ?? "",
          cellphone: cellphone,
          traveledKm: traveledKm,
          email: email,
          id: id);
    }
    return null;
  }
}
