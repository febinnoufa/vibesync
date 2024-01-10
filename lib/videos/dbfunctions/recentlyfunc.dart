import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

late Box<videohive> recentlyPlayedBox;

Future<void> openRecentlyPlayedBox() async {
  recentlyPlayedBox = await Hive.openBox<videohive>('recentlyPlayedBox');
}

void addToRecentlyPlayed(String videoPath) async {
  final video = videohive(name: videoPath);
  await recentlyPlayedBox.add(video);
}
