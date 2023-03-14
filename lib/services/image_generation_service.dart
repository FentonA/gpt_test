import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:gpt_test/services/openai_services.dart';

class ImageGenerationService {
  final OpenAIService openAIService;

  ImageGenerationService({required this.openAIService});

  Future<Uint8List> generateImage(String prompt) async {
    final data = await openAIService.makeApiRequest(prompt);
    final imageUrl = data['output']['url'];

    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to generate image: ${response.statusCode}');
    }
  }
}
