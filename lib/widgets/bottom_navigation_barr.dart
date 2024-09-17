import 'package:bike/pages/bikes/bikes_page.dart';
import 'package:bike/pages/home/home_page.dart';
import 'package:bike/pages/profile/profile_page.dart';
import 'package:bike/pages/travels/travels_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  const BottomBar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  // Listas de telas para cada botão na barra de navegação
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const Bikes(),
    const Travels()
  ];
 
  void _onItemTapped(int index) {
    setState(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => _widgetOptions[index],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pedal_bike),
          label: 'Bicicletas',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: 'Viagens',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
