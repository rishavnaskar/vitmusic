import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExhibitionBottomSheet extends StatefulWidget {
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  List<String> people = [];
  double notificationExtent;
  AnimationController rotationController;

  Future getPeople() async {
    final users = await Firestore.instance.collection('club').getDocuments();
    for (var user in users.documents) {
      if (people == null)
        people.add(user.data['people']);
      else if(people.contains(user.data['people']))
        continue;
      else
        people.add(user.data['people']);
    }
  }

  @override
  void initState() {
    super.initState();
    getPeople();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      // ignore: missing_return
      onNotification: (notify) {
        notificationExtent = notify.extent;
      },
      child: DraggableScrollableSheet(
          initialChildSize: 0.2,
          expand: true,
          minChildSize: 0.2,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            if (notificationExtent == 0.6)
              rotationController.forward(from: 0.0);
            else
              rotationController.forward(from: 0.5);
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0)),
                color: Color(0xff341B5A),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'The VIT Music Club',
                          style: TextStyle(
                            shadows: [BoxShadow(blurRadius: 10.0, offset: Offset(10.0, 10.0), color: Colors.transparent.withOpacity(0.6))],
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RotationTransition(
                          turns: notificationExtent == 0.6
                              ? Tween(begin: 0.0, end: 0.5)
                                  .animate(rotationController)
                              : (notificationExtent == 0.0
                                  ? Tween(begin: 0.5, end: 1.0)
                                      .animate(rotationController)
                                  : Tween(begin: 0.0, end: 0.0)
                                      .animate(rotationController)),
                          child: Icon(
                            Icons.arrow_upward,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    //Flexible(child: SizedBox(height: 20.0)),
                    Flexible(
                      child: SizedBox(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: people == null ? 0 : people.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                title: Text('${people[index]}',
                                    style: TextStyle(color: Colors.white)));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
