import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tracking_config.dart';
import 'ilocation_service.dart';

class BackgroundLocationService implements ILocationService {
  StreamSubscription<Position>? _subscription;
  final StreamController<Position> _controller =
      StreamController<Position>.broadcast();

  @override
  Stream<Position> get positionStream => _controller.stream;

  @override
  Future<void> checkPermissions() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }
  }

  @override
  Future<LatLng> getCurrentPosition() async {
    final Position p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(TrackingConfig().locationTimeout);
    return LatLng(p.latitude, p.longitude);
  }

  @override
  Future<void> startLocationTracking({void Function(Position position)? onUpdate}) async {
    await checkPermissions();

    _subscription?.cancel();

    final LocationSettings locationSettings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: TrackingConfig().minDistanceFilter.toInt(),
            intervalDuration: const Duration(seconds: 5),
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: 'Location Tracking',
              notificationText: 'Tracking location in background',
              notificationChannelName: 'Location',
              enableWakeLock: true,
            ),
          )
        : Platform.isIOS
            ? const AppleSettings(
                accuracy: LocationAccuracy.best,
                allowsBackgroundLocationUpdates: true,
                showsBackgroundLocationIndicator: true,
                distanceFilter: 0,
                pauseLocationUpdatesAutomatically: false,
              )
            : LocationSettings(
                accuracy: LocationAccuracy.best,
                distanceFilter: TrackingConfig().minDistanceFilter.toInt(),
              );

    _subscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position pos) {
        _controller.add(pos);
        if (onUpdate != null) {
          onUpdate(pos);
        }
      },
      onError: (Object e, StackTrace s) {
        if (kDebugMode) {
          print('Background position stream error: $e');
        }
      },
    );
  }

  @override
  void stopLocationTracking() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    stopLocationTracking();
    _controller.close();
  }
}