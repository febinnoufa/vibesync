import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/shareapp/sharevideo.dart';
import 'package:vibesync/tumbnail.dart';
import 'package:vibesync/videos/dbfunctions/favfunc.dart';
import 'package:vibesync/videos/dbfunctions/recentlyfunc.dart';
import 'package:vibesync/videos/flick.dart';
import 'package:vibesync/videos/playlistaddlist.dart';
import 'package:vibesync/videos/testingvideoplayer.dart';

class Resentlyplayedvideo extends StatefulWidget {
  const Resentlyplayedvideo({Key? key}) : super(key: key);

  @override
  State<Resentlyplayedvideo> createState() => _ResentlyplayedvideoState();
}

class _ResentlyplayedvideoState extends State<Resentlyplayedvideo> {
  late Box<videohive>? recentlyPlayedBox;
  // ignore: prefer_collection_literals
  Set<String> displayedVideos = Set();
  bool _isLoading = true;
  // late Box<videohive> videosBox;

  @override
  void initState() {
    super.initState();
    openRecentlyPlayedBox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 24, 22, 22),
          title: const Text('Recently Played Videos'),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildVideoList(),
        ),
      ),
    );
  }

  Widget buildVideoList() {
    if (recentlyPlayedBox == null || recentlyPlayedBox!.isEmpty) {
      return const Center(
        child: Text('No video available'),
      );
    } else {
      List<videohive?> video = recentlyPlayedBox!.values.toList();
      video = video.reversed.toList();
      return ListView.builder(
        itemCount: video.length,
        itemBuilder: (context, index) {
          final videos = video[index];
          if (videos != null) {
            if (displayedVideos.contains(videos.name)) {
              return const SizedBox();
            }
            displayedVideos.add(videos.name);
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 235, 235),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      final video = recentlyPlayedBox?.getAt(index);
                      if (video != null) {
                        addToRecentlyPlayed(videos.name);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                               VideoPlayerPage(videoPath: videos.name),
                          ),
                        );
                      }
                    },
                    leading: ValueListenableBuilder<Uint8List?>(
                      valueListenable:
                          generateThumbnailNotifier(videos.name.createPath()),
                      builder: (context, thumbnailData, child) {
                        if (thumbnailData != null) {
                          return Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                thumbnailData,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return      Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15), // Change the radius value as needed
    border: Border.all(
      color: Colors.black, // Border color
      width: 2, // Border width
    ),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(15), // Ensure this value matches the container's border radius
    child: Image.network(
      'https://i.pinimg.com/236x/4f/d7/6d/4fd76d56dae62a30deecced88bee0567.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.cover, // This ensures the image fills the container without distortion
    ),
  ),
);
                        }
                      },
                    ),
                    title: Text(
                      getVideoName(videos),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () {
                              final video = recentlyPlayedBox?.getAt(index);
                              if (video != null) {
                                addToRecentlyPlayed(videos.name);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VideoPlayerPage(videoPath: videos.name),
                                  ),
                                );
                              }
                            },
                            child: const Text('Play')),
                        PopupMenuItem(
                          onTap: () {
                            // print('/??????????????????????????$videosBox');

                            toggleFavorite(context, recentlyPlayedBox!, index);
                          },
                          child: const Text('Favorite'),
                        ),
                        PopupMenuItem(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Videolisttoaddplaylist(vedios: videos),
                                  ));
                            },
                            child: const Text('Add to playlist')),
                        PopupMenuItem(
                          onTap: () {
                            //final video = recentlyPlayedBox?.getAt(index);
                            shareVideo(videos.name);
                          },
                          child: const Text('Share'),
                        ),
                      ],
                      child: const Icon(
                        Icons.more_vert,
                        color: Color.fromARGB(255, 20, 20, 20),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      );
    }
  }

  // functions //************************************* */

  String getVideoName(videohive video) {
    List<String> pathSegments = video.name.split('/');
    String videoName = pathSegments.last;
    return videoName;
  }

  Future<void> openRecentlyPlayedBox() async {
    recentlyPlayedBox = await Hive.openBox<videohive>('recentlyPlayedBox');
    setState(() {
      _isLoading = false;
    });
  }
}
