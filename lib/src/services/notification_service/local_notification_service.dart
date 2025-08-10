import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/notification_content.dart';
import '../../models/notification_options.dart';
import 'inotification_service.dart';

class LocalNotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  late NotificationOptions _options;
  static const int _notificationId = 10001;

  @override
  Future<void> init({required NotificationOptions options}) async {
    _options = options;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);

    // Create channel on Android
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      _options.channelId,
      _options.channelName,
      description: _options.channelDescription,
      importance:
          _options.importanceHigh ? Importance.high : Importance.defaultImportance,
      playSound: _options.playSound,
      showBadge: false,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  @override
  Future<void> showOrUpdate(NotificationContent content) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _options.channelId,
      _options.channelName,
      channelDescription: _options.channelDescription,
      ongoing: _options.enableOngoing && content.ongoing,
      importance:
          _options.importanceHigh ? Importance.high : Importance.defaultImportance,
      priority: Priority.high,
      playSound: _options.playSound,
      autoCancel: !_options.enableOngoing,
      showWhen: _options.showWhen,
      icon: _options.iconName,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      _notificationId,
      content.title,
      content.body,
      details,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  @override
  void dispose() {}
}