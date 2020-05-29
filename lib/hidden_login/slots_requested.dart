import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlotsRequested extends StatefulWidget {
  @override
  _SlotsRequestedState createState() => _SlotsRequestedState();
}

class _SlotsRequestedState extends State<SlotsRequested> {
  List<String> bands;
  List<String> dateTimes;
  List<String> places;
  List<String> docId;

  Future<void> _neverSatisfied(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$text'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    bands = [];
    dateTimes = [];
    places = [];
    docId = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('bookslots').snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return CircularProgressIndicator();
                } else {
                  final users = snapshots.data.documents;
                  for (var user in users) {
                    if (!bands.contains(user.data['band'])) {
                      bands.add(user.data['band']);
                      dateTimes.add(user.data['datetime']);
                      places.add(user.data['place']);
                      docId.add(user.documentID);
                    }
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 4.0, right: 2.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              side: BorderSide(color: Color(0xff341B5A), style: BorderStyle.solid, width: 2.0)
                            ),
                            color: Colors.white,
                            child: Text('Delete all requested slots', style: TextStyle(color: Color(0xff341B5A))),
                            onPressed: () async {
                              Firestore.instance
                                  .collection('bookslots')
                                  .getDocuments()
                                  .then((snapshot) {
                                for (DocumentSnapshot doc in snapshot.documents) {
                                  doc.reference.delete();
                                }
                              });
                              bands.clear();
                              dateTimes.clear();
                              places.clear();
                              docId.clear();
                              _neverSatisfied('All requested slots deleted');
                            },
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0, right: 4.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                side: BorderSide(color: Color(0xff341B5A), style: BorderStyle.solid, width: 2.0)
                            ),
                            color: Colors.white,
                            child: Text('Delete all current slots', style: TextStyle(color: Color(0xff341B5A))),
                            onPressed: () async {
                              Firestore.instance
                                  .collection('slots')
                                  .getDocuments()
                                  .then((snapshot) {
                                for (DocumentSnapshot doc in snapshot.documents) {
                                  doc.reference.delete();
                                }
                              });
                              _neverSatisfied('All currently approved slots deleted');
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                      child: Text(
                        'Tap to approve',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance.collection('bookslots').snapshots(),
                          builder: (context, snapshots) {
                            return ListView.builder(
                              itemCount: bands.length == null ? 0 : bands.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                    border: Border.all(
                                        color: Color(0xff341B5A), width: 2.0),
                                  ),
                                  child: ListTile(
                                    leading: Text(
                                      '${places[index]}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    title: Text(
                                      '${bands[index]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text('${dateTimes[index]}'),
                                    onTap: () async {
                                      _neverSatisfied('Slot approved!');
                                      final users = await Firestore.instance
                                          .collection('slots')
                                          .getDocuments();
                                      int cnt = 0;
                                      String doc;
                                      for (var user in users.documents) {
                                        if (user.data['band'] == bands[index]) {
                                          cnt++;
                                          doc = user.documentID;
                                        }
                                      }

                                      if (cnt > 0) {
                                        Firestore.instance
                                            .collection('slots')
                                            .document('$doc')
                                            .updateData({
                                          'band': bands[index],
                                          'datetime': dateTimes[index],
                                          'place': places[index],
                                        });
                                      } else {
                                        Firestore.instance.collection('slots').add({
                                          'band': bands[index],
                                          'datetime': dateTimes[index],
                                          'place': places[index],
                                        });
                                      }

                                      Firestore.instance
                                          .collection('bookslots')
                                          .document('${docId[index]}')
                                          .delete();
                                      bands.removeAt(index);
                                      dateTimes.removeAt(index);
                                      places.removeAt(index);
                                      docId.removeAt(index);
                                    },
                                  ),
                                );
                              },
                            );
                          },
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
