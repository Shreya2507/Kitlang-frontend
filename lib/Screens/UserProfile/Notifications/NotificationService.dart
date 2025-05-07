import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;

  // Initialize notifications
  Future<void> initNotifications() async {
    if (_isInitialized) return;

    try {
      await AwesomeNotifications().initialize(
        null, // Use default app icon
        [
          NotificationChannel(
            channelKey: 'daily_reminder_channel',
            channelName: 'Daily Reminder',
            channelDescription: 'Notifications for daily language goal reminders',
            importance: NotificationImportance.High,
            defaultColor: const Color(0xFF5B4473),
            ledColor: const Color(0xFF5B4473),
            playSound: true,
            enableVibration: true,
          ),
        ],
        debug: true,
      );

      // Request permission to show notifications
      final bool granted = await AwesomeNotifications().requestPermissionToSendNotifications();
      if (!granted) {
        print('Notification permissions not granted');
      }

      _isInitialized = true;
    } catch (e) {
      print('Error in initNotifications: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  // Schedule a daily reminder at a specific time
  Future<void> scheduleDailyReminder({
    int id = 0,
    String title = 'Daily Reminder',
    String body = 'Time to complete your language goal!',
    required int hour,
    required int minute,
  }) async {
    try {
      if (!_isInitialized) {
        await initNotifications();
      }

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'daily_reminder_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  // Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    try {
      await AwesomeNotifications().cancel(id);
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }
}