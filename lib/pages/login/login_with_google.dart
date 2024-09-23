import 'dart:async';
import 'package:bike/pages/home/home_page.dart';
import 'package:bike/pages/login/login_page.dart';
import 'package:bike/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gif/gif.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  double _opacity = 1.0;

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  @override
  void initState() {
    super.initState();
    _startFadeAnimation();
  }

  void _startFadeAnimation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        // Alterna a opacidade entre 1 (visível) e 0 (invisível)
        _opacity = _opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  loginComGoogle() async {
    try {
      await context.read<AuthService>().loginComGoogle();

      print("\n\n");
      print("\n\n");
      print("context.read<AuthService>().usuario");
      print("\n\n");
      print("\n\n");
      if (context.read<AuthService>().usuario != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on AuthException catch (e) {
      BuildContext;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.black,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("PEDAL LABS",
                    style: GoogleFonts.acme(
                      color: Colors.blue,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    )),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 1),
                  child: Text("Bem Vindo",
                      style: GoogleFonts.acme(
                        color: Colors.blue,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.5,
                      )),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.white,
                  height: 60,
                ),
                const Image(
                  image: AssetImage("assets/biking.gif"),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.white,
                  height: 60,
                ),
                Container(
                  width: 300,
                  height: 50,
                  child: SignInButton(
                    Buttons.google,
                    onPressed: () async {
                      await loginComGoogle();
                    },
                    text: "Entrar com o google",
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      // Adicionando bordas arredondadas
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.white,
                  height: 30,
                ),
                Container(
                  width: 300,
                  height: 50,
                  child: SignInButton(
                    Buttons.email,
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      )
                    },
                    text: "Entra com Email",
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      // Adicionando bordas arredondadas
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
