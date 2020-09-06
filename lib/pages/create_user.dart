import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socialchat/widgets/header.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  String username = "";
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  submitData() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcom to Chat"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: "Create User", removeBackButton: true),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    'Create UserName',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Container(
                  child: Form(
                        key: formKey,
                        autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            new TextFormField(
                              validator: (val) {
                                if (val.trim().length < 3 || val.isEmpty) {
                                  return "UserName too short";
                                } else if (val.trim().length > 12) {
                                  return "UserName too long";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) => username = val,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "UserName",
                                  hintText: "Must be at 3 charatar"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: MaterialButton(
                                  color: Theme.of(context).primaryColor,
                                  minWidth: 300.0,
                                  child: new Text(
                                    "submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    submitData();
                                  }),
                            )
                          ],
                        )),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
