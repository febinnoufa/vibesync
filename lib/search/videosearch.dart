import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

bool issearchclicked = false;
final TextEditingController searchcontroller = TextEditingController();
String textsearch = '';
List<videohive> filteritems = [];

void myfilteritems(String textsearch, Box<videohive> boxvideo) {
  if (textsearch.isEmpty) {
    filteritems = List.from(boxvideo.values); 
  } else {
    filteritems = boxvideo.values
        .where(
          (item) => item.name.toLowerCase().contains(textsearch.toLowerCase()),
        )
        .cast<videohive>()
        .toList();
  }
}
