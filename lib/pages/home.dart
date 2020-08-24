import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;

  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        isAuth = true;
      });
    }, onError: (err) {
      print("error iss $err");
    });
    try {
      googleSignIn.signInSilently(suppressErrors: false).then((account) {
        setState(() {
          isAuth = true;
        });
      }).catchError((err) {
        print("error in reopen $err");
      });
    } catch (e) {
      print("signInSilently error $e");
    }
  }


  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  Widget buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(),
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70.0, left: 20.0, bottom: 30.0),
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                  Text("Welcome to Social Chat"),
                ],
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0))),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        login();
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: Text("Sign in With Google Account",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white))),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
