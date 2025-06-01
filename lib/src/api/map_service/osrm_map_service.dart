import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_map/src/api/dio/dio_factory.dart';
import 'package:live_tracking_map/src/map_service/map_service.dart';


class OsrmMapService implements MapService {
  final Dio _dio = DioFactory.getDio()
    ..options.baseUrl = "Constants.osrmUrl";


  final String _geocodeBaseUrl = 'https://nominatim.openstreetmap.org';

  @override
  Future<LatLng> geocodeAddress(String address) async {
    try {
      final response = await _dio.get(
          '$_geocodeBaseUrl/search', queryParameters: {
        'q': address,
        'format': 'json',
      });

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        final data = response.data[0];
        return LatLng(double.parse(data['lat']), double.parse(data['lon']));
      }
      throw Exception('No results found for address');
    } catch (e) {
      throw Exception('Failed to geocode address: $e');
    }
  }

  @override
  Future<String> getDistanceBetweenPoints(LatLng point1, LatLng point2) async {
    try {
      final response = await _dio.get(
          '/table/v1/driving/${point1.longitude},${point1.latitude};${point2
              .longitude},${point2.latitude}');

      if (response.statusCode == 200) {
        final data = response.data;
        return '${(data["durations"][0][1] / 60).toStringAsFixed(2)} min';
      }
      throw Exception('Failed to fetch distance');
    } catch (e) {
      throw Exception('Failed to get distance: $e');
    }
  }

  @override
  Future<List<Marker>> getNearbyPlaces(LatLng center, double radius) async {
    throw UnimplementedError('Use Overpass API for POI search');
  }

  @override
  Future<List<LatLng>> getRouteBetweenListPoints(List<LatLng> points) async {
    try {
      final coords = points.map((p) => '${p.longitude},${p.latitude}').join(
          ';');
      final response = await _dio.get(
          '/route/v1/driving/$coords', queryParameters: {
        'overview': 'full',
        'geometries': 'geojson',
      });

      if (response.statusCode == 200) {
        final List coordinates = response
            .data['routes'][0]['geometry']['coordinates'];
        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      }
      throw Exception('Failed to fetch route');
    } catch (e) {
      throw Exception('Failed to get route: $e');
    }
  }

  @override
  Future<List<LatLng>> getRouteBetweenTwoPoints(LatLng point1, LatLng point2) {
    return getRouteBetweenListPoints([point1, point2]);
  }

  @override
  Future<String> reverseGeocode(LatLng position) async {
    try {
      final response = await _dio.get(
          '$_geocodeBaseUrl/reverse', queryParameters: {
        'lat': position.latitude,
        'lon': position.longitude,
        'format': 'json',
      });

      if (response.statusCode == 200) {
        return response.data['display_name'];
      }
      throw Exception('Failed to fetch address');
    } catch (e) {
      throw Exception('Failed to reverse geocode: $e');
    }
  }

  @override
  void setMapController(controller) {
    // Not applicable for OSRM
  }

  @override
  Future<void> setMapStyle(String style) async {
    throw UnimplementedError('Map styling is not supported in OSRM');
  }
}
