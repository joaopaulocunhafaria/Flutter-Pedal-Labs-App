import 'dart:developer' as dev; 

class LogService { 

  log(String message, String name) async {
    dev.log(message, name: name);
   
  }
}
