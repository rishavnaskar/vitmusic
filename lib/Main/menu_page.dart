import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitmusic/book_slot_main/book_slot_home.dart';
import 'package:vitmusic/current_slot_main/current_slot.dart';
import 'package:vitmusic/events_main/events_page.dart';
import 'package:vitmusic/Main/exhibition_bottom_sheet.dart';
import 'package:vitmusic/hidden_login/hidden_login_page.dart';
import 'package:vitmusic/keys_main/keys_page.dart';
import 'package:vitmusic/videos_main/videos_home_page.dart';
import 'authservice.dart';

class MenuPage extends StatefulWidget {
  MenuPage({this.onTap});
  final Function onTap;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Function onPressed;

  Widget menuButton(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        elevation: 10.0,
        focusColor: Colors.white.withOpacity(0.4),
        color: Colors.transparent.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Text(
          '• $text',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {

          if (text == 'Book a slot') {
            if (pageId != 'Book a slot' && pageId == null)
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BookSlot()));
            else if (pageId != 'Book a slot' && pageId != null)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookSlot()));
          }

          else if (text == 'Videos') {
            if (pageId != 'Videos' && pageId == null)
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => VideosHomePage()));
            else if (pageId != 'Videos' && pageId != null)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideosHomePage()));
          }

          else if (text == 'Current slots') {
            if (pageId != 'Current slots' && pageId == null)
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CurrentSlot()));
            else if (pageId != 'Current slots' && pageId != null)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CurrentSlot()));
          }

          else if (text == 'Keys') {
            if (pageId != 'Keys' && pageId == null)
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => KeysPage()));
            else if (pageId != 'Keys' && pageId != null)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KeysPage()));
          }

          else if (text == 'Events') {
            if (pageId != 'Events' && pageId == null)
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => EventsPage()));
            else if (pageId != 'Events' && pageId != null)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventsPage()));
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    onPressed = widget.onTap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xffB144DA),
                Color(0xff341B5A),
                Color(0xff000000),
              ],
            )),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height / 20),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: IconButton(
                          icon: Icon(Icons.list),
                          color: Colors.white,
                          iconSize: 26.0,
                          alignment: Alignment.topLeft,
                          onPressed: onPressed,
                        ),
                      ),
                      Spacer(),
                      Visibility(
                        visible: pageId == null ? false : true,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          iconSize: 23.0,
                          color: Colors.white,
                          onPressed: () {
                            if (pageId != null) {
                              Navigator.pop(context);
                              pageId = null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: Icon(Icons.exit_to_app),
                          iconSize: 23.0,
                          color: Colors.white,
                          onPressed: () {
                            if (pageId != null)
                              Navigator.pop(context);
                            AuthService().signOut();
                            pageId = null;
                          },
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onLongPress: () {
                      if(pageId == null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HiddenLoginPage()));
                      }
                      else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HiddenLoginPage()));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Mélomane',
                        style: TextStyle(
                          //shadows: [BoxShadow(blurRadius: 10.0, offset: Offset(-10.0, 10.0), color: Colors.transparent.withOpacity(0.4))],
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lobster',
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Menu Page',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  pageId != 'Current slots'
                      ? Visibility(visible: true, child: menuButton('Current slots'))
                      : Visibility(
                          visible: false, child: menuButton('Current slots')),
                  pageId != 'Book a slot'
                      ? Visibility(
                          visible: true,
                          child: SizedBox(height: 20.0))
                      : Visibility(
                          visible: false,
                          child: SizedBox(height: 20.0)),
                  pageId != 'Book a slot'
                      ? Visibility(visible: true, child: menuButton('Book a slot'))
                      : Visibility(visible: false, child: menuButton('Book a slot')),
                  pageId != 'Events'
                      ? Visibility(
                          visible: true,
                          child: SizedBox(height: 20.0))
                      : Visibility(
                          visible: false,
                          child: SizedBox(height: 20.0)),
                  pageId != 'Events'
                      ? Visibility(visible: true, child: menuButton('Events'))
                      : Visibility(visible: false, child: menuButton('Events')),
                  pageId != 'Videos'
                      ? Visibility(
                          visible: true,
                          child: SizedBox(height: 20.0))
                      : Visibility(
                          visible: false,
                          child: SizedBox(height: 20.0)),
                  pageId != 'Videos'
                      ? Visibility(visible: true, child: menuButton('Videos'))
                      : Visibility(visible: false, child: menuButton('Videos')),
                  pageId != 'Keys'
                      ? Visibility(
                          visible: true,
                          child: SizedBox(height: 20.0))
                      : Visibility(
                          visible: false,
                          child: SizedBox(height: 20.0)),
                  pageId != 'Keys'
                      ? Visibility(visible: true, child: menuButton('Keys'))
                      : Visibility(visible: false, child: menuButton('Keys')),

                  SizedBox(height: 0.2 * MediaQuery.of(context).size.height),
                ],
              ),
            ),
          ),
          ExhibitionBottomSheet(),
        ],
      ),
    );
  }
}
