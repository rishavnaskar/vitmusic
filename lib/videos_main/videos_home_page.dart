import 'package:flutter/cupertino.dart';
import 'package:vitmusic/Main/menu_page.dart';
import 'package:vitmusic/videos_main/add_page.dart';
import 'package:vitmusic/videos_main/sliding_cards.dart';
import 'package:flutter/material.dart';

String pageId;

class VideosHomePage extends StatefulWidget {
  @override
  _VideosHomePageState createState() => _VideosHomePageState();
}

class _VideosHomePageState extends State<VideosHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double maxSlide = 255.0;
  bool isToggled = false;

  @override
  void initState() {
    super.initState();
    pageId = 'Videos';
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
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
        resizeToAvoidBottomPadding: false,
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
                            ),
                            Flexible(child: SizedBox(height: 10)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'Our best videos',
                                style: TextStyle(
                                  shadows: [BoxShadow(blurRadius: 10.0, offset: Offset(10.0, 10.0), color: Colors.transparent.withOpacity(0.4))],
                                  fontSize: 25,
                                  color: Color(0xff341B5A),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Flexible(child: SizedBox(height: 10)),
                            Tabs(),
                            Flexible(child: SizedBox(height: 30)),
                            SlidingCardsView(),
                            Expanded(child: SizedBox(height: 8)),
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

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(width: 24),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Popular',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff341B5A),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 20.0,
          ),
        ),
        SizedBox(width: 10.0),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: Text(
            'Add Post',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          iconSize: 25.0,
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddVideoPage()));
          },
        ),
      ],
    );
  }
}
