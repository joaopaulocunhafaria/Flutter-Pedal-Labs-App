import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BikeException implements Exception {
  String message;
  BikeException(this.message);
}

class BikeService extends ChangeNotifier { 
  

  _getBikes() {
     
    notifyListeners();
  }

      
}

class BikeProvider with ChangeNotifier {
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
