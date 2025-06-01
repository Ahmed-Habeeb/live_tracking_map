import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_map/src/models/navigation_execption.dart';
import 'package:live_tracking_map/src/tracking_config.dart';

import '../../map_service/map_service.dart';
import '../../models/enums.dart';
import 'iroute_service.dart';

class RouteService implements IRouteService {
  final MapService mapService; // Your existing MapService

  RouteService(this.mapService);

  @override
  Future<List<LatLng>> calculateRoute(List<LatLng> waypoints) async {
    try {
      if (waypoints.length < 2) {
        throw const NavigationException(
          TrackingError.routeCalculationFailed,
          'At least 2 waypoints required',
        );
      }

      final List<LatLng> routePoints = await mapService
          .getRouteBetweenListPoints(waypoints);

      if (routePoints.isEmpty) {
        throw const NavigationException(
          TrackingError.noRouteFound,
          'No route found between waypoints',
        );
      }

      return routePoints;
    } catch (e) {
      if (e is NavigationException) {
        rethrow;
      }
      throw NavigationException(
        TrackingError.routeCalculationFailed,
        'Route calculation failed: $e',
      );
    }
  }

  @override
  double calculateDistance(List<LatLng> points) {
    if (points.length < 2) {
      return 0.0;
    }

    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  @override
  Duration calculateETA(double distance, double speed) {
    final double speedKmh = speed > TrackingConfig.minSpeedThreshold
        ? speed
        : TrackingConfig.defaultSpeedKmh;

    final int seconds = (distance / (speedKmh * 1000 / 3600)).round();
    final Duration eta = Duration(seconds: seconds);

    return eta < TrackingConfig.minETA ? TrackingConfig.minETA : eta;
  }

  @override
  bool isPointNearRoute(LatLng point, List<LatLng> route, {double? threshold}) {
    final double thresholdDistance =
        threshold ?? TrackingConfig.offRouteThreshold;

    for (int i = 0; i < route.length - 1; i++) {
      if (_pointToLineDistance(point, route[i], route[i + 1]) <
          thresholdDistance) {
        return true;
      }
    }
    return false;
  }

  @override
  int findClosestPointIndex(LatLng current, List<LatLng> routePoints) {
    if (routePoints.isEmpty) {
      return 0;
    }

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < routePoints.length; i++) {
      final double distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        routePoints[i].latitude,
        routePoints[i].longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  @override
  double calculateBearing(LatLng from, LatLng to) {
    return Geolocator.bearingBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  double _pointToLineDistance(LatLng point, LatLng lineStart, LatLng lineEnd) {
    final double dx = lineEnd.longitude - lineStart.longitude;
    final double dy = lineEnd.latitude - lineStart.latitude;

    if (dx == 0 && dy == 0) {
      return Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        lineStart.latitude,
        lineStart.longitude,
      );
    }

    double t =
        ((point.longitude - lineStart.longitude) * dx +
            (point.latitude - lineStart.latitude) * dy) /
        (dx * dx + dy * dy);
    t = t.clamp(0.0, 1.0);

    return Geolocator.distanceBetween(
      point.latitude,
      point.longitude,
      lineStart.latitude + t * dy,
      lineStart.longitude + t * dx,
    );
  }
}
