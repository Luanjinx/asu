
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Future<ui.Image> loadImage(ImageProvider provider) async {
  final ImageStream stream =
      provider.resolve(const ImageConfiguration());
  final Completer<ui.Image> completer = Completer();

  late ImageStreamListener listener;
  listener = ImageStreamListener((ImageInfo info, _) {
    completer.complete(info.image);
    stream.removeListener(listener);
  });

  stream.addListener(listener);
  return completer.future;
}
