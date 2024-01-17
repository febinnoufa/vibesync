import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/tumbnail.dart';
import 'package:vibesync/videos/dbfunctions/recentlyfunc.dart';
import 'package:vibesync/videos/testingvideoplayer.dart';

class VideoFav extends StatefulWidget {
  const VideoFav({Key? key}) : super(key: key);

  @override
  State<VideoFav> createState() => VideoFavState();
}

class VideoFavState extends State<VideoFav> {
  late Box<Videofavorite>? videofavBox;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Hive.openBox<Videofavorite>('favoritevideosBox'),
        builder: (context, AsyncSnapshot<Box<Videofavorite>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos available'));
          } else {
            videofavBox = snapshot.data!;

            return ListView.builder(
              itemCount: videofavBox!.length,
              itemBuilder: (context, index) {
                final videoFavorite = videofavBox!.getAt(index);
                if (videoFavorite != null) {
                  return InkWell(
                    onTap: () {
                      addToRecentlyPlayed(videoFavorite.favoritevideo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(
                              videoPath: videoFavorite.favoritevideo),
                        ),
                      );
                    },
                    child: Container(
                      height: 75,
                      margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 235, 235),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: ValueListenableBuilder<Uint8List?>(
                          valueListenable: generateThumbnailNotifier(
                              videoFavorite.favoritevideo.createPath()),
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
                          getvideoName(videoFavorite.favoritevideo),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 11, 11, 11)),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            if (videofavBox != null) {
                              deleteVideo(index);
                            }
                          },
                          icon: const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
        },
      ),
    );
  }

  void deleteVideo(int index) {
    videofavBox?.deleteAt(index);
    setState(() {});
  }

  String getvideoName(video) {
    List<String> pathSegments = video.split('/');
    String videoName = pathSegments.last;
    // String name = songName.substring(0, 22);
    return videoName;
  }
}
