import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModifyEvent extends StatefulWidget {
  @override
  _ModifyEventState createState() => _ModifyEventState();
}

class _ModifyEventState extends State<ModifyEvent> {
  bool reverse = false, changeEventName = false, success = true, deleteEvent = false;
  String eventName, datetime, venue, description, type, newEventName;

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
          if (hintText == 'Keep it same' && value != null)
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
          hintStyle: TextStyle(color: Colors.grey[700]),
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
            deleteEvent ? 'Delete' : 'Update',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
            ),
          ),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            final users = await Firestore.instance.collection('events').getDocuments();
            if (eventName != null) {
              try {
                for (var user in users.documents) {
                  if (user.data['name'] == eventName) {
                    if (newEventName != null) {
                      user.reference.updateData({
                        'name': newEventName,
                      });
                      _neverSatisfied('Event name updated');
                      newEventName = null;
                      eventName = null;
                    } else {
                      if (newEventName == null && venue == null &&
                          description == null && datetime == null &&
                          type == null) {
                        user.reference.delete();
                        _neverSatisfied('Event deleted');
                        eventName = null;
                      } else {
                        try {
                          if (venue != null)
                            user.reference.updateData({'venue': venue});
                          if (description != null)
                            user.reference.updateData(
                                {'description': description});
                          if (datetime != null)
                            user.reference.updateData({'datetime': datetime});
                          if (type != null)
                            user.reference.updateData({'mode': type});
                          _neverSatisfied('Updated successfully');
                        }
                        catch (e) {
                          _neverSatisfied('There\'s some error');
                        }
                      }
                    }
                  }
                }
              }
              catch (e) {
                _neverSatisfied('There\'s some error');
              }
            }
            else
              _neverSatisfied('Empty event name');
          }),
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: reverse,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Color(0xff341B5A)),
                        ),
                        child: Text('Update event name',
                            style: TextStyle(fontSize: 12.0)),
                        onPressed: () {
                          setState(() {
                            changeEventName = !changeEventName;
                            if (deleteEvent == true)
                              deleteEvent = false;
                            reverse = false;
                            newEventName = null;
                          });
                        },
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Color(0xff341B5A)),
                        ),
                        child: Text('Delete this event',
                            style: TextStyle(fontSize: 12.0)),
                        onPressed: () {
                          setState(() {
                            deleteEvent = !deleteEvent;
                            if (changeEventName == true)
                              changeEventName = false;
                            reverse = false;
                            newEventName = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Modify/Delete an event',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff341B5A),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                title('Existing Event name'),
                textInput('Keep it same'),
                Visibility(visible: changeEventName && !deleteEvent, child: SizedBox(height: 30)),
                Visibility(visible: changeEventName && !deleteEvent, child: title('New event name')),
                Visibility(visible: changeEventName && !deleteEvent, child: textInput('Make it unique')),
                SizedBox(height: 30),
                Visibility(visible: !changeEventName && !deleteEvent,child: title('New venue')),
                Visibility(visible: !changeEventName && !deleteEvent,child: textInput('Gotta be somewhere popular')),
                Visibility(visible: !changeEventName && !deleteEvent,child: SizedBox(height: 30)),
                Visibility(visible: !changeEventName && !deleteEvent, child: title('New description')),
                Visibility(visible: !changeEventName && !deleteEvent, child: textInput('Just elaborate')),
                Visibility(visible: !changeEventName && !deleteEvent, child: SizedBox(height: 30)),
                Visibility(visible: !changeEventName && !deleteEvent, child: title('New date and time')),
                Visibility(visible: !changeEventName && !deleteEvent, child: textInput('Hope that won\'t clash')),
                Visibility(visible: !changeEventName && !deleteEvent, child: SizedBox(height: 30)),
                Visibility(visible: !changeEventName && !deleteEvent, child: title('New type')),
                Visibility(visible: !changeEventName && !deleteEvent, child: textInput('Gotta be online/offline')),
                SizedBox(height: 30),
                bookButton(),
                SizedBox(height: 0.2 * MediaQuery.of(context).size.height),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
