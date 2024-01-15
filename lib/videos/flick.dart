import 'package:flutter/material.dart';
//import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

// ignore: camel_case_types
class VideoPlayer_Page extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer_Page({Key? key, required this.videoUrl}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayer_Page> {
  //late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    // flickManager = FlickManager(
    //   // ignore: deprecated_member_use
    //   videoPlayerController: VideoPlayerController.network(widget.videoUrl),
    // );
  }

  @override
  void dispose() {
    //flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 return Scaffold(
  appBar: PreferredSize(
    preferredSize: const Size.fromHeight(40.0), 
    child: AppBar(
      backgroundColor: Colors.black,
      elevation: 0, 
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 170, 168, 168),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  ),
  // body: Center(
  //   child: FlickVideoPlayer(
  //     flickManager: flickManager,
  //   ),
  // ),
);

  }
}
