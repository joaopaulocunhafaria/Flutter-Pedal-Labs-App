import 'package:bike/services/auth_service.dart';
import 'package:bike/services/bike_service.dart';
import 'package:bike/widgets/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, BikeService>(
          create: (_) => BikeService(),
          update: (_, authService, bikeService) =>
              bikeService!..setAuthService(authService),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medidor de Deslocamento',
      color: Colors.white,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const AuthCheck(),
    );
  }
}
