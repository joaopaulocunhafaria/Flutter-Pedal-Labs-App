import 'dart:async';
import 'package:bike/pages/home/home_page.dart';
import 'package:bike/pages/login/register_user_page.dart';
import 'package:bike/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _verSenha = false;
  double _opacity = 1.0;

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  @override
  void initState() {
    super.initState();
    setFormAction(true);
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

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem Vindo';
        actionButton = 'Login';
        toggleButton = 'Não possui conta? Cadastre-se agora.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login';
      }
    });
  }

  loginComGoogle() {
    try {
      context.read<AuthService>().loginComGoogle();
    } on AuthException catch (e) {
      BuildContext;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.black,
      ));
    }
  }

  login() async {
    try {
      await context
          .read<AuthService>()
          .login(_emailController.text, _senhaController.text);
    } on AuthException catch (e) {
      BuildContext;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.black,
      ));
    }
  }

  registrar() async {
    try {
      await context
          .read<AuthService>()
          .registrar(_emailController.text, _senhaController.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.black));
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text("PEDAL LABS",
                    style:GoogleFonts.acme(
                      color: Colors.blue,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    )),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 1),
                  child:   Text("Bem Vindo",
                      style: GoogleFonts.acme(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.5,
                      )),
                ),
                Padding(
                  //input  do email
                  padding: const EdgeInsets.all(24),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      label: const Text(
                        'e-mail',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'nome@email.com',
                      hintStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0)),
                      prefixIcon: const Icon(Icons.email,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o e-mail corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  //input da  senha
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    obscureText: !_verSenha,
                    controller: _senhaController,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                        label: const Text(
                          'senha',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          // raio do canto arredondado
                          gapPadding: 10.0,
                        ),
                        hintText: 'Digite sua senha',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                        prefixIcon: const Icon(Icons.lock,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _verSenha
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {
                            setState(() {
                              _verSenha = !_verSenha;
                            });
                          },
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe sua senha';
                      } else if (value.length < 8) {
                        return 'Digite uma senha de 8 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        //botao de login
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                            if (auth.usuario != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 26, right: 26),
                              child: Text(
                                actionButton,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                        //botao de cadastro
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RegisterUserPage(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Text(
                                "Cadastrar-se",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.white,
                  height: 60,
                ),
                SignInButton(Buttons.google,
                    onPressed: loginComGoogle, text: "Entrar com o google", elevation: 8,shape: RoundedRectangleBorder( // Adicionando bordas arredondadas
            borderRadius: BorderRadius.circular(10), 
          ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
