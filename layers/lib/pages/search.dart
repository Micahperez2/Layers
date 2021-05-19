import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layers/models/user.dart';
import 'package:layers/pages/profile.dart';
import 'package:layers/pages/home.dart';
import 'package:layers/widgets/header.dart';
import 'package:layers/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  //Searches Users By Username
  doSearch(String query) {
    Future<QuerySnapshot> users = usersReference
        .where("username", isGreaterThanOrEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  //Builds The search Bar and screen
  buildSearch() {
    return AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: "Search Layers...",
            filled: true,
            prefixIcon: Icon(Icons.search, size: 28.0),
            suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  clearSearch();
                  FocusScope.of(context).requestFocus(new FocusNode());
                }),
          ),
          onFieldSubmitted: doSearch,
        ));
  }

  buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/FriendPicture.svg',
              height: 250.0,
              alignment: Alignment.bottomCenter,
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }

  //Display the users that were searched for
  displaySearchResults() {
    return FutureBuilder(
        future: searchResultsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return linearProgress();
          }
          List<UserResult> searchResults = [];
          snapshot.data.documents.forEach((snap) {
            User user = User.fromDocument(snap);
            UserResult userResults = UserResult(user);
            searchResults.add(userResults);
          });
          return ListView(
            children: searchResults,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: Scaffold(
          appBar: buildSearch(),
          body: searchResultsFuture == null
              ? buildNoContent()
              : displaySearchResults(),
        ));
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.withOpacity(0.7),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => showProfile(context, profileId: getuserID(user)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
                title: Text(
                  user.displayName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Divider(height: 2.0, color: Colors.white.withOpacity(0.9)),
          ],
        ));
  }
}

getuserID(User user) {
  print(user.id);
  while (user.id == null) {
    return linearProgress();
  }
  return user.id;
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => Profile(profileId: profileId)));
}
