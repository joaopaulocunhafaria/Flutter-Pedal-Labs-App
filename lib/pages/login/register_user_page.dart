import 'package:bike/pages/home/home_page.dart';
import 'package:bike/pages/login/login_page.dart';
import 'package:bike/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  var telefoneController = MaskedTextController(mask: '(00) 00000-0000');

  bool _verSenha = false;

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Crie sua conta';
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

  registrar() async {
    try {
      await context
          .read<AuthService>()
          .registrar(_emailController.text, _senhaController.text);
      if (context.read<AuthService>().usuario != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
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
                Text(titulo,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                    )),
                Padding(
                  //input  do email
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, bottom: 5, top: 5),
                  child: TextFormField(
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: const Text(
                        'Digite seu e-mail',
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
                        // raio do canto arredondado
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
                      vertical: 6.0, horizontal: 24.0),
                  child: TextFormField(
                    obscureText: !_verSenha,
                    controller: _senhaController,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                        label: const Text(
                          'Digite sua senha',
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
                        hintText: 'Sua senha',
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
                  //input do nome
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: _nomeController,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      label: const Text(
                        'Digite seu nome',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // raio do canto arredondado
                        gapPadding: 10.0,
                      ),
                      hintText: 'Seu nome',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                      prefixIcon: const Icon(FontAwesomeIcons.user,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe seu nome';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  //input do telefone
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: telefoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      label: const Text(
                        'Digite seu telefone',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // raio do canto arredondado
                        gapPadding: 10.0,
                      ),
                      hintText: 'Seu telefone',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                      prefixIcon: const Icon(Icons.phone,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
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
                                const Color.fromARGB(255, 255, 255, 255),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
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
                                    fontSize: 16, color: Colors.blue),
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
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await registrar();
                            if (auth.usuario != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          }
                          print("Clicou em cadastrar");
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
                                    color: Color.fromARGB(255, 255, 255, 255)),
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
                InkWell(
                  onTap: () async {
                    await loginComGoogle();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(
                                0.9), // Cor da sombra com opacidade
                            spreadRadius: 2, // Raio de propagação
                            blurRadius: 5, // Raio de desfoque
                            offset: Offset(
                                0, 3), // Deslocamento horizontal e vertical
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    height: 45,
                    width: 240,
                    child: SignInButton(
                      Buttons.google,
                      text: "Entrar com o google",
                      onPressed: () async {
                        await loginComGoogle();
                      },
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
