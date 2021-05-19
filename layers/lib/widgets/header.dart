import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String pagetitle}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(
      isAppTitle ? "Layers" : pagetitle,
      style: TextStyle(
          color: Colors.lightBlue,
          fontFamily: "Montserrat",
          fontSize: isAppTitle ? 30.0 : 20.0),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    toolbarHeight: 45.0,
    shadowColor: Colors.transparent,
  );
}
