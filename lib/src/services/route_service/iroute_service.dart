import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class IRouteService {
  Future<List<LatLng>> calculateRoute(List<LatLng> waypoints);
  double calculateDistance(List<LatLng> points);
  Duration calculateETA(double distance, double speed);
  bool isPointNearRoute(LatLng point, List<LatLng> route, {double? threshold});
  int findClosestPointIndex(LatLng current, List<LatLng> routePoints);
  double calculateBearing(LatLng from, LatLng to);
}
