import 'package:flutter/material.dart';
import 'package:layers/pages/home.dart';

//Function To sign out user by widget in far left bottom navbar
class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    googleSignIn.signOut();
    return Text('Signed Out');
  }
}
