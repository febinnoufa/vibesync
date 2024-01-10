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

class Searchvideo extends StatefulWidget {
  const Searchvideo({Key? key}) : super(key: key);

  @override
  State<Searchvideo> createState() => SearchvideoState();
}

class SearchvideoState extends State<Searchvideo> {
  late Box<videohive>? videosBox;
  late TextEditingController searchController;
  List<videohive> filteredVideos = [];
    bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    openVideosBox();
    
  }

  Future<void> openVideosBox() async {
    videosBox = await Hive.openBox<videohive>('videosBox');
    filtervideos('');
     setState(() {
        _isInitialized = true;
      });
  }

  @override
  Widget build(BuildContext context) {


       if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or any loading indicator
        ),
      );
    }
    else{
    return 
    
    
    
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => filtervideos(value),
              controller: searchController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: 'Search',
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          filtervideos('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: videosBox == null
                    ? const Center(child: CircularProgressIndicator())
                    : filteredVideos.isEmpty
                        ? const Center(child: Text('No videos available'))
                        : ListView.builder(
                            itemCount: filteredVideos.length,
                            itemBuilder: (context, index) {
                              final video = filteredVideos[index];
                              return InkWell(
                                onTap: () {
                                  addToRecentlyPlayed(video.name);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayer_Page(
                                          videoUrl: video.name),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 75,
                                  margin: const EdgeInsets.only(
                                      top: 5, right: 5, left: 5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 239, 235, 235),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    leading: ValueListenableBuilder<Uint8List?>(
                                      valueListenable:
                                          generateThumbnailNotifier(video.name
                                              .createPath()), // Use Hive video path
                                      builder: (context, thumbnailData, child) {
                                        if (thumbnailData != null) {
                                          return Container(
                                            width: 100,
                                            height: 100,
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
                                      getvideoName(video),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 11, 11, 11)),
                                    ),
                                    trailing: PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            onTap: () {
                                              addToRecentlyPlayed(video.name);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayer_Page(
                                                          videoUrl: video.name),
                                                ),
                                              );
                                            },
                                            child: const Text('Play')),
                                        PopupMenuItem(
                                            onTap: () {
                                              toggleFavorite(
                                                  context, videosBox!, index);
                                            },
                                            // ignore: prefer_const_constructors
                                            child: Text('Add favorite')),
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
                                            child:
                                                const Text('Add to playlist')),
                                        PopupMenuItem(
                                          onTap: () {
                                            final video =
                                                videosBox!.getAt(index);
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
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
    }
  }

  //function_______________________**********//

  filtervideos(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredVideos = videosBox!.values.toList();
      } else {
        filteredVideos = videosBox!.values
            .where((vedio) =>
                vedio.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String getvideoName(videohive video) {
    List<String> pathSegments = video.name.split('/');
    String videoName = pathSegments.last;

    return videoName;
  }
}
