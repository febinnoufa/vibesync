import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoController;
  bool _isFullScreen = false;
  bool _areControlsVisible = true;
  late Timer _hideControlsTimer;

  @override
  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _videoController = VideoPlayerController.network(widget.videoPath);
    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {}));
    _videoController.play();

    // Hide controls initially
    _hideControlsTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        _areControlsVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _hideControlsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (_) {
          // Toggle visibility of controls
          _toggleControlsVisibility();
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

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.rotate_left),
                title: const Text('Rotate Left'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _rotateVideo(-90);
                },
              ),
              ListTile(
                leading: const Icon(Icons.rotate_right),
                title: const Text('Rotate Right'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _rotateVideo(90);
                },
              ),
              // Add more options as needed
            ],
          ),
        );
      },
    );
  }

// Modify your _buildMediaControls method to include the more options button
  Widget _buildMediaControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
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
            VideoProgressIndicator(
              _videoController,
              allowScrubbing: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: () {
                    // Show more options when full-screen exit button is clicked
                    _showMoreOptions();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10, color: Colors.white),
                  onPressed: () {
                    _videoController.seekTo(
                      Duration(
                          seconds:
                              _videoController.value.position.inSeconds - 10),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    _togglePlayPause();
                  },
                  icon: Icon(
                    _videoController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10, color: Colors.white),
                  onPressed: () {
                    _videoController.seekTo(
                      Duration(
                          seconds:
                              _videoController.value.position.inSeconds + 10),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.crop_rotate, color: Colors.white),
                  onPressed: () {
                    // Toggle fullscreen mode
                    _toggleFullScreen();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
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
    if (degrees == 90 || degrees == -90) {
    }

    // Update the existing controller's properties
    _videoController.value = _videoController.value.copyWith(
      size: Size(
        _videoController.value.size.height,
        _videoController.value.size.width,
      ),
    );

    _videoController.play(); // Resume playing after rotation

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

  void _toggleControlsVisibility() {
    // Toggle visibility of controls
    setState(() {
      _areControlsVisible = !_areControlsVisible;
    });

    // Restart the timer to hide controls after 10 seconds
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    // Cancel the existing timer
    _hideControlsTimer.cancel();

    // Start a timer to hide controls after 10 seconds
    _hideControlsTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        _areControlsVisible = false;
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });

    // Restart the timer to hide controls after 10 seconds
    _startHideControlsTimer();
  }
}
