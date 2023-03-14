import 'package:gpt_test/services/openai_services.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class TextToSpeechService {
  final OpenAIService openAIService;

  TextToSpeechService({required this.openAIService});

  Future<Uint8List> generateSpeech(String text) async {
    final data = await openAIService.makeApiRequest(text);
    final audioUrl = data['audio_url'];

    final response = await http.get(Uri.parse(audioUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to generate audio: ${response.statusCode}');
    }
  }
}
