import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  double _volume = 1.0;
  bool _isFullScreen = false;
  bool _areControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoPath);
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {}));
    _videoController.play();

    // Hide controls initially
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Toggle visibility of controls
          setState(() {
            _areControlsVisible = !_areControlsVisible;
          });

          // Restart the timer to hide controls after 10 seconds
          _startHideControlsTimer();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            OrientationBuilder(
              builder: (context, orientation) {
                return Container(
                  color: Colors.black, // Set background color
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                );
              },
            ),
            Visibility(
              visible: _areControlsVisible,
              child: _buildMediaControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.fullscreen_exit, color: Colors.white),
                onPressed: () {
                  // Rotate the video to the left (counter-clockwise)
                  _rotateVideo(-90);
                },
              ),
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white),
                onPressed: () {
                  _videoController.seekTo(
                    Duration(seconds: _videoController.value.position.inSeconds - 10),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_videoController.value.isPlaying) {
                      _videoController.pause();
                    } else {
                      _videoController.play();
                    }
                  });
                },
                icon: Icon(
                  _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white),
                onPressed: () {
                  _videoController.seekTo(
                    Duration(seconds: _videoController.value.position.inSeconds + 10),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.crop_rotate, color: Colors.white),
                onPressed: () {
                  // Toggle fullscreen mode
                  _toggleFullScreen();
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Expanded(
              //   child: Slider(
              //     value: _videoController.value.position.inSeconds.toDouble(),
              //     min: 0.0,
              //     max: _videoController.value.duration!.inSeconds.toDouble(),
              //     onChanged: (value) {
              //       final Duration newPosition = Duration(seconds: value.round());
              //       _videoController.seekTo(newPosition);
              //     },
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 16),
          VideoProgressIndicator(
            _videoController,
            allowScrubbing: true,
          ),
        ],
      ),
    );
  }

  void _rotateVideo(double degrees) {
    // Rotate the video
    _videoController.setPlaybackSpeed(1.0); // Reset playback speed
    _videoController.setVolume(1.0); // Reset volume
    _videoController.setLooping(false); // Disable looping

    _videoController.pause(); // Pause the video while rotating

    // Calculate the new aspect ratio after rotation
    double newAspectRatio = _videoController.value.aspectRatio;
    if (degrees == 90 || degrees == -90) {
      newAspectRatio = 1 / _videoController.value.aspectRatio;
    }

    // Update the existing controller's properties
    _videoController.value = _videoController.value.copyWith(
      size: Size(
        _videoController.value.size.height,
        _videoController.value.size.width,
      ),
    );

    _videoController.play(); // Resume playing after rotation
  }

  void _onTapVideo(TapDownDetails details) {
    // Calculate the seek position based on tap position
    final double position = details.localPosition.dx / MediaQuery.of(context).size.width;
    _videoController.seekTo(Duration(seconds: (_videoController.value.duration!.inSeconds * position).round()));

    // Show controls when tapping on the video
    setState(() {
      _areControlsVisible = true;
    });

    // Restart the timer to hide controls after 10 seconds
    _startHideControlsTimer();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _startHideControlsTimer() {
    // Start a timer to hide controls after 10 seconds
    Timer(Duration(seconds: 10), () {
      setState(() {
        _areControlsVisible = false;
      });
    });
  }
}
