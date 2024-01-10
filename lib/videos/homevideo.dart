import 'package:flutter/material.dart';
import 'package:vibesync/home.dart';
import 'package:vibesync/musics/homemsuic.dart';
import 'package:vibesync/videos/playlistvieo.dart';
import 'package:vibesync/videos/searchvideo.dart';
import 'package:vibesync/videos/videofavrate.dart';
import 'package:vibesync/videos/videolist.dart';

class HomeVideo extends StatefulWidget {
  const HomeVideo({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Home_VideoState createState() => _Home_VideoState();
}

// ignore: camel_case_types
class _Home_VideoState extends State<HomeVideo> {
  bool isSearchClicked = false;
  late TextEditingController searchController;

  void onSearchChanged(String value) {
    setState(() {
     
    });
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 135,
                color: const Color.fromARGB(255, 83, 214, 193),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ListTile(
                        title: isSearchClicked
                            ? Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextField(
                                  controller: searchController,
                                  onChanged: onSearchChanged,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 20, 16, 12),
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                  ),
                                ),
                              )
                            : const Text(
                                'VIDEOS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 8, 8, 8),
                                ),
                              ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:  (context) => const Searchvideo(),));
                          
                          },
                          icon: Icon(
                            isSearchClicked ? Icons.close : Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Videos'),
                        Tab(text: 'Playlist'),
                        Tab(text: 'Favorite'),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    Videolist(),
                    Playlistvideo(),
                   VideoFav(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_sharp),
            label: 'Musics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video_sharp),
            label: 'Videos',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 232, 6, 6),
        unselectedItemColor: const Color.fromARGB(255, 22, 22, 22),
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Homescreen(),
              ),
            );
          }
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Music_Home(),
              ),
            );
          }
        },
      ),
    );
  }
}
