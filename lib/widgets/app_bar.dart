import 'package:flutter/material.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppBar({Key? key}) : super(key: key);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();

   @override
  Size get preferredSize => const Size.fromHeight(56.0);  

}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor:  Colors.blue,
         
      );
  }
}