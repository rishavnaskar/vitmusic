import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:path/path.dart';
import 'package:vitmusic/videos_main/video_page.dart';

class SlidingCardsView extends StatefulWidget {
  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;
  String phoneNo;
  List<String> imageCache = [];
  List<String> names = [];
  List<String> title = [];
  List<String> videos = [];
  List<String> phones = [];

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        setState(() {
          phoneNo = user.phoneNumber;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _neverSatisfied(BuildContext context, String text) async {
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

  Future<void> _temp(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$text'),
        );
      },
    );
  }

  Future refresh(AsyncSnapshot snapshots) async {
    final users = snapshots.data.documents.reversed;
    for (var user in users) {
      if (user.data['mydpsurl'] != null) {
        int len = user.data['mydpsurl'].length;
        for (int i = 0; i < len; i++) {
          if (imageCache.contains(user.data['mydpsurl'][i].toString())) {
            continue;
          } else {
            imageCache.add(user.data['mydpsurl'][i].toString());
            names.add(user.data['name'].toString());
            title.add(user.data['title'][i].toString());
            videos.add(user.data['myvideosurl'][i].toString());
            phones.add(user.data['phone'].toString());
          }
        }
      }
    }
  }

  Future deleteVideo (AsyncSnapshot snapshot, int index, BuildContext context) async{
    try {
      var fileUrlImage = Uri.decodeFull(basename(imageCache[index])).replaceAll(new RegExp(r'(\?alt).*'), '');
      final StorageReference firebaseStorageRefImage =
      FirebaseStorage.instance.ref().child(fileUrlImage);
      await firebaseStorageRefImage.delete();

      var fileUrlVideo = Uri.decodeFull(basename(videos[index])).replaceAll(new RegExp(r'(\?alt).*'), '');
      final StorageReference firebaseStorageRefVideo =
      FirebaseStorage.instance.ref().child(fileUrlVideo);
      await firebaseStorageRefVideo.delete();

      final users = snapshot.data.documents.reversed;
      for (var user in users) {
        if (user.data['phone'] == phoneNo) {
          Firestore.instance.collection('users').document(user.documentID).updateData({
            'mydpsurl': FieldValue.arrayRemove(['${imageCache[index]}']),
            'myvideosurl': FieldValue.arrayRemove(['${videos[index]}']),
            'title': FieldValue.arrayRemove(['${title[index]}']),
          });
        }
      }
      names.removeAt(index);
      imageCache.removeAt(index);
      title.removeAt(index);
      videos.removeAt(index);
      phones.removeAt(index);
      Navigator.pop(context);
      _neverSatisfied(context, 'Your video has been deleted');
    }
    catch (e) {
      Navigator.pop(context);
      _neverSatisfied(context, 'There\'s some error 🤨');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    pageController = PageController(viewportFraction: 0.93);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshots) {
              if (snapshots.data == null)
                return CircularProgressIndicator(
                  backgroundColor: Colors.deepPurple[700],
                );
              else {
                refresh(snapshots);
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: title.length == null ? 0 : title.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Stack(
                      children: <Widget>[
                        SlidingCard(
                          name: names[index],
                          offset: pageOffset,
                          title: title[index],
                          assetName: imageCache[index],
                          videoUrl: videos[index],
                        ),
                        Visibility(
                          visible: phoneNo == phones[index] ? true : false,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.white,
                            onPressed: () {
                              _temp(context, 'Please Wait');
                              deleteVideo(snapshots, index, context);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String videoUrl;
  final String assetName;
  final String title;
  final double offset;

  const SlidingCard({
    Key key,
    @required this.name,
    @required this.title,
    @required this.videoUrl,
    @required this.assetName,
    @required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        color: Colors.black,
        margin: EdgeInsets.only(right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => VideoPage(
                              url: videoUrl, name: name, title: title)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  child: CachedNetworkImage(
                    imageUrl: assetName,
                    alignment: Alignment(-offset.abs(), 0),
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
