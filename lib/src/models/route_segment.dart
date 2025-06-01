import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteSegment {
  final List<LatLng> points;
  final double distance;
  final Duration estimatedTime;
  final bool isCompleted;

  const RouteSegment({
    required this.points,
    required this.distance,
    required this.estimatedTime,
    this.isCompleted = false,
  });
}
