import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vitmusic/Main/menu_page.dart';
import 'package:vitmusic/videos_main/videos_home_page.dart';

class BookSlot extends StatefulWidget {
  @override
  _BookSlotState createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double maxSlide = 255.0;
  bool isToggled = false, showSpinner = false, reverse = false;
  String bandName, datetime, place;

  Widget textInput(String hintText) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: TextField(
        style: TextStyle(color: Color(0xff341B5A)),
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        onTap: () {
          setState(() {
            reverse = true;
          });
        },
        onChanged: (value) {
          if (hintText == 'Is it cool enough?')
            bandName = value;
          else if (hintText == 'Gotta be either OMR/NMR')
            place = value;
          else if (hintText == 'Hope it doesn\'t clash') datetime = value;
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(
                color: Color(0xff341B5A), width: 3.0, style: BorderStyle.solid),
          ),
          hintStyle: TextStyle(color: Color(0xff341B5A)),
          hintText: hintText,
          filled: false,
          fillColor: Color(0xff341B5A).withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(
                color: Color(0xff341B5A), width: 3.0, style: BorderStyle.solid),
          ),
        ),
      ),
    );
  }

  Future<void> _neverSatisfied(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$text'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget title(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '$text',
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff341B5A),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget bookButton() {
    return Center(
      child: RaisedButton(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 3,
              20.0, MediaQuery.of(context).size.width / 3, 20.0),
          elevation: 15.0,
          focusColor: Colors.white.withOpacity(0.4),
          color: Color(0xff341B5A),
          focusElevation: 15.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0))),
          child: Text(
            'Book',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
            ),
          ),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            setState(() {
              showSpinner = true;
            });
            if (bandName != null && place != null && datetime != null) {
              final users =
                  await Firestore.instance.collection('bookslots').getDocuments();
              int cnt = 0;
              String ref;
              for (var user in users.documents) {
                if (user.data['band'] == bandName) {
                  cnt++;
                  ref = user.documentID;
                }
              }
              if (cnt == 0) {
                Firestore.instance.collection('bookslots').add({
                  'band': bandName,
                  'place': place,
                  'datetime': datetime,
                });
              } else {
                Firestore.instance
                    .collection('bookslots')
                    .document('$ref')
                    .updateData({
                  'band': bandName,
                  'place': place,
                  'datetime': datetime,
                });
              }
              setState(() {
                showSpinner = false;
              });
              Navigator.pop(context);
              _animationController.dispose();
              pageId = null;
              _neverSatisfied('Slot requested successfully');
            }
            else {
              setState(() {
                showSpinner = false;
              });
              _neverSatisfied('Some fields are empty!');
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    pageId = 'Book a slot';
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }


  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: WillPopScope(
        onWillPop: () async {
          toggle();
          isToggled = !isToggled;
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                double slide = maxSlide * _animationController.value;
                double scale = 1 - (_animationController.value * 0.5);
                return Stack(
                  children: <Widget>[
                    MenuPage(
                      onTap: () {
                        toggle();
                        setState(() {
                          isToggled = !isToggled;
                        });
                      },
                    ),
                    SafeArea(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..scale(scale)
                          ..translate(slide),
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            borderRadius: isToggled
                                ? BorderRadius.all(Radius.circular(40.0))
                                : BorderRadius.all(Radius.circular(0.0)),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: reverse,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                  icon: !isToggled ? Icon(Icons.arrow_back) : Icon(Icons.list),
                                  onPressed: () {
                                    toggle();
                                    setState(() {
                                      isToggled = !isToggled;
                                    });
                                  },
                                  color: Colors.black,
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'Book a slot',
                                    style: TextStyle(
                                      shadows: [BoxShadow(blurRadius: 10.0, offset: Offset(10.0, 10.0), color: Colors.transparent.withOpacity(0.4))],
                                      fontSize: 25,
                                      color: Color(0xff341B5A),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                title('Enter band name'),
                                textInput('Is it cool enough?'),
                                SizedBox(height: 30),
                                title('Where do you wanna practice'),
                                textInput('Gotta be either OMR/NMR'),
                                SizedBox(height: 30),
                                title('Enter date and time'),
                                textInput('Hope it doesn\'t clash'),
                                SizedBox(height: 30),
                                bookButton(),
                                SizedBox(height: 150.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
