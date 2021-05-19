import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layers/models/user.dart';
import 'package:layers/pages/create_account.dart';
import 'package:layers/pages/profile.dart';
import 'package:layers/pages/search.dart';
import 'package:layers/pages/timeline.dart';
import 'package:layers/pages/upload.dart';
import 'package:layers/pages/logout_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection('Users');
final postsReference = Firestore.instance.collection('Posts');
final followersReference = Firestore.instance.collection('Followers');
final followingReference = Firestore.instance.collection('Following');
final timelineReference = Firestore.instance.collection('TimelinePosts');
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool userAuth = false;
  PageController pageControl;
  int pageIndex = 0;

  //Function To Handle Sign In
  @override
  void initState() {
    super.initState();
    pageControl = PageController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    });
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  @override
  void dispose() {
    pageControl.dispose();
    super.dispose();
  }

  //Sets State Depending on user Authentication
  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFireStore();
      setState(() {
        userAuth = true;
      });
    } else {
      setState(() {
        userAuth = false;
      });
    }
  }

  createUserInFireStore() async {
    //Check if user already exist
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot snap = await usersReference.document(user.id).get();

    //If User is Non-Existant then redirect to Create Account
    if (!snap.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      //Get Username from Create Account Page and user information to create a New User in User Collection
      usersReference.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "timestamp": timestamp,
      });

      snap = await usersReference.document(user.id).get();
    }

    //Assigns current user variable to current user
    currentUser = User.fromDocument(snap);
    print(currentUser);
    print(currentUser.username);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageControl.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  //Authentication screen
  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          //ActivityFeed(),
          Upload(),
          Search(),
          Profile(profileId: currentUser?.id),
          LogoutScreen(),
        ],
        controller: pageControl,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: onTap,
        selectedItemColor: Colors.black.withOpacity(0.9),
        unselectedItemColor: Colors.black.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_sharp),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.textsms_outlined,
              //size: 30.0,
            ),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'LogoutScreen',
          ),
        ],
      ),
    );
  }

  Widget buildNonAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.withOpacity(0.8),
              Colors.lightGreen.withOpacity(0.8),
              Colors.purple.withOpacity(0.8),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Layers',
              style: TextStyle(
                fontFamily: "Montserrat-Medium",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 45),
            GestureDetector(
                onTap: login,
                child: Container(
                  width: 300.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/google_signin_button.png'),
                          fit: BoxFit.cover)),
                ))
          ],
        ),
      ),
    );
  }

  //Sees if user is Autheniticated or not
  @override
  Widget build(BuildContext context) {
    return userAuth ? buildAuthScreen() : buildNonAuthScreen();
  }
}
