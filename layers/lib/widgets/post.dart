import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layers/models/user.dart';
import 'package:layers/pages/home.dart';
import 'package:layers/widgets/progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String message;
  final int likes;
  final int layer;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.message,
    this.likes,
    this.layer,
  });

  factory Post.fromDocument(DocumentSnapshot snap) {
    return Post(
      postId: snap['postId'],
      ownerId: snap['ownerId'],
      username: snap['username'],
      message: snap['message'],
      likes: snap['likes'],
      layer: snap['layer'],
    );
  }

  int getLikeCount(likes) {
    return likes;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        message: this.message,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
        layer: this.layer,
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String message;
  int likeCount;
  int likes;
  int layer;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.message,
    this.likes,
    this.likeCount,
    this.layer,
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return linearProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print('Showing Profile'),
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  imageLayer(int layer) {
    if (layer == 1) {
      return 'assets/images/1-cutout.png';
    } else if (layer == 2) {
      return 'assets/images/2-cutout.png';
    } else if (layer == 3) {
      return 'assets/images/3-cutout.png';
    } else if (layer == 4) {
      return 'assets/images/4-cutout.png';
    } else {
      return 'assets/images/5-cutout.png';
    }
  }

  buildPostText() {
    return GestureDetector(
      onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            "$message",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Montserrat",
            ),
          ),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => print('Liking Post'),
              child: Icon(
                Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            //GestureDetector(
            //  onTap: () => print('Show Replies'),
            Image.asset(
              imageLayer(layer),
              height: 30.0,
            ),
            //),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount Likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "",
                //"$username",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostText(),
        buildPostFooter(),
      ],
    );
  }
}
