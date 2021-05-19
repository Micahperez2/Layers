import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layers/widgets/header.dart';
import 'package:layers/widgets/post.dart';
import 'package:layers/widgets/progress.dart';
import 'package:layers/pages/home.dart';

//final usersReference = Firestore.instance.collection('Users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts = [];

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      getUsers();
    });
    super.initState();
  }

  //Function Used For Testing
  createUser() {
    usersReference.document('uniqestirng').setData({
      "username": "Tom",
      "isAdmin": false,
      "postCount": 0,
    });
  }

  //Creates List of posts that the user is following. So far I was unable to list only post of those following and application is dispalying every post.
  Future getUsers() async {
    print('MADE');
    final QuerySnapshot snapshot = await followingReference
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    List<String> timelineFollowers = [];
    snapshot.documents.forEach((document) {
      timelineFollowers.add(document.documentID);
      print(document.documentID);
    });
    //Tried To Filter posts here but the function I needed "whereIn" was depreciated
    QuerySnapshot postSnapshot = await postsReference
        //.where('ownerId', "in", timelineFollowers)
        //.orderBy('timestamp') //timelineFollowers)
        .getDocuments();
    if (mounted) {
      setState(() {
        posts = postSnapshot.documents
            .map((snapshot) => Post.fromDocument(snapshot))
            .toList();
        print("Timeline Posts Created");
      });
    }
  }

  //Function Allows user to change layers and displays only posts that are filtered to that layer
  changeLayer(int layer) async {
    QuerySnapshot newpostSnapshot = await postsReference
        .where('layer', isLessThanOrEqualTo: layer)
        .getDocuments();
    setState(() {
      posts = newpostSnapshot.documents
          .map((snapshot) => Post.fromDocument(snapshot))
          .toList();
    });
  }

  //Function for changing current layer of timeline
  void showSideScreen() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              child: Column(
            children: <Widget>[
              Text(
                "Filter Feed By Layer:",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Montserrat",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Image.asset(
                      'assets/images/1-cutout.png',
                      height: 70.0,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "3 Friends",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                onTap: () => changeLayer(1),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Image.asset(
                      'assets/images/2-cutout.png',
                      height: 70.0,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "10 Friends",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                onTap: () => changeLayer(2),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Image.asset(
                      'assets/images/3-cutout.png',
                      height: 70.0,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "25 Friends",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                onTap: () => changeLayer(3),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Image.asset(
                      'assets/images/4-cutout.png',
                      height: 70.0,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "All Friends",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                onTap: () => changeLayer(4),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Image.asset(
                      'assets/images/5-cutout.png',
                      height: 70.0,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "Public",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                onTap: () => changeLayer(5),
              ),
            ],
          ));
        });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: StreamBuilder<QuerySnapshot>(
            stream: postsReference.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              //final List<Text> children = snapshot.data.documents
              //    .map((snap) => print(snap['message']))
              //    .toList();

              return SingleChildScrollView(
                  child: Column(children: <Widget>[
                GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: posts,
                  ),
                  onPanUpdate: (details) {
                    if (details.delta.dx > 0) {
                      showSideScreen();
                    }
                  },
                ),
                Text(
                  "Note: Swipe Right On Any Post To Sort By Layer",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                )
              ]));
            }
            //body: circularProgress(),
            ));
  }
}
