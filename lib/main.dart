import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/HomePage/HomePage.dart';
import 'package:frontend/Screens/Onboarding/LevelScreen.dart';
import 'package:frontend/Screens/Onboarding/LoginScreen.dart';
import 'package:frontend/Screens/Onboarding/SignupScreen.dart';
import 'package:frontend/Screens/Onboarding/onboarding.dart';
import 'package:frontend/Screens/Onboarding/services/auth_provider.dart';
import 'package:frontend/Screens/Onboarding/LanguageScreen.dart';
import 'package:frontend/Screens/service/audio_controller.dart'; // renamed to avoid confusion
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/fetchUserProgressMiddleware.dart';
import 'package:redux/redux.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:frontend/redux/reducer.dart';
import 'package:frontend/Screens/UserProfile/UserProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Check if user is logged in
  User? user = FirebaseAuth.instance.currentUser;
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(userId: user?.uid),
    middleware: [fetchUserProgressMiddleware],
  );

  // Dispatch action to trigger middleware
  if (user != null) {
    print("[DEBUG] Dispatching FetchUserProgressAction...");
    store.dispatch(FetchUserProgressAction());
  }

  // Fetch user language from Firestore
  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final languageCode = doc.data()?['languageCode'] ?? 'en';
    final language = doc.data()?['language'] ?? 'German';
    print("[DEBUG] Fetched languageCode from Firestore: $languageCode");

    store.dispatch(ChangeLanguageAction(languageCode));
    store.dispatch(SetUserLanguageAction(language));
  }

  final audioController = AudioController();
  await audioController.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<Store<AppState>>.value(value: store),
        ChangeNotifierProvider.value(value: audioController),
        Provider<AuthProvide>(
          create: (_) => AuthProvide(store: store, child: MyApp(store: store)),
        ),
      ],
      child: MyApp(store: store),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: Builder(
        builder: (context) {
          return StoreConnector<AppState, String?>(
            converter: (store) => store.state.selectedLanguageCode,
            builder: (context, selectedLanguage) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: store.state.userId != null ? '/home' : '/',
                locale: Locale(selectedLanguage ?? 'en'),
                onGenerateRoute: (settings) {
                  final args =
                      settings.arguments as Map<String, dynamic>? ?? {};

                  switch (settings.name) {
                    case '/':
                      return MaterialPageRoute(
                          builder: (_) => const Onboarding());
                    case '/signup':
                      return MaterialPageRoute(
                          builder: (_) => const SignupScreen());
                    case '/login':
                      return MaterialPageRoute(
                          builder: (_) => const LoginScreen());
                    case '/lang':
                      return MaterialPageRoute(
                          builder: (_) => const LanguageScreen());
                    case '/level':
                      return MaterialPageRoute(
                        builder: (_) =>
                            LevelScreen(userId: args['userId'] ?? ''),
                      );
                    case '/home':
                      return MaterialPageRoute(
                          builder: (_) => const HomePage());
                    case '/settings':
                      return MaterialPageRoute(
                          builder: (_) => const ProfilePage());
                    default:
                      return MaterialPageRoute(
                          builder: (_) => const Onboarding());
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
