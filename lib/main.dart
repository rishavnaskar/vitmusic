import 'package:flutter/material.dart';
import 'package:vitmusic/Main/authservice.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        accentColor: Colors.white,
        cursorColor: Color(0xff341B5A),
        hintColor: Colors.white,
        focusColor: Colors.white,
      ),
      home: AuthService().handleAuth(),
    );
  }
}
