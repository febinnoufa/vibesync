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

class Videolist extends StatefulWidget {
  const Videolist({super.key});

  @override
  State<Videolist> createState() => VideoListState();
}

class VideoListState extends State<Videolist> {
  List<dynamic> videos = [];

  @override
  void initState() {
    super.initState();
    
    openRecentlyPlayedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 200, 200, 200),
        child: Center(
          child: FutureBuilder(
            future: Hive.openBox<videohive>('videosBox'),
            builder: (context, AsyncSnapshot<Box<videohive>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final videosBox = snapshot.data!;

              return Scrollbar(
                trackVisibility: true,

                thickness: 10,
                radius: const Radius.circular(20),
                //interactive: true,
                child: ListView.builder(
                  itemCount: videosBox.length,
                  itemBuilder: (context, index) {
                    videohive? video = videosBox.getAt(index);
                    // ignore: avoid_print
                    print('........${video!.name}');
                    return Column(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(top: 5, right: 5, left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 239, 235, 235),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: ValueListenableBuilder<Uint8List?>(
                              valueListenable: generateThumbnailNotifier(
                                  video.name.createPath()),
                              builder: (context, thumbnailData, child) {
                                if (thumbnailData != null) {
                                  return Container(
                                    width: 100,
                                    height: 100,
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
                                  return
                                  
                           Container(
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
                              getvideoName(video),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 11, 11, 11)),
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    onTap: () {
                                      final video = videosBox.getAt(index);
                                      if (video != null) {
                                        addToRecentlyPlayed(video.name);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayer_Page(
                                                    videoUrl: video.name),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Play')),
                                PopupMenuItem(
                                  onTap: () {
                                    toggleFavorite(context, videosBox, index);
                                  },
                                  child: const Text('Favorite'),
                                ),
                                PopupMenuItem(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Videolisttoaddplaylist(
                                                    vedios: video),
                                          ));
                                    },
                                    child: const Text('Add to playlist')),
                                PopupMenuItem(
                                  onTap: () {
                                    final video = videosBox.getAt(index);
                                    if (video != null) {
                                      shareVideo(video.name);
                                    }
                                  },
                                  child: const Text('Share'),
                                ),
                              ],
                              child: const Icon(
                                Icons.more_vert,
                                color: Color.fromARGB(255, 20, 20, 20),
                              ),
                            ),
                            onTap: () {
                              final video = videosBox.getAt(index);
                              if (video != null) {
                                addToRecentlyPlayed(video.name);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VideoPlayer_Page(videoUrl: video.name),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String getvideoName(videohive video) {
    List<String> pathSegments = video.name.split('/');
    String videoName = pathSegments.last;

    return videoName;
  }
}
