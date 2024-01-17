import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/tumbnail.dart';
import 'package:vibesync/videos/testingvideoplayer.dart';

class VideohorList extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const VideohorList({Key? key});

  @override
  State<VideohorList> createState() => VideohorListState();
}

class VideohorListState extends State<VideohorList> {
  late Box<videohive>? recentlyPlayedBox;
  // ignore: prefer_collection_literals
  Set<String> displayedVideos = Set();

  @override
  void initState() {
    super.initState();
    openRecentlyPlayedBox();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<videohive>>(
      future: Hive.openBox<videohive>('recentlyPlayedBox'),
      builder: (context, AsyncSnapshot<Box<videohive>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final box = snapshot.data!;
          if (box.isEmpty) {
            return const Center(child: Text('No videos available'));
          } else {
            List<videohive> videos = [];

            for (int i = box.length - 1; i >= 0; i--) {
              final video = box.getAt(i);
              if (video != null && !displayedVideos.contains(video.name)) {
                videos.add(video);
                displayedVideos.add(video.name);
              }
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length > 5 ? 5 : videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 253, 253),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        child: SizedBox(
                          height: 134,
                          width: 170,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 80,
                                child: ValueListenableBuilder<Uint8List?>(
                                  valueListenable: generateThumbnailNotifier(
                                      video.name.createPath()),
                                  builder: (context, thumbnailData, child) {
                                    if (thumbnailData != null) {
                                      return Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            thumbnailData,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15), // Change the radius value as needed
                                          border: Border.all(
                                            color: Colors.black, // Border color
                                            width: 2, // Border width
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              15), // Ensure this value matches the container's border radius
                                          child: Image.network(
                                            'https://i.pinimg.com/236x/4f/d7/6d/4fd76d56dae62a30deecced88bee0567.jpg',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit
                                                .cover, // This ensures the image fills the container without distortion
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                getvideoName(video),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(
                                videoPath: video.name,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 121, 118, 118),
                    )
                  ],
                );
              },
            );
          }
        } else {
          return const Center(child: Text('Error loading videos'));
        }
      },
    );
  }

  // function__________********************//

  Future<void> openRecentlyPlayedBox() async {
    recentlyPlayedBox = await Hive.openBox<videohive>('recentlyPlayedBox');
    setState(() {});
  }

  String getvideoName(videohive video) {
    List<String> pathSegments = video.name.split('/');
    String videoName = pathSegments.last;

    return videoName;
  }
}
