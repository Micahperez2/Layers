import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  factory User.fromDocument(DocumentSnapshot snap) {
    return User(
      id: snap['id'],
      email: snap['email'],
      username: snap['username'],
      photoUrl: snap['photoUrl'],
      displayName: snap['displayName'],
    );
  }
}
