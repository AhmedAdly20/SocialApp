import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialchat/models/user.dart';
import 'package:socialchat/pages/activity_feed.dart';
import 'package:socialchat/pages/create_user.dart';
import 'package:socialchat/pages/profile.dart';
import 'package:socialchat/pages/search.dart';
import 'package:socialchat/pages/timeline.dart';
import 'package:socialchat/pages/upload.dart';

final googleSignIn = GoogleSignIn();
// ignore: deprecated_member_use
final userRef = Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();

User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController = PageController();
  int pageIndex = 0;

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print("error iss $err");
    });
    try {
      googleSignIn.signInSilently(suppressErrors: false).then((account) {
        handleSignIn(account);
      }).catchError((err) {
        print("error in reopen $err");
      });
    } catch (e) {
      print("signInSilently error $e");
    }
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    // ignore: deprecated_member_use
    DocumentSnapshot doc = await userRef.document(user.id).get();
    String username = "";
    if (!doc.exists) {
      username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateUser()));
      // ignore: deprecated_member_use
      userRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp,
      });
      // ignore: deprecated_member_use
      doc = await userRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);

  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          RaisedButton(
            onPressed: () {
              logout();
            },
            child: Text('Logout'),
          ),
          // Timeline(),
          ActivityFeed(),
          Search(),
          Upload(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Theme.of(context).primaryColor,
        currentIndex: pageIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none)),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
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
