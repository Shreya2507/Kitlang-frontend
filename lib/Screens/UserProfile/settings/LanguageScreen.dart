import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/UserProfile/settings/translation.dart';
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageScreen extends StatelessWidget {
  final bool fromSettings;

  const LanguageScreen({super.key, this.fromSettings = false});

  @override
  Widget build(BuildContext context) {
    final translationService = TranslationService();

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, translationService),
      builder: (context, viewModel) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('🌐 Select Language',
                style: GoogleFonts.lato(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6D5DF6), Color(0xFF8A60F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              children: [
                SizedBox(
                  height: 50,
                ),
                _buildLanguageTile(
                  context,
                  'English',
                  'en',
                  '🇬🇧',
                  translationService,
                  viewModel,
                ),
                _buildLanguageTile(
                  context,
                  'French',
                  'fr',
                  '🇫🇷',
                  translationService,
                  viewModel,
                ),
                _buildLanguageTile(
                  context,
                  'Spanish',
                  'es',
                  '🇪🇸',
                  translationService,
                  viewModel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String languageName,
    String languageCode,
    String flagEmoji,
    TranslationService translationService,
    _ViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () {
        viewModel.changeLanguage(languageName, languageCode);
        translationService.setLanguage(languageCode);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFBA8FFD), Color(0xFF936CFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              flagEmoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            FutureBuilder<String>(
              future: Future.value(translationService.translate(languageName)),
              builder: (context, snapshot) {
                String text = languageName;
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  text = snapshot.data!;
                }
                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final Function(String language, String languageCode) changeLanguage;

  _ViewModel({required this.changeLanguage});

  factory _ViewModel.fromStore(
      Store<AppState> store, TranslationService translationService) {
    return _ViewModel(
      changeLanguage: (language, languageCode) async {
        store.dispatch(SetUserLanguageAction(language));
        store.dispatch(ChangeLanguageAction(languageCode));

        final userId = store.state.userId;
        if (userId != null) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({
              'languageCode': languageCode,
            });
            print("[_ViewModel] Language updated in Firebase to $languageCode");
          } catch (e) {
            print("[_ViewModel] Error updating language in Firebase: $e");
          }
        }
      },
    );
  }
}
