import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vitmusic/hidden_login/drawer_page.dart';

class HiddenLoginPage extends StatefulWidget {
  @override
  _HiddenLoginPageState createState() => _HiddenLoginPageState();
}

class _HiddenLoginPageState extends State<HiddenLoginPage> {
  final formKey = new GlobalKey<FormState>();
  String email, password;
  bool showSpinner = false;

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oopsie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This login isn\'t for kids. Go away!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget textInput(String hintText, TextInputType textInputType) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          obscureText: textInputType == TextInputType.visiblePassword
              ? true
              : false,
          keyboardType: textInputType,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Colors.white),
              ),
              focusColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8)),
          ),
          onChanged: (val) {
            setState(() {
              hintText == 'Enter email address' ? email = val : password = val;
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.white,
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Color(0xff341B5A),
        body: SafeArea(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                colors: [
                  Color(0xffB144DA),
                  Color(0xff341B5A),
                  Color(0xff000000),
                ],
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Admin Login',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  CircleAvatar(
                    radius: 70.0,
                    child: ClipOval(
                      child: Image.asset('assets/logo.jpg'),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff341B5A),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          textInput('Enter email address',
                              TextInputType.emailAddress),

                          SizedBox(height: 5.0),
                          textInput('Enter password',
                              TextInputType.visiblePassword),

                          SizedBox(height: 20.0),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: RaisedButton(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                color: Colors.transparent.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                elevation: 10.0,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'SF-Pro-Display',
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (email == null || password == null) {
                                    _neverSatisfied();
                                  }
                                  else {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      final user = await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                          email: email, password: password);
                                      if (user.user != null) {
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DrawerPage()));
                                      }
                                    }
                                    catch (e) {
                                      print(e);
                                      _neverSatisfied();
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    }
                                  }
                                }),
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.4 * MediaQuery.of(context).size.height),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}