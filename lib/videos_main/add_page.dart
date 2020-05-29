import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:vitmusic/videos_main/videos_home_page.dart';

class AddVideoPage extends StatefulWidget {
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  bool showSpinner = false, reverse = false;
  String phoneNo, videoTitle, name, date;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        setState(() {
          phoneNo = user.phoneNumber;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget title(String text, double fontSize) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget textInput(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          if (text == '  Enter your name')
            name = value;
          else
            videoTitle = value;
        },
        onTap: () {
          setState(() {
            reverse = false;
          });
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(
                color: Colors.white, width: 3.0, style: BorderStyle.solid),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(
                color: Colors.white, width: 3.0, style: BorderStyle.solid),
          ),
          hintStyle:
              TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          hintText: text,
          filled: false,
        ),
      ),
    );
  }

  Future uploadNameAndTitle() async {
    final users = await Firestore.instance.collection('users').getDocuments();
    for (var user in users.documents) {
      if (user.data['phone'] == phoneNo) {
        Firestore.instance
            .collection('users')
            .document('${user.documentID}')
            .updateData({
          'name': name,
          'title': FieldValue.arrayUnion(['$videoTitle']),
        });
      }
    }
  }

  File _video;
  Future getVideo() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = video;
    });
  }

  Future uploadVideo() async {
    String fileName = basename(_video.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(_video);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    final users = await Firestore.instance.collection('users').getDocuments();
    setState(() {
      if (uploadTask.isComplete && uploadTask.isSuccessful) {
        for (var user in users.documents) {
          if (user.data['phone'] == phoneNo) {
            Firestore.instance
                .collection('users')
                .document('${user.documentID}')
                .updateData({
              'myvideosurl': FieldValue.arrayUnion([downloadUrl]),
            });
          }
        }
      } else if (uploadTask.isCanceled) {
        setState(() {
          showSpinner = false;
          Text('Error');
        });
      }
    });
  }

  Future<void> _neverSatisfied(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$text'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future uploadImage() async {
    String fileName = basename(_image.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    final users = await Firestore.instance.collection('users').getDocuments();
    setState(() {
      if (uploadTask.isComplete && uploadTask.isSuccessful) {
        for (var user in users.documents) {
          if (user.data['phone'] == phoneNo) {
            Firestore.instance
                .collection('users')
                .document('${user.documentID}')
                .updateData({
              'mydpsurl': FieldValue.arrayUnion([downloadUrl]),
            });
          }
        }
      } else if (uploadTask.isCanceled) {
        setState(() {
          showSpinner = false;
          Text('Error');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Color(0xff341B5A),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              colors: [
                Color(0xffB144DA),
                Color(0xff341B5A),
                Color(0xff000000),
              ],
            )),
            child: SingleChildScrollView(
              reverse: reverse,
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideosHomePage()));
                          },
                        ),
                        Flexible(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 10)),
                        title('Add a post', 28.0),
                      ],
                    ),
                    title('Add your video', 20.0),
                    GestureDetector(
                      onTap: () {
                        getVideo();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: ClipRRect(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              border: Border.all(
                                  color: Colors.white,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                            ),
                            child: Center(
                              child: _video == null
                                  ? Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 50.0,
                                    )
                                  : Text('VIDEO ADDED',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title('Add your display image', 20.0),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: ClipRRect(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              border: Border.all(
                                  color: Colors.white,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                            ),
                            child: Center(
                              child: _image == null
                                  ? Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 50.0,
                                    )
                                  : Text('IMAGE ADDED',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title('Title', 20.0),
                    textInput('  Enter a brief title (2 - 3 words)'),
                    title('Name', 20.0),
                    textInput('  Enter your name'),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: RaisedButton(
                              padding:
                                  EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                              elevation: 10.0,
                              focusColor: Colors.white,
                              child: Text('Upload',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  )),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              color: Colors.white,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  reverse = false;
                                });
                                if (name != null &&
                                    videoTitle != null &&
                                    _video != null &&
                                    _image != null) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    uploadNameAndTitle();
                                    uploadVideo().whenComplete(() {
                                      uploadImage().whenComplete(() {
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideosHomePage()));
                                        _neverSatisfied(
                                            context, 'Uploaded Successfully');
                                      });
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      _neverSatisfied(context, 'Upload Error');
                                    }
                                  }
                                } else {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  _neverSatisfied(
                                      context, 'Some fields are empty!');
                                }
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
