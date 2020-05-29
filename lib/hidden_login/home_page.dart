import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HiddenHomePage extends StatefulWidget {
  @override
  _HiddenHomePageState createState() => _HiddenHomePageState();
}

class _HiddenHomePageState extends State<HiddenHomePage> {
  bool _isSelected = false;

  Widget rulesText (String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 8.0),
      child: Text(
        '$text', style: TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(child: SizedBox(height: 20.0)),
                Flexible(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: !_isSelected
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSelected = !_isSelected;
                                });
                              },
                              child: CircleAvatar(
                                radius: 80.0,
                                child: ClipOval(
                                  child: Image.asset('assets/logo.jpg'),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSelected = !_isSelected;
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    'Developed by -  Rishav Naskar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(26.0, 16, 16, 16),
                  child: Text(
                    'Rules to follow', style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                rulesText('• Always clear current slots when approving new slots for a new day'),
                rulesText('• Follow rules strictly if updating an existing event'),
              ],
            )),
      ),
    );
  }
}
