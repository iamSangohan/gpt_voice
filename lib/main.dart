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
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  margin: const EdgeInsets.only(bottom: 150),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: isSpeaking ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Ubuntu',
                    ),
                  ))),
          const Text(
            "Dev with ❤ by Sangohan",
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isSpeaking,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.blue,
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isSpeaking) {
              var available = await speech.initialize();
              if (available) {
                setState(() {
                  isSpeaking = true;
                  speech.listen(
                      onResult: (result) {
                        setState(() {
                          text = result.recognizedWords;
                        });
                      },
                      pauseFor: const Duration(seconds: 10));
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isSpeaking = false;
            });
            speech.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 35,
            child: Icon(
              isSpeaking ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
