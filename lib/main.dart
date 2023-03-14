import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gpt_test/services/openai_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  OpenAIService _openaiService = OpenAIService();
  String _prompt = 'a cat playing the piano';

  String _imageURL = '';
  bool _isImageLoading = false;
  String _speechText = '';
  bool _isSpeechLoading = false;
  List<int> _audioData = [];

  void _generateImage() async {
    setState(() {
      _isImageLoading = true;
    });
    try {
      final url = await _openaiService.generateImage(_prompt);
      setState(() {
        _imageURL = url;
        _isImageLoading = false;
      });
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      print(e);
    }
  }

  void _generateSpeech() async {
    setState(() {
      _isSpeechLoading = true;
    });
    try {
      final data = await _openaiService.generateSpeech(_speechText);
      setState(() {
        _audioData = data;
        _isSpeechLoading = false;
      });
      final path = await _saveAudioFile(data);
      _playAudioFile(path);
    } catch (e) {
      setState(() {
        _isSpeechLoading = false;
      });
      print(e);
    }
  }

  Future<String> _saveAudioFile(List<int> data) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/speech.wav';
    final file = File(filePath);
    await file.writeAsBytes(data);
    return filePath;
  }

  Future<void> _playAudioFile(String filePath) async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.play(filePath, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OpenAI Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: _isImageLoading
                    ? CircularProgressIndicator()
                    : _imageURL.isNotEmpty
                        ? Image.network(_imageURL)
                        : Container(),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _prompt = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter a prompt...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateImage,
                child: _isImageLoading
                    ? CircularProgressIndicator()
                    : Text('Generate Image'),
              ),
              SizedBox(height: 50),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _speechText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter text for speech...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateSpeech,
                child: _isSpeechLoading
                    ? CircularProgressIndicator()
                    : Text('Generate Speech'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
