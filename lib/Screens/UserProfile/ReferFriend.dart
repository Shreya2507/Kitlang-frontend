import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ReferAFriendPage extends StatelessWidget {
  const ReferAFriendPage({super.key});

  final String inviteCode = "LEARN123"; // You can randomize this later or pull from user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refer a Friend"),
        backgroundColor: Color(0xFFF9C0D6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(Icons.card_giftcard, size: 100, color: Color(0xFFEA4877)),
            const SizedBox(height: 20),
            Text(
              "Invite your friends and help them start their journey!",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(inviteCode,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Color(0xFFEA4877)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Code copied to clipboard!")),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA4877),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              icon: const Icon(Icons.share),
              label: const Text("Share with Friends"),
              onPressed: () {
                Share.share(
                  "Hey! 👋 Join me on this awesome learning app! Use my invite code: $inviteCode to get started. 🚀",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
