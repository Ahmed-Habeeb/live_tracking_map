import 'package:google_maps_flutter/google_maps_flutter.dart';

// Abstract class with all potentially useful map-related methods
abstract class MapService {
  Future<List<LatLng>> getRouteBetweenTwoPoints(LatLng point1, LatLng point2);
  Future<List<LatLng>> getRouteBetweenListPoints(List<LatLng> points);
  Future<String> getDistanceBetweenPoints(LatLng point1, LatLng point2);
  Future<List<Marker>> getNearbyPlaces(LatLng center, double radius);
  Future<LatLng> geocodeAddress(String address);
  Future<String> reverseGeocode(LatLng position);
  // Future<void> setMapStyle(String style);
}
