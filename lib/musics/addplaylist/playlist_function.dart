import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibesync/database/model/model.dart';

Future<void> addPlayListName(String name) async {
  final playList = await Hive.openBox<Songplaylist>('songplaylistBox');
  final data = Songplaylist(name: name, id: -1, songs: []);
  int id = await playList.add(data);
  data.id = id;
  await playList.put(id, data);
}
