import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(const SayHiApp());

class SayHiApp extends StatelessWidget {
  const SayHiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Say Hi Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SayHiHomePage(),
    );
  }
}

class SayHiHomePage extends StatefulWidget {
  const SayHiHomePage({super.key});

  @override
  State<SayHiHomePage> createState() => _SayHiHomePageState();
}

class _SayHiHomePageState extends State<SayHiHomePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';

  Future<void> _speakHi() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("Hi");
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('語音互動小幫手')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _speakHi,
              child: const Text('👋 播放「Hi」'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _listen,
              child: Text(_isListening ? '🛑 停止說話' : '🎤 開始說話'),
            ),
            const SizedBox(height: 20),
            Text(
              _spokenText.isEmpty ? '請說話...' : '你說了：$_spokenText',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
