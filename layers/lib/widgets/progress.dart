import 'package:flutter/material.dart';

Container circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
      ));
}

linearProgress() {
  return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
      ));
}
