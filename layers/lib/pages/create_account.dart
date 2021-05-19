import 'dart:async';

import 'package:flutter/material.dart';
import 'package:layers/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;

  submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: header(context, pagetitle: "Create New Profile"),
        body: ListView(
          children: <Widget>[
            Container(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "Username required to be longer";
                          } else if (val.trim().length > 12) {
                            return "Username required to be shorter";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 20.0),
                          hintText: "Type Username Here",
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: submit,
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                        child: Text(
                          "Submit Here",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ))
              ],
            ))
          ],
        ));
  }
}
