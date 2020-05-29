import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vitmusic/videos_main/videos_home_page.dart';
import '../Main/menu_page.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double maxSlide = 255.0;
  bool isToggled = false;
  List<String> dateTimes = [];
  List<String> descriptions = [];
  List<String> modes = [];
  List<String> names = [];
  List<String> venues = [];

  @override
  void initState() {
    super.initState();
    pageId = 'Events';
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
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
              double scale = 1 - (_animationController.value * 0.6);
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
                              icon: !isToggled
                                  ? Icon(Icons.arrow_back)
                                  : Icon(Icons.list),
                              onPressed: () {
                                toggle();
                                setState(() {
                                  isToggled = !isToggled;
                                });
                              },
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                              child: Text(
                                'Events',
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
                                    .collection('events')
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  if (!snapshots.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    final users = snapshots.data.documents;
                                    for (var user in users) {
                                      if (!names.contains(user.data['name']) &&
                                          !descriptions.contains(
                                              user.data['description']) &&
                                          !venues.contains(user.data['venue']) &&
                                          !dateTimes
                                              .contains(user.data['datetime']) &&
                                          !modes.contains(user.data['mode'])) {
                                        names.add(user.data['name']);
                                        descriptions
                                            .add(user.data['description']);
                                        venues.add(user.data['venue']);
                                        modes.add(user.data['mode']);
                                        dateTimes.add(user.data['datetime']);
                                      } else
                                        continue;
                                    }
                                    return ListView.builder(
                                      itemCount:
                                          names.length == null ? 0 : names.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Color(0xff341B5A),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            border: Border.all(
                                                color: Color(0xff341B5A),
                                                width: 2.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(14.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Name - ', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '${names[index]}', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(height: 15.0),

                                                Text(
                                                  'Venue - ', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '${venues[index]}', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(height: 15.0),

                                                Text(
                                                  'Description - ', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '${descriptions[index]}', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(height: 15.0),

                                                Text(
                                                  'Mode - ', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '${modes[index]}', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(height: 15.0),

                                                Text(
                                                  'Date and time - ', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '${dateTimes[index]}', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(height: 15.0),
                                              ],
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
