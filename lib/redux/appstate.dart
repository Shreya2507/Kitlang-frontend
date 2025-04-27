class AppState {
  final String? userId;
  final String? level;
  final Map<String, dynamic> completedTopics;
  final int streak;
  final String? selectedLanguageCode; // Language code for the selected language (e.g., "en", "fr", "es")
  final String? language; // The language selected by the user, e.g., "English", "French"

  AppState({
    this.userId,
    this.level,
    Map<String, dynamic>? completedTopics,
    this.streak = 0,
    this.selectedLanguageCode,
    this.language,
  }) : completedTopics = completedTopics ?? {};

  AppState copyWith({
    String? userId,
    String? level,
    Map<String, dynamic>? completedTopics,
    int? streak,
    String? selectedLanguageCode,
    String? language,
  }) {
    return AppState(
      userId: userId ?? this.userId,
      level: level ?? this.level,
      completedTopics: completedTopics ?? this.completedTopics,
      streak: streak ?? this.streak,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      language: language ?? this.language,
    );
  }
}
