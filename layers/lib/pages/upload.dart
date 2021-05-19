import 'package:flutter/material.dart';
import 'package:layers/pages/home.dart';
import 'package:layers/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String _userText;
  int _userLayer = 1;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String postId = Uuid().v4();

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Text(
                "Create Text Post",
              ),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Type Here"),
                      validator: (input) {
                        if (input.length > 50 || input.isEmpty) {
                          return 'Text Must be From 1-50 Characters';
                        }
                        return null;
                      },
                      onSaved: (input) => _userText = input,
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "What Layer Are You Posting to?",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "$_userLayer",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userLayer = 1;
                        });
                      },
                      child: Image.asset(
                        'assets/images/1-cutout.png',
                        height: 50.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userLayer = 2;
                        });
                      },
                      child: Image.asset(
                        'assets/images/2-cutout.png',
                        height: 50.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userLayer = 3;
                        });
                      },
                      child: Image.asset(
                        'assets/images/3-cutout.png',
                        height: 50.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userLayer = 4;
                        });
                      },
                      child: Image.asset(
                        'assets/images/4-cutout.png',
                        height: 50.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userLayer = 5;
                        });
                      },
                      child: Image.asset(
                        'assets/images/5-cutout.png',
                        height: 50.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: SimpleDialogOption(
                          child: Text("Submit"),
                          onPressed: () {
                            _submit();
                            Navigator.pop(context);
                          }),
                    ),
                    Container(
                      child: SimpleDialogOption(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState.validate()) {
      print("Submitted");
      formKey.currentState.save();
      print("here");
      postsReference.document(postId).setData({
        "postId": postId,
        "ownerId": currentUser.id,
        "user": currentUser.username,
        "message": _userText,
        "layer": _userLayer,
        "likes": 0,
        "timestamp": timestamp,
      });
    } else {
      print("Not Validated");
    }
    setState(() {
      _userLayer = 1;
      _userText = "";
    });
  }

  buildInitialUpload() {
    return Container(
      color: Colors.lightBlue.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isLoading ? linearProgress() : Text(""),
          Image.asset('assets/images/messaging.png', height: 260.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
              )),
              child: Text(
                "Post Text",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              onPressed: () => selectImage(context),
            ),
          ),
        ],
      ),
    );
  }

  buildUploadForm() {
    return Container(
      color: Colors.green.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/GreenCheck.png', height: 260.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Message Uploaded Successfully",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Montserrat",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userText == null ? buildInitialUpload() : buildUploadForm();
  }
}
