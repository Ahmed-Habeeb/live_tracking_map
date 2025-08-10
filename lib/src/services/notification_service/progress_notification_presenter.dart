import '../../models/notification_content.dart';
import '../../models/navigation_state.dart';
import '../../models/enums.dart';
import '../../services/notification_service/inotification_presenter.dart';

class ProgressNotificationPresenter implements INotificationPresenter {
  ProgressNotificationPresenter({required this.initialTotalDistanceMeters});

  final double initialTotalDistanceMeters;

  @override
  NotificationContent buildContent(NavigationState state) {
    final bool arrived = state.status == NavigationStatus.completed;
    final double remaining = state.remainingDistance;
    final double total = initialTotalDistanceMeters == 0
        ? remaining
        : initialTotalDistanceMeters;
    final double covered = (total - remaining).clamp(0, total);
    final int percent = total == 0 ? 0 : ((covered / total) * 100).round();

    final String title = arrived ? 'Arrived' : 'On the way';
    final String subtitle = arrived
        ? 'Destination reached'
        : '${(remaining / 1000).toStringAsFixed(1)} km remaining';

    return NotificationContent(
      title: '$title · $percent%',
      body: subtitle,
      ongoing: !arrived,
      showProgress: true,
      indeterminate: false,
      progress: arrived ? 100 : percent,
      maxProgress: 100,
    );
  }
}