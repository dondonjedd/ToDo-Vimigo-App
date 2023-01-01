import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../Controllers/tasksController.dart';

class NotificationApi {
  final context;
  NotificationApi(this.context);
  final _notifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotifications = BehaviorSubject<String?>();

  Future<void> removeNotif(int id) async {
    print("Removing Notif with id : $id");
    await _notifications.cancel(id);
  }

  Future<void> init({bool initScheduled = true}) async {
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }

    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    //when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse?.payload);
    }

    await _notifications.initialize(settings, 
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        );
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id 1', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            enableVibration: true,
            sound: const RawResourceAndroidNotificationSound("alarm"),
            additionalFlags: Int32List.fromList(<int>[4])));
  }

  Future showScheduledNotification(
          {required int id,
          String? title,
          String? body,
          String? payload,
          required DateTime scheduledDate}) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  void onDidReceiveNotificationResponse(details) async {
    final id = details.payload;
    print("received notif with id : $id");
    if (id == null) {
      return;
    }

    TasksController().updateTask(
        context,
        id,
        TasksController()
            .getTaskAtIndex(
                context, TasksController().getIndexWithId(context, id))
            .copyWith(reminderDateTime: null));
    onNotifications.add(details.payload);
  }


}
