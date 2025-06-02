import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tracking_config.dart';

class MapAnimationController {
  GoogleMapController? _controller;
  Timer? _animationTimer;
  CameraPosition? _lastCameraPosition;

  void setMapController(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> animateToPosition(
    LatLng position, {
    double? zoom,
    double? bearing,
    double? tilt,
  }) async {
    if (_controller == null) return;

    final CameraPosition targetPosition = CameraPosition(
      target: position,
      zoom: zoom ?? TrackingConfig().defaultZoom,
      bearing: bearing ?? 0.0,
      tilt: tilt ?? TrackingConfig().mapTilt,
    );

    if (_lastCameraPosition == null) {
      _lastCameraPosition = targetPosition;
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(targetPosition),
      );
      return;
    }

    await _smoothAnimateCamera(targetPosition);
  }

  Future<void> animateToRoute(List<LatLng> routePoints) async {
    if (_controller == null || routePoints.isEmpty) return;

    final LatLngBounds bounds = _computeBounds(routePoints);
    await _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, TrackingConfig().cameraBoundsPadding),
    );
  }

  Future<void> _smoothAnimateCamera(CameraPosition targetPosition) async {
    _animationTimer?.cancel();

    final int steps = TrackingConfig().cameraAnimationSteps.toInt();
    final int stepDuration =
        TrackingConfig().cameraAnimationDuration.inMilliseconds ~/ steps;

    final double startLat = _lastCameraPosition!.target.latitude;
    final double startLng = _lastCameraPosition!.target.longitude;
    final double startBearing = _lastCameraPosition!.bearing;
    final double endLat = targetPosition.target.latitude;
    final double endLng = targetPosition.target.longitude;
    final double endBearing = targetPosition.bearing;

    int step = 0;

    _animationTimer = Timer.periodic(Duration(milliseconds: stepDuration), (
      Timer timer,
    ) async {
      step++;
      if (step > steps) {
        timer.cancel();
        _lastCameraPosition = targetPosition;
        return;
      }

      final double t = step / steps.toDouble();
      final double lat = _lerp(startLat, endLat, t);
      final double lng = _lerp(startLng, endLng, t);
      final double bearing = _lerpBearing(startBearing, endBearing, t);

      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: targetPosition.zoom,
            tilt: targetPosition.tilt,
            bearing: bearing,
          ),
        ),
      );
    });
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _lerpBearing(double current, double target, double t) {
    double diff = (target - current) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return (current + diff * t) % 360;
  }

  LatLngBounds _computeBounds(List<LatLng> points) {
    double southWestLat = points.first.latitude;
    double southWestLng = points.first.longitude;
    double northEastLat = points.first.latitude;
    double northEastLng = points.first.longitude;

    for (final LatLng point in points) {
      southWestLat = southWestLat < point.latitude
          ? southWestLat
          : point.latitude;
      southWestLng = southWestLng < point.longitude
          ? southWestLng
          : point.longitude;
      northEastLat = northEastLat > point.latitude
          ? northEastLat
          : point.latitude;
      northEastLng = northEastLng > point.longitude
          ? northEastLng
          : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  void dispose() {
    _animationTimer?.cancel();
  }
}
