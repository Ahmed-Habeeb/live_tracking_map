import '../../models/notification_content.dart';
import '../../models/navigation_state.dart';

abstract class INotificationPresenter {
  NotificationContent buildContent(NavigationState state);
}