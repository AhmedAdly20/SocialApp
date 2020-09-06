import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot documentSnapshot){
    return User(
      id: documentSnapshot.data()["id"],
      username: documentSnapshot.data()["username"],
      email: documentSnapshot.data()["email"],
      photoUrl: documentSnapshot.data()["photoUrl"],
      displayName: documentSnapshot.data()["displayName"],
      bio: documentSnapshot.data()["bui"],
    );
  }
}
