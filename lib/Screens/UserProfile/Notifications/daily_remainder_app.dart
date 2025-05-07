import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Screens/UserProfile/Notifications/NotificationService.dart';

class DailyReminderTab extends StatefulWidget {
  const DailyReminderTab({super.key});

  @override
  State<DailyReminderTab> createState() => _DailyReminderTabState();
}

class _DailyReminderTabState extends State<DailyReminderTab> {
  final NotificationService _notificationService = NotificationService();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0); // Default: 8:00 PM
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initNotifications();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing notifications: $e');
      setState(() {
        _isInitialized = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize notifications: $e')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications are still initializing, please try again.')),
      );
      return;
    }

    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (picked != null && picked != _selectedTime) {
        setState(() {
          _selectedTime = picked;
        });
        await _notificationService.scheduleDailyReminder(
          hour: picked.hour,
          minute: picked.minute,
          title: 'Daily Language Goal',
          body: 'Time to practice your language skills!',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily reminder scheduled!')),
        );
      }
    } catch (e) {
      print('Error in _selectTime: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule reminder: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Daily Reminder',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5B4473),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.alarm, color: Color(0xFF5B4473)),
              title: Text(
                'Reminder Time: ${_selectedTime.format(context)}',
                style: GoogleFonts.lato(fontSize: 16),
              ),
              trailing: _isInitialized
                  ? const Icon(Icons.edit, color: Colors.grey)
                  : const CircularProgressIndicator(),
              onTap: _isInitialized ? () => _selectTime(context) : null,
            ),
            if (!_isInitialized) ...[
              const SizedBox(height: 16),
              Text(
                'Initializing notifications... If this persists, please check your permissions or try again.',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}