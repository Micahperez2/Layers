import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layers/models/user.dart';
import 'package:layers/pages/home.dart';
import 'package:layers/widgets/header.dart';
import 'package:layers/widgets/post.dart';
import 'package:layers/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isFollowing = false;
  final String currentUserId = currentUser.id;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  //Initialized Function on Profile Sign in
  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkFollowing();
  }

  //Get the users follower and following and update the count for each in bottom 3 functions
  getFollowers() async {
    QuerySnapshot snapshot = await followersReference
        .document(widget.profileId)
        .collection('userFollowers')
        .getDocuments();
    if (mounted) {
      setState(() {
        followerCount = snapshot.documents.length;
      });
    }
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingReference
        .document(widget.profileId)
        .collection('userFollowing')
        .getDocuments();
    if (mounted) {
      setState(() {
        followingCount = snapshot.documents.length;
      });
    }
  }

  checkFollowing() async {
    DocumentSnapshot snap = await followersReference
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    if (mounted) {
      setState(() {
        isFollowing = snap.exists;
      });
    }
  }

  //Actually fetch the profile posts of the user. Some inefficiencies here such that to get the users post you have to go through every post object on firebase.
  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsReference
        .where('ownerId', isEqualTo: widget.profileId)
        .getDocuments();
    if (mounted) {
      setState(() {
        isLoading = false;
        postCount = snapshot.documents.length;
        posts =
            snapshot.documents.map((snap) => Post.fromDocument(snap)).toList();
      });
    }
  }

  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 1.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  //Puts Follower Button on screeen if the current profile isn't your own
  buildProfileButton() {
    if (currentUserId == widget.profileId) {
      return Text('');
    }
    if (isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton(text: "Follow", function: handleFollowUser);
    }
  }

  //Created Button When Viewing another profile
  buildBackButton() {
    if (currentUserId == widget.profileId) {
      return Text('');
    } else {
      return buildButton(text: "Search", function: backtoSearch);
    }
  }

  //Function was made during testing incase back button on phone wasn't working
  backtoSearch() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  //Removes user from followers
  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    followersReference
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUserId)
        .delete();
    followingReference
        .document(currentUserId)
        .collection('userFollowing')
        .document(widget.profileId)
        .delete();
  }

  //Adds user to followers
  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    followersReference
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
    followingReference
        .document(currentUserId)
        .collection('userFollowing')
        .document(widget.profileId)
        .setData({});
  }

  //Allows users to build a button that calls functions on code presses
  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: function,
        child: Container(
          width: 100.0,
          height: 25.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  //Builds the profile header
  buildProfileHeader() {
    return FutureBuilder(
        future: usersReference.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return linearProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildCountColumn("Posts", postCount),
                              buildCountColumn("Followers", followerCount),
                              buildCountColumn("Following", followingCount),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildProfileButton(),
                              //buildBackButton(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    user.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildProfilePost() {
    return Column(
      children: posts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, pagetitle: "Profile"),
        body: ListView(
          children: <Widget>[
            buildProfileHeader(),
            Divider(
              height: 0.0,
            ),
            buildProfilePost(),
          ],
        ));
  }
}
