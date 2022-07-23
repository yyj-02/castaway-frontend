import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main.dart';

void main() => runApp(const MyApp());

class AudioRecorder extends StatefulWidget {
  const AudioRecorder({Key? key}) : super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted){
      print("Mic available");
    }
    if (status != PermissionStatus.granted){
      throw "Mic not available";
    }
    await recorder.openRecorder();
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    final audiofile = File(path!);
    print("Recorded audio $audiofile");


  }


  @override
  Widget build(BuildContext context) {
    // Timer.periodic(const Duration(seconds: 5), (Timer t) => stop());
    // Timer.periodic(const Duration(seconds: 5), (Timer t) => record());
    return MaterialApp(
      home: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () async {
              if (recorder.isRecording) {
                await stop();
              } else {
                await record();
              }
            },
            child:
                Icon(recorder.isRecording ? Icons.stop : Icons.mic, size: 80),
          )
        ]),
      ),
    );
  }
}
