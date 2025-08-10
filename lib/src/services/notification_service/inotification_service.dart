import '../../models/notification_content.dart';
import '../../models/notification_options.dart';

abstract class INotificationService {
  Future<void> init({required NotificationOptions options});
  Future<void> showOrUpdate(NotificationContent content);
  Future<void> cancelAll();
  void dispose();
}