import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

ValueNotifier<Uint8List?> generateThumbnailNotifier(String videoPath) {
  final thumbnailNotifier = ValueNotifier<Uint8List?>(null);

  VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 128,
    quality: 100,
  ).then((thumbnailData) {
    thumbnailNotifier.value = thumbnailData;
  }).catchError((error, stackTrace) {
    thumbnailNotifier.value = null;
  });

  return thumbnailNotifier;
}
