import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibesync/database/model/model.dart';

Future<void> addPlayListNamevedeo(String name) async {
  final playList = await Hive.openBox<videoplaylist>('videoplaylistBox');
  final data = videoplaylist(name: name, id: -1, videos: []);
  int id = await playList.add(data);
  data.id = id;
  await playList.put(id, data);
}
