import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'authservice.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false, showSpinner = false;

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Try Again!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Something\'s not right 🤔'),
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.white,
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xff341B5A),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 2.0),
                      child: Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Mélomane',
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
                          Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusColor: Colors.white,
                                    hintText: 'Enter phone number',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.8))),
                                onChanged: (val) {
                                  setState(() {
                                    this.phoneNo = '+91$val';
                                  });
                                },
                              )),
                          codeSent
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        hintText: 'Enter OTP',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8))),
                                    onChanged: (val) {
                                      setState(() {
                                        this.smsCode = val;
                                      });
                                    },
                                  ))
                              : Container(),
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
                                  child: codeSent
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          child: Text(
                                            'Verify',
                                            style: TextStyle(
                                              fontFamily: 'SF-Pro-Display',
                                              fontSize: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Padding(
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
                                  if (phoneNo == null || phoneNo.length < 10) {
                                    _neverSatisfied();
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                  else {
                                    if (codeSent) {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      AuthService()
                                          .signInWithOTP(smsCode, verificationId);
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      int cnt = 0;
                                      final snapshot = await Firestore.instance
                                          .collection('users')
                                          .getDocuments();
                                      for (var user in snapshot.documents) {
                                        if (user.data['phone'] == phoneNo)
                                          cnt++;
                                        else
                                          continue;
                                      }
                                      if (cnt == 0) {
                                        Firestore.instance
                                            .collection('users')
                                            .add({
                                          'phone': phoneNo,
                                        });
                                      }
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    } else {
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      verifyPhone(phoneNo);
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

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _neverSatisfied();
      setState(() {
        showSpinner = false;
      });
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      if (mounted) {
        setState(() {
          this.codeSent = true;
          this.showSpinner = false;
        });
      }
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
