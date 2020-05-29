import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  VideoPage({@required this.url, @required this.title, @required this.name});
  final String url, name, title;
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String url, name, title;
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    url = widget.url;
    name = widget.name;
    title = widget.title;
    _controller = VideoPlayerController.network('$url');
    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,
      looping: true,
      cupertinoProgressColors: ChewieProgressColors(backgroundColor: Colors.black, bufferedColor: Colors.grey, playedColor: Color(0xff341B5A), handleColor: Color(0xff341B5A)),
      materialProgressColors: ChewieProgressColors(backgroundColor: Colors.black, bufferedColor: Colors.grey, playedColor: Color(0xff341B5A), handleColor: Color(0xff341B5A)),
      showControlsOnInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text('Error loading video, please retry...', style: TextStyle(color: Colors.white)),
        );
      },
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _controller,
      aspectRatio: _controller.value.aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
    );
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        super.initState();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff341B5A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB144DA),
              Color(0xff341B5A),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                boxShadow: [BoxShadow(blurRadius: 20.0, spreadRadius: 10.0, offset: Offset(10.0, 10.0), color: Colors.transparent.withOpacity(0.7))],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 100.0),
                ),
              ),
              child: Center(
                child: Text(
                  'The VIT Music Club',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Color(0xff341B5A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 20.0)),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 20.0,spreadRadius: 10.0,offset: Offset(20.0, 10.0), color: Colors.transparent.withOpacity(0.6))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Chewie(controller: _chewieController),
              ),
            ),
            Flexible(child: SizedBox(height: 40.0)),
            Text(
              '$title',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 25.0, 0.0),
                child: Text(
                  '- $name',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 20.0)),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: RaisedButton(
                elevation: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_backspace),
                    SizedBox(width: 15.0),
                    Text('Go Back'),
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
