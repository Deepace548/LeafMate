import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Initialize timezone
    tz_data.initializeTimeZones();
    
    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
  }

  // Schedule a watering reminder for a specific plant
  Future<void> scheduleWateringReminder({
    required String plantId,
    required String plantName,
    required DateTime scheduledTime,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'watering_reminders',
      'Watering Reminders',
      channelDescription: 'Notifications for plant watering schedules',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'watering_reminders',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.zonedSchedule(
      plantId.hashCode, // Unique ID for each plant's notification
      'Time to water $plantName! 💧',
      'Your plant needs some love. Don\'t forget to water it today.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: plantId,
    );

    if (kDebugMode) {
      print('Scheduled watering reminder for $plantName at $scheduledTime');
    }
  }

  // Cancel a specific plant's watering reminder
  Future<void> cancelWateringReminder(String plantId) async {
    await _notifications.cancel(plantId.hashCode);
    if (kDebugMode) {
      print('Cancelled watering reminder for plant: $plantId');
    }
  }

  // Cancel all watering reminders
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
    if (kDebugMode) {
      print('Cancelled all watering reminders');
    }
  }

  // Show an immediate test notification
  Future<void> showTestNotification() async {
    if (!_initialized) {
      await initialize();
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Channel for test notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notifications.show(
      0,
      'Test Notification',
      'This is a test notification from LeafMate',
      platformChannelSpecifics,
    );
  }

  // Request notification permissions (for iOS 16+)
  Future<bool> requestPermissions() async {
    final bool? result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? false;
  }
}
