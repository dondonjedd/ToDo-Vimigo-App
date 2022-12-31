import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
  NotificationApi();
  static final _notifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
    ));
  }

  Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  Future<void> init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(details) async {
    onNotifications.add(details.payload);
  }
}
