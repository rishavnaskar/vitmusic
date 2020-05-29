import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitmusic/hidden_login/add_events_page.dart';
import 'package:vitmusic/hidden_login/home_page.dart';
import 'package:vitmusic/hidden_login/modify_event.dart';
import 'package:vitmusic/hidden_login/slots_requested.dart';
import 'package:vitmusic/videos_main/videos_home_page.dart';

class DrawerItem {
  String title;
  Icon icon;
  DrawerItem(this.title, this.icon);
}

class DrawerPage extends StatefulWidget {
  final drawerItems = [
    DrawerItem(
        'Home',
        Icon(
          Icons.home,
          color: Color(0xff341B5A),
        )),
    DrawerItem(
        'Slots requested',
        Icon(
          Icons.low_priority,
          color: Color(0xff341B5A),
        )),
    DrawerItem(
        'Add events',
        Icon(
          Icons.event,
          color: Color(0xff341B5A),
        )),
    DrawerItem(
        'Modify/Delete event',
        Icon(
          Icons.event,
          color: Color(0xff341B5A),
        )),
  ];

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String email;
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HiddenHomePage();
      case 1:
        return SlotsRequested();
      case 2:
        return AddEvents();
      case 3:
        return ModifyEvent();
      default:
        return new Text("Error");
    }
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        setState(() {
          email = user.email;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: d.icon,
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      backgroundColor: Color(0xff341B5A),
      appBar: AppBar(
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
        centerTitle: true,
        backgroundColor: Color(0xff341B5A),
        elevation: 10.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              pageId = null;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('$email', style: TextStyle(fontSize: 20.0)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  colors: [
                    Color(0xffB144DA),
                    Color(0xff341B5A),
                    Color(0xff000000),
                  ],
                ),
                boxShadow: [
                  BoxShadow(color: Color(0xff341B5A), blurRadius: 10.0)
                ],
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(10.0)),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.verified_user, color: Color(0xff341B5A)),
                radius: 15.0,
              ), accountName: null,
            ),
            Column(children: drawerOptions),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
