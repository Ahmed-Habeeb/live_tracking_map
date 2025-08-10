import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ILocationService {
  Stream<Position> get positionStream;
  Future<LatLng> getCurrentPosition();
  Future<void> checkPermissions();
  Future<void> startLocationTracking();
  void stopLocationTracking();
  void dispose();
}
