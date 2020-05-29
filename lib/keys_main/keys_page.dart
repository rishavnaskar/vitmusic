import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitmusic/videos_main/videos_home_page.dart';
import '../Main/menu_page.dart';

class KeysPage extends StatefulWidget {
  @override
  _KeysPageState createState() => _KeysPageState();
}

class _KeysPageState extends State<KeysPage> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  double maxSlide = 255.0;
  bool isToggled = false;
  List<String> names = [];
  List<String> registrations = [];
  List<String> phones = [];

  @override
  void initState() {
    super.initState();
    pageId = 'Keys';
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'Keys',
                                style: TextStyle(
                                  shadows: [BoxShadow(blurRadius: 10.0, offset: Offset(10.0, 10.0), color: Colors.transparent.withOpacity(0.4))],
                                  color: Color(0xff341B5A),
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('keys')
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  if (!snapshots.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    final users = snapshots.data.documents;
                                    for (var user in users) {
                                      if (!names.contains(user.data['name']) &&
                                          !registrations.contains(user.data['registration']) &&
                                          !phones.contains(user.data['phone'])) {
                                        names.add(user.data['name']);
                                        registrations.add(user.data['registration']);
                                        phones.add(user.data['phone']);
                                      }
                                      else
                                        continue;
                                    }
                                    return ListView.builder(
                                      itemCount: names.length == null
                                          ? 0
                                          : names.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.4),
                                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                            border: Border.all(color: Color(0xff341B5A), width: 2.0),
                                          ),
                                          child: ListTile(
                                            leading: Text('${registrations[index]}', style: TextStyle(
                                              fontSize: 17.0,
                                            ),),
                                            title: Text('${names[index]}', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),),
                                            trailing: IconButton(
                                              icon: Icon(Icons.phone),
                                              color: Colors.black,
                                              onPressed: () {
                                                launch("tel:${phones[index]}");
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
