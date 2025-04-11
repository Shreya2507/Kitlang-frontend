import 'dart:convert';
import 'package:http/http.dart' as http;

class TheoryData {
  final String? theory;
  final String? story;
  final List<String>? examples;
  final List<Map<String, dynamic>>? questions;
  final String? error;

  TheoryData({
    this.theory,
    this.story,
    this.examples,
    this.questions,
    this.error,
  });

  factory TheoryData.fromJson(Map<String, dynamic> json) {
    return TheoryData(
      theory: json['theory'],
      story: json['story'],
      examples:
          json['examples'] != null ? List<String>.from(json['examples']) : null,
      questions: json['questions'] != null
          ? List<Map<String, dynamic>>.from(json['questions'])
          : null,
    );
  }
}

class TheoryService {
  static Future<TheoryData> fetchTheory(int classIndex, int topicIndex) async {
    try {
      final url = Uri.parse(
        'https://saran-2021-backend-kitlang.hf.space/get_theory/$classIndex/$topicIndex/German/beginner',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        print(data);
        return TheoryData.fromJson(data);
      } else {
        return TheoryData(error: 'Failed to load story. Try again later.');
      }
    } catch (e) {
      return TheoryData(error: 'An error occurred: $e');
    }
  }
}
