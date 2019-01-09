import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

final Color baseColor = const Color(0xffBF844C);
final AudioPlayer audioPlayer = AudioPlayer();

playMusic(String filePath) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/$filePath");
  if (!(await file.exists())) {
    final soundData = await rootBundle.load("assets/$filePath");
    final bytes = soundData.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
  }
  audioPlayer.play(file.path, isLocal: true, volume: 0.3);

  audioPlayer.completionHandler = () {
    audioPlayer.play(file.path, isLocal: true, volume: 0.3);
  };
}