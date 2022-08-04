import 'package:dictionary/app/shared/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  final _androidDetails = const AndroidNotificationDetails(
    'lembrete_notifications',
    'Lembrete',
    channelDescription: 'Canal para lembretes',
    importance: Importance.max,
    priority: Priority.max,
    enableVibration: true,
  );

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  _setupTimezone() async {
    tz.initializeTimeZones();
    final String timezoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onSelectNotification: _onSelectecNotification,
    );
  }

  _onSelectecNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Modular.to.pushReplacementNamed(payload);
    }
  }

  scheduleNotification({
    required NotificationModel notification,
    required DateTime dateTime,
  }) {
    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: _androidDetails,
      ),
      payload: notification.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  cancelAllNotifications() {
    localNotificationsPlugin.cancelAll();
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectecNotification(details.payload);
    } else {
      Modular.to.navigate('/home/');
    }
  }
}
