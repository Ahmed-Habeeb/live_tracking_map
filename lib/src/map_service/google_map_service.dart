import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_map/src/map_service/map_service.dart';


class GoogleMapService implements MapService {

  GoogleMapService(this.apiKey) : _dio = Dio(BaseOptions(
    baseUrl: 'https://maps.googleapis.com/maps/api/',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  final String apiKey; // Your Google Maps API key
  late GoogleMapController? _mapController;
  final Dio _dio;

  @override
  void setMapController(var controller) {
    if (!controller is GoogleMapController){
      throw Exception('Invalid map controller');
    }
    _mapController = controller;
  }

  @override
  Future<List<LatLng>> getRouteBetweenTwoPoints(LatLng point1, LatLng point2) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${point1.latitude},${point1.longitude}'
        '&destination=${point2.latitude},${point2.longitude}&mode=driving&key=$apiKey';

    try {
      final Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        if ((data['routes'] as List).isNotEmpty) {
          final String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
          return _decodePoly(encodedPolyline);
        } else {
          throw Exception('No routes found');
        }
      } else {
        throw Exception('Failed to load directions');
      }
    } catch (e) {
      throw Exception('Error fetching route: $e');
    }
  }



  @override
  Future<List<LatLng>> getRouteBetweenListPoints(List<LatLng> points) async {
    if (points.length < 2) throw Exception('At least 2 points required');

    try {
      final String waypoints = points
          .sublist(1, points.length - 1)
          .map((p) => '${p.latitude},${p.longitude}')
          .join('|');

      final response = await _dio.get(
        'directions/json',
        queryParameters: {
          'origin': '${points.first.latitude},${points.first.longitude}',
          'destination': '${points.last.latitude},${points.last.longitude}',
          'waypoints': waypoints,
          'key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        return _decodePoly(response.data['routes'][0]['overview_polyline']['points']);
      }
      throw Exception('Failed to get route: ${response.data['status']}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<String> getDistanceBetweenPoints(LatLng point1, LatLng point2) async {
    try {
      final response = await _dio.get(
        'distancematrix/json',
        queryParameters: {
          'origins': '${point1.latitude},${point1.longitude}',
          'destinations': '${point2.latitude},${point2.longitude}',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        return response.data['rows'][0]['elements'][0]['distance']['text'];
      }
      throw Exception('Failed to get distance: ${response.data['status']}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<Marker>> getNearbyPlaces(LatLng center, double radius) async {
    try {
      final response = await _dio.get(
        'place/nearbysearch/json',
        queryParameters: {
          'location': '${center.latitude},${center.longitude}',
          'radius': radius,
          'key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        return (response.data['results'] as List).map((place) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          return Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: place['name']),
          );
        }).toList();
      }
      throw Exception('Failed to get nearby places: ${response.data['status']}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<LatLng> geocodeAddress(String address) async {
    try {
      final response = await _dio.get(
        'geocode/json',
        queryParameters: {
          'address': address,
          'key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
      throw Exception('Failed to geocode address: ${response.data['status']}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<String> reverseGeocode(LatLng position) async {
    try {
      final response = await _dio.get(
        'geocode/json',
        queryParameters: {
          'latlng': '${position.latitude},${position.longitude}',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        return response.data['results'][0]['formatted_address'];
      }
      throw Exception('Failed to reverse geocode: ${response.data['status']}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> setMapStyle(String style) async {
    if (_mapController == null) {
      throw Exception('Map controller not initialized');
    }
    await _mapController!.setMapStyle(style);
  }

  List<LatLng> _decodePoly(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}