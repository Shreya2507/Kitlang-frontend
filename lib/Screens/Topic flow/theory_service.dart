import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:http/http.dart' as http;

class TheoryData {
  final String? theory;
  final String? story;
  final List<String>? examples;
  final List<Map<String, dynamic>>? questions;
  final List<Map<String, dynamic>>? learntWords;
  final String? error;

  TheoryData({
    this.theory,
    this.story,
    this.examples,
    this.questions,
    this.learntWords,
    this.error,
  });

  factory TheoryData.fromJson(Map<String, dynamic> json) {
    return TheoryData(
      theory: json['theory'] as String?,
      story: json['story'] as String?,
      examples: json['examples'] != null
          ? List<String>.from(json['examples'] as List)
          : <String>[],
      questions: json['questions'] != null
          ? List<Map<String, dynamic>>.from(json['questions'] as List)
          : <Map<String, dynamic>>[],
      learntWords: json['learnt_words'] != null
          ? List<Map<String, dynamic>>.from(json['learnt_words'] as List)
          : <Map<String, dynamic>>[],
    );
  }
}

class TheoryService {
  static Future<TheoryData> fetchTheory(
      int classIndex, int topicIndex, BuildContext? context) async {
    try {
      final language =
          (StoreProvider.of<AppState>(context!).state.language ?? 'german')
              .toLowerCase();
      print("hi $language");
      final level = StoreProvider.of<AppState>(context).state.level ??
          'beginner'; // Default to 'beginner'

      print('Hiiiiii$language');
      final url = Uri.parse(
        'https://saran-2021-api-gateway.hf.space/api/kitlang/get_theory/$classIndex/$topicIndex/german/beginner',
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
        if (data['theory'] == null && data['story'] == null) {
          return TheoryData(error: 'No content available in response');
        }

        print(data['learnt_words']);
        print(data['questions']);
        return TheoryData.fromJson(data);
      } else {
        return TheoryData(error: 'Failed to load story. Try again later.');
      }
    } catch (e) {
      return TheoryData(error: 'An error occurred: $e');
    }
  }
}
