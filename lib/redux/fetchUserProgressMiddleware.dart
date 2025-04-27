import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'appstate.dart';
import 'actions.dart';

void fetchUserProgressMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  if (action is FetchUserProgressAction) {
    print("[DEBUG] Middleware Triggered: FetchUserProgressAction");

    final userId = store.state.userId;
    print("[DEBUG] User ID: $userId");

    if (userId == null) {
      print("[ERROR] No user ID found.");
      return;
    }

    try {
      final docRef =
          FirebaseFirestore.instance.collection("user_progress").doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        print("[DEBUG] Raw Firestore Data: $data");

        if (data != null && data.containsKey("completed_topics")) {
          final Map<String, dynamic> completedTopics =
              Map<String, dynamic>.from(data["completed_topics"]);

          print("[DEBUG] Parsed Completed Topics: $completedTopics");

          store.dispatch(SetCompletedTopicsAction(completedTopics));
        } else {
          print("[DEBUG] No completed topics found.");
        }
      } else {
        print("[DEBUG] No document found for this user.");
      }
    } catch (error) {
      print("[ERROR] Failed to fetch progress: $error");
    }
  }

  next(action); // Keep the Redux chain flowing
}
