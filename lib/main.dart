import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  stt.SpeechToText speech = stt.SpeechToText();
  bool isSpeaking = false;
  String _text = '';

  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    isSpeaking = await speech.initialize();
    setState(() {});
  }

  void _startListening() async {
    var available = await speech.initialize();
    if (available) {
      setState(() {
        isSpeaking = true;
        speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
        );
      });
    }
  }

  void _stopListening() async {
    await speech.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              reverse: true,
              physics:  const BouncingScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                margin: const EdgeInsets.only(bottom: 150),
                child: Text(
                  style: const TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  // If listening is active show the recognized words
                  speech.hasRecognized
                      ? '$_text'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : isSpeaking
                          ? 'Appuyer le micro et commencer à parler...'
                          : 'Parole non disponible',
                ),
              ),
            ),
            Text(
              "Dev with ❤ by Sangohan",
              style: const TextStyle(
                fontSize: 10.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: AvatarGlow(
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        animate: isSpeaking,
        showTwoGlows: true,
        child: FloatingActionButton(
          onPressed: speech.isNotListening ? _startListening : _stopListening,
          tooltip: 'Listen',
          child: Icon(speech.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
