
import 'package:live_tracking_map/src/models/enums.dart';

class NavigationException implements Exception {

  const NavigationException(this.type, this.message);
  final TrackingError type;
  final String message;

  @override
  String toString() => 'NavigationException: $message';
}
