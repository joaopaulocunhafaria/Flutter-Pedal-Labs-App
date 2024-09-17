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

  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    UserProvider userProvider = UserProvider();
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
      userProvider.updateUser(user);
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
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
      _getUser();
      print(usuario?.email.toString());

      //adicionar usuario no banco de dados
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
    await _auth.signOut();
    _getUser();
  }
}

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }
}
