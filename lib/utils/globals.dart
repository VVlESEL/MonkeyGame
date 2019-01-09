import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

final Color baseColor = const Color(0xffBF844C);

///lifecycle state of the app
AppLifecycleState lifecycleState;

///height of the monkey
final double monkeyHeight = 80.0;

///width of the monkey
final double monkeyWidth = 80.0;

///height of visible game stack
double screenHeight;

///width of visible game stack
double screenWidth;

///current x value of the monkey
double monkeyX = 100.0;

///state of the monkey
bool monkeyIsDizzy = false;

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