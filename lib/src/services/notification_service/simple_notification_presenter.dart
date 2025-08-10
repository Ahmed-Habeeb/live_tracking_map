import '../../models/notification_content.dart';
import '../../models/navigation_state.dart';
import '../../models/enums.dart';
import '../../services/notification_service/inotification_presenter.dart';

class SimpleNotificationPresenter implements INotificationPresenter {
  @override
  NotificationContent buildContent(NavigationState state) {
    final String statusText = switch (state.status) {
      NavigationStatus.navigating => 'Navigating',
      NavigationStatus.offRoute => 'Off route, rerouting…',
      NavigationStatus.recalculating => 'Rerouting…',
      NavigationStatus.completed => 'Arrived',
      NavigationStatus.error => 'Error',
      NavigationStatus.idle => 'Idle',
    };
    final String etaText = state.estimatedETA.inMinutes > 0
        ? '${state.estimatedETA.inMinutes} min'
        : '< 1 min';
    final String distanceKm = (state.remainingDistance / 1000).toStringAsFixed(1);

    return NotificationContent(
      title: '$statusText · $etaText',
      body: '$distanceKm km remaining',
      ongoing: state.status != NavigationStatus.completed &&
          state.status != NavigationStatus.error,
    );
  }
}