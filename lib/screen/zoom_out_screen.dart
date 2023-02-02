import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:translate_application/screen/first_page.dart';
import 'package:flutter/material.dart';

class zoom_out_screen extends StatefulWidget {

  String zoom_out_value;
  zoom_out_screen({required this.zoom_out_value});

  @override
  State<zoom_out_screen> createState() => _zoom_out_screenState();
}

class _zoom_out_screenState extends State<zoom_out_screen> {

  TextToSpeech tts = TextToSpeech();

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     // DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //   ]);
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //       overlays: [SystemUiOverlay.bottom]);
  // }

  // @override
  // dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     // DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
          onTap: () {
            tts.speak(widget.zoom_out_value.toString());
            tts.setVolume(5);
            tts.getVoice();
          },
          child: Center(
              child: Text(
            "${widget.zoom_out_value}",
            style: TextStyle(fontSize: 45, color: Colors.teal),
          ))),
    );
  }
}
