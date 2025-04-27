import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/Onboarding/LevelScreen.dart';
import 'package:frontend/Screens/UserProfile/settings/LanguageScreen.dart';
import 'package:frontend/Screens/UserProfile/settings/translation.dart';
import 'package:frontend/redux/appstate.dart';

import 'package:google_fonts/google_fonts.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  _UserProfileSettingsState createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  late Future<void> _initTranslations;

  @override
  void initState() {
    super.initState();
    _initTranslations = _loadLanguageFromRedux();
  }

  Future<void> _loadLanguageFromRedux() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final selectedLanguage = store.state.selectedLanguageCode ?? 'en';
    await TranslationService().setLanguage(selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initTranslations,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel(
            userId: store.state.userId ?? '',
            languageCode: store.state.selectedLanguageCode ?? 'en',
          ),
          builder: (context, vm) {
            final t = TranslationService();

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text(
                  t.translate('Settings'),
                  style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        t.translate('Personalize your experience'),
                        style: GoogleFonts.lato(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSettingsTile(
                        icon: Icons.language,
                        title: t.translate('Change Language'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    LanguageScreen(fromSettings: true)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        icon: Icons.military_tech,
                        title: t.translate('Change Level'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LevelScreen(
                                  userId: vm.userId, fromSettings: true),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Center(
                        child: Text(
                          'Made with ❤️ for learners',
                          style: GoogleFonts.lato(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              radius: 24,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final String userId;
  final String languageCode;

  _ViewModel({
    required this.userId,
    required this.languageCode,
  });
}
