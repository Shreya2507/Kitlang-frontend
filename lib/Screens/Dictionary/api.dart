import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  static const String baseUrl = "https://saran-2021-dictionary.hf.space/";
  // static const String baseUrl = "http://192.168.1.138:8000/words/";
  // "http://10.0.2.2:8000/words/";
  // "https://api.dictionaryapi.dev/api/v2/entries/en/"

  static Future<Map<String, dynamic>> fetchMeaning(String word) async {
    final response = await http.get(Uri.parse("${baseUrl}words/$word"));
    print(response.statusCode);
    print("RESSSSSPONSE :${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("DATAAA :$data");
      return data as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load meaning");
    }
  }
}
