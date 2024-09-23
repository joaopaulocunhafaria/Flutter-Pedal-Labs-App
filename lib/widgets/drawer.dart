import 'package:bike/pages/home/home_page.dart';
import 'package:bike/pages/info/info_page.dart';
import 'package:bike/pages/login/login_page.dart';
import 'package:bike/pages/login/login_with_google.dart';
import 'package:bike/pages/profile/profile_page.dart';
import 'package:bike/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DefaultDrawer extends StatefulWidget {
  const DefaultDrawer({Key? key}) : super(key: key);

  @override
  State<DefaultDrawer> createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  String? userEmail;
  Future<String?> getUserNameFromFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userEmail = currentUser.email;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(currentUser.uid)
          .get();
      return (userDoc.data() as Map<String, dynamic>)['nome'];
    }
    return null;
  }

  logOut() async {
    await context.read<AuthService>().logout();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const LoginWithGoogle()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1577209299418-485f60c0d4de?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxM3x8anVuZ2xlfGVufDB8fHx8MTcxMzQ1MjAzMnww&ixlib=rb-4.0.3&q=80&w=1080"))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Isso faz com que o conteúdo da coluna seja alinhado na parte inferior.
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Icon(FontAwesomeIcons.arrowLeft),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<String?>(
                      future: getUserNameFromFirestore(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Erro ao carregar nome.');
                          } else if (snapshot.hasData) {
                            return Text(
                              'Olá, ${snapshot.data}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }
                        }
                        return const CircularProgressIndicator(); // Mostra um spinner até que o nome seja carregado.
                      },
                    ),
                  ],
                ),
                const SizedBox(
                    height:
                        10), // Pode ajustar o valor para aumentar ou diminuir o espaço.
              ],
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.house, size: 25.0),
            title: const Text('Home'),
            onTap: () { 
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.user, size: 25.0),
            title: const Text('Perfil'),
            onTap: () { 
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.bell, size: 25.0),
            title: const Text('Alertas'),
            onTap: () {
              // Atualizar o contexto do app com o item selecionado no Drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.circleInfo, size: 25.0),
            title: const Text('Sobre'),
            onTap: () {
              // Atualizar o contexto do app com o item selecionado no Drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const InfoPage(),
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(FontAwesomeIcons.arrowRightFromBracket, size: 25.0),
            title: const Text('LogOut'),
            onTap: ()async=>{
              logOut()
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.rightToBracket),
            title: Text("Login Page"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginWithGoogle()));
            },
          )
        ],
      ),
    );
  }
}
