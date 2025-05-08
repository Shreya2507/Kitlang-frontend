import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static Future<Map<String, String>> getGermanTranslations(
    List<String> fruitNames,
  ) async {
    final url = Uri.parse(
      'https://saran-2021-api-gateway.hf.space/api/dict/list_translate',
    );

    try {
      // Convert list of fruits to JSON string
      String wordsJson = jsonEncode(fruitNames);

      // Make the multipart request
      var request =
          http.MultipartRequest('POST', url)
            ..fields['target_lang'] =
                'german' // not 'de'
            ..fields['words'] =
                wordsJson; // Already in correct JSON string format

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('Server responded with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching translations: $e');
    }
  }
}
