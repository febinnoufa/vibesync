import 'package:fetch_all_videos/fetch_all_videos.dart';
import 'package:vibesync/videos/dbfunctions/addtohive.dart';

Future<void> fetchVideos() async {
    FetchAllVideos ob = FetchAllVideos();
    List<dynamic> videoPaths = await ob.getAllVideos();
    addVideosToHive(videoPaths);
  }
