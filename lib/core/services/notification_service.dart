import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  factory NotificationService() {
    return instance;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'madinaty_notifications',
      'Madinaty Notifications',
      description: 'Notifications for bookings, orders and offers.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'madinaty_notifications',
      'Madinaty Notifications',
      channelDescription: 'Notifications for bookings, orders and offers.',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showBookingConfirmation({
    required String title,
    required String body,
  }) async {
    await showNotification(
      title: title,
      body: body,
      payload: 'booking_confirmation',
    );
  }

  Future<void> showBookingReminder({
    required String title,
    required String body,
  }) async {
    await showNotification(
      title: title,
      body: body,
      payload: 'booking_reminder',
    );
  }

  Future<void> showOrderUpdate({
    required String title,
    required String body,
  }) async {
    await showNotification(title: title, body: body, payload: 'order_update');
  }

  Future<void> showOffer({required String title, required String body}) async {
    await showNotification(title: title, body: body, payload: 'offer');
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null) {
      return;
    }
  }
}
