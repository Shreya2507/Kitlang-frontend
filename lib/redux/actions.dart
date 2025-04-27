class SetUserIdAction {
  final String? userId;

  SetUserIdAction(this.userId);
}

class SetUserLanguageAction {
  final String language;
  SetUserLanguageAction(this.language);
}

class SetUserLevelAction {
  final String? level;
  SetUserLevelAction(this.level);
}

class SetCompletedTopicsAction {
  final Map<String, dynamic> completedTopics;
  SetCompletedTopicsAction(this.completedTopics);
}

class ChangeLanguageAction {
  final String languageCode;
  

  ChangeLanguageAction(this.languageCode);
}

// Action to store the translated text in the app state
class SetTranslatedTextAction {
  final String translatedText;
  SetTranslatedTextAction(this.translatedText);
}

class FetchUserProgressAction {}
