class AppState {
  final String? userId;
  final String? level;
  final String? language;

  AppState({this.userId, this.level, this.language});

  AppState copyWith({String? userId, String? level, String? language}) {
    return AppState(
      userId: userId ?? this.userId,
      level: level ?? this.level,
      language: language ?? this.language,
    );
  }
}
