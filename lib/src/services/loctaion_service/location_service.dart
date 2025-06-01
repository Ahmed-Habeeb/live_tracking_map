import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_map/src/models/enums.dart';
import 'package:live_tracking_map/src/models/navigation_execption.dart';

import '../../tracking_config.dart';
import 'ilocation_service.dart';


class LocationService implements ILocationService {
  StreamSubscription<Position>? _positionSubscription;
  final StreamController<Position> _positionController = StreamController<Position>.broadcast();

  @override
  Stream<Position> get positionStream => _positionController.stream;

  @override
  Future<LatLng> getCurrentPosition() async {
    try {
      await checkPermissions();

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(TrackingConfig.locationTimeout);

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      throw NavigationException(TrackingError.timeout, 'Failed to get current position: $e');
    }
  }

  @override
  Future<void> checkPermissions() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const NavigationException(
        TrackingError.locationServiceDisabled,
        'Location services are disabled',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const NavigationException(
          TrackingError.permissionDenied,
          'Location permission denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const NavigationException(
        TrackingError.permissionDeniedForever,
        'Location permission denied forever',
      );
    }
  }
@override
  Future<void> startLocationTracking() async {
    await checkPermissions();

    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        // distanceFilter: TrackingConfig.minDistanceFilter,
      ),
    ).listen(
      _positionController.add,
      onError: (error) => debugPrint('Position stream error: $error'),
    );
  }

  @override
  void stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  void dispose() {
    stopLocationTracking();
    _positionController.close();
  }
}