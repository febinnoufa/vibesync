import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

Future<void> addVideosToHive(List<dynamic> videoPaths) async {
  final Box<videohive> boxvideo = await Hive.openBox<videohive>('videosBox');

  for (var videoPath in videoPaths) {
    final video = videohive(name: videoPath.toString());
    await boxvideo.add(video);
  }
}
