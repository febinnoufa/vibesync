import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/functions/songplay.dart';
import 'package:vibesync/musics/songlistaddtoplaylist.dart';
import 'package:vibesync/settings/settings.dart';

// ignore: must_be_immutable
class MusicPlayerPage extends StatefulWidget {
  String songFilePath;

  MusicPlayerPage({Key? key, required this.songFilePath}) : super(key: key);

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool isPlaying = false;
  double _currentSliderValue = 0.0;
  bool isFavorite = false;
  bool isRepeated = false;
  late Box<songshive> songsBox;

  late Box<Songfavorite> foundsongfav;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    checkSongBoxForFilePath(widget.songFilePath);

    checkIfFavorite();
    try {
      _initAudioPlayer();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "VibeSync",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Songlistaddplaylist(song: foundSong!),
                                    ));
                              },
                              child: const Text('Add to playlist')),
                          const PopupMenuItem(child: Text('Refresh')),
                          PopupMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Settings(),
                                    ));
                              },
                              child: const Text('Settings')),
                        ],
                    child: const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 249, 248, 248),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(screenWidth * 0.1),
                    topLeft: Radius.circular(screenWidth * 0.1),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.03),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.08),
                      child: IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "Adjust volume",
                            divisions: 10,
                            min: 0.0,
                            max: 1.0,
                            value: audioPlayer.volume,
                            stream: audioPlayer.volumeStream,
                            onChanged: audioPlayer.setVolume,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Center(
                    child: Container(
                      height: screenHeight * 0.3,
                      width: screenHeight * 0.3,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          'assets/images/mylogo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.6,
                      child: Text(
                        getsongName(widget.songFilePath),
                        style: const TextStyle(
                          fontSize: 24,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.10),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.1, right: screenWidth * 0.15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${Duration(milliseconds: _currentSliderValue.toInt()).toString().split('.')[0]}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Duration(
                                  milliseconds:
                                      audioPlayer.duration?.inMilliseconds ?? 0)
                              .toString()
                              .split('.')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: _currentSliderValue.clamp(0.0,
                        audioPlayer.duration?.inMilliseconds.toDouble() ?? 0.0),
                    min: 0.0,
                    max: audioPlayer.duration?.inMilliseconds.toDouble() ?? 0.0,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                    onChangeEnd: (double value) {
                      audioPlayer.seek(Duration(milliseconds: value.toInt()));
                    },
                    activeColor: Colors.red,
                    inactiveColor: Colors.grey.shade500,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 38, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.repeat,
                            size: 30,
                            color: isRepeated
                                ? const Color.fromARGB(255, 185, 114, 108)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isRepeated = !isRepeated;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, size: 30),
                          onPressed: () async {
                            final currentPosition = audioPlayer.position;
                            const tenSeconds = Duration(seconds: 10);

                            if (currentPosition >= tenSeconds) {
                              await audioPlayer.seek(Duration.zero);
                              await audioPlayer.play();
                            } else {
                              stopSong();

                              int currentIndex = findCurrentSongIndexInBox(
                                  widget.songFilePath);

                              if (currentIndex != -1 && currentIndex > 0) {
                                playPreviousSong(currentIndex - 1);
                                await _initAudioPlayer();
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: FloatingActionButton(
                            onPressed: () {
                              isPlaying ? stopSong() : togglePlayPause();
                            },
                            backgroundColor: Colors.deepPurple,
                            child: isPlaying
                                ? const Icon(Icons.pause, color: Colors.white)
                                : const Icon(Icons.play_arrow,
                                    color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, size: 30),
                          onPressed: () {
                            int currentIndex =
                                findCurrentSongIndexInBox(widget.songFilePath);

                            if (currentIndex != -1 &&
                                currentIndex < songBox.length - 1) {
                              playNextSong(currentIndex + 1);
                            }
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            await toggleFavorite();
                            if (isFavorite) {
                              addToFavorites(widget.songFilePath);
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void playNextSong(int index) async {
    final nextSong = songBox.getAt(index);
    if (nextSong != null) {
      setState(() {
        widget.songFilePath = nextSong.name;
      });
      await _initAudioPlayer();
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      await audioPlayer.setFilePath(widget.songFilePath);
      audioPlayer.play();
      setState(() {
        isPlaying = true;
      });

      // Listen to the playback position and update the slider accordingly
      _positionSubscription = audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentSliderValue = position.inMilliseconds.toDouble();
          });
        }
      });

      // Listen to player state changes
      _playerStateSubscription =
          audioPlayer.playerStateStream.listen((playerState) async {
        if (mounted)
        // ignore: curly_braces_in_flow_control_structures
        if (playerState.processingState == ProcessingState.completed) {
          if (isRepeated) {
            // If repeat is enabled, seek to the beginning of the song and play it again
            await audioPlayer.seek(Duration.zero);
            await audioPlayer.play();
          } else {
            // Find the index of the current song
            int currentIndex = findCurrentSongIndexInBox(widget.songFilePath);

            // Play the next song if available
            if (currentIndex != -1 && currentIndex < songBox.length - 1) {
              playNextSong(currentIndex + 1);
            }
          }
        }
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void playPreviousSong(int index) async {
    final previousSong = songBox.getAt(index);
    if (previousSong != null) {
      setState(() {
        widget.songFilePath = previousSong.name;
      });
    }
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void stopSong() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> checkIfFavorite() async {
    final favoritesBox = await Hive.openBox<Songfavorite>('favoritesongsBox');
    isFavorite = favoritesBox.containsKey(widget.songFilePath);

    setState(() {});
  }

  Future<void> toggleFavorite() async {
    final favoritesBox = await Hive.openBox<Songfavorite>('favoritesongsBox');
    if (isFavorite) {
      await favoritesBox.delete(widget.songFilePath);
    } else {
      final songFavorite = Songfavorite(favoritesong: widget.songFilePath);
      await favoritesBox.put(widget.songFilePath, songFavorite);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _playerStateSubscription.cancel();
    audioPlayer.dispose();
    super.dispose();
  }
}
