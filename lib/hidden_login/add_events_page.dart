import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEvents extends StatefulWidget {
  @override
  _AddEventsState createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  bool isToggled = false, reverse = false, changeEventName = false, success = true;
  String eventName, datetime, venue, description, type, newEventName;

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
          if (hintText == 'Keep it same if you want to update' && value != null)
            eventName = value;
          else if (hintText == 'Gotta be somewhere popular' && value != null)
            venue = value;
          else if (hintText == 'Make it unique' && value != null)
            newEventName = value;
          else if (hintText == 'Just elaborate' && value != null)
            description = value;
          else if (hintText == 'Hope that won\'t clash' && value != null)
            datetime = value;
          else if (hintText == 'Gotta be online/offline' && value != null)
            type = value;
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(
                color: Color(0xff341B5A), width: 3.0, style: BorderStyle.solid),
          ),
          hintStyle: TextStyle(color: Colors.grey),
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
            if (eventName != null &&
                venue != null &&
                datetime != null &&
                description != null &&
                type != null &&
                newEventName == null) {
              final users =
                  await Firestore.instance.collection('events').getDocuments();
              int cnt = 0;
              for (var user in users.documents) { // adding new event name
                if (user.data['name'] == eventName) {
                  cnt++;
                }
              }
              if (cnt == 0) {
                try {
                  Firestore.instance.collection('events').add({
                    'name': eventName,
                    'venue': venue,
                    'datetime': datetime,
                    'description': description,
                    'mode': type,
                  });
                  _neverSatisfied('Added successfully');
                } catch (e) {
                  _neverSatisfied('Something\'s wrong');
                }
              } else
                _neverSatisfied('Event name not unique');
            }
            else
              _neverSatisfied('Some fields are empty');
          }),
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
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: reverse,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Add an event',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff341B5A),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                title('Event name'),
                textInput('Keep it same if you want to update'),
                SizedBox(height: 30),
                title('Venue'),
                textInput('Gotta be somewhere popular'),
                SizedBox(height: 30),
                title('Description'),
                textInput('Just elaborate'),
                SizedBox(height: 30),
                title('Date and time'),
                textInput('Hope that won\'t clash'),
                SizedBox(height: 30),
                title('Type'),
                textInput('Gotta be online/offline'),
                SizedBox(height: 30),
                bookButton(),
                SizedBox(height: 150.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
