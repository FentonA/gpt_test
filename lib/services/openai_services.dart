import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = 'your_api_key_here';

  Future<String> generateImage(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
      },
      body: jsonEncode({
        'model': 'image-alpha-001',
        'prompt': prompt,
        'num_images': 1,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'][0]['url'];
      return data;
    } else {
      throw Exception('Failed to generate image');
    }
  }

  Future<List<int>> generateSpeech(String text) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/speeches/gpt3'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
      },
      body: jsonEncode({
        'text': text,
        'voice': 'text-to-speech-1',
        'speed': 1,
        'pitch': 1,
      }),
    );
    if (response.statusCode == 200) {
      final data = base64.decode(jsonDecode(response.body)['data']);
      return data;
    } else {
      throw Exception('Failed to generate speech');
    }
  }
}
