import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/appstate.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetUserIdAction) {
    return state.copyWith(userId: action.userId);
  } else if (action is SetUserLevelAction) {
    return state.copyWith(level: action.level);
  } else   if (action is SetUserLanguageAction) {
    return state.copyWith(language: action.language);
  } else if (action is SetCompletedTopicsAction) {
    return state.copyWith(completedTopics: action.completedTopics);
  } else if (action is ChangeLanguageAction) {
    // This action is for changing the app's language code
    return state.copyWith(selectedLanguageCode: action.languageCode);
  }
  return state;
}
