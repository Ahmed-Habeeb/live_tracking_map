import 'package:google_maps_flutter/google_maps_flutter.dart';

class EndPoints {
  // Base Url for end points
  static const String baseUrl = 'https://api.mashrouk.com/';
  static String api = "Constants.apiUrl";

  // EndPoints
  static const String login = 'auth/login/riders';
  static const String verifyPhone = 'auth/verify-otp/riders';
  static const String register = 'auth/complete-account/riders';
  static const String me = 'riders/me';
  static const String createRequest = '';
  static const String currentTripDetails = '';

  static String currentOrder(String riderId) => 'riders/currentOrder/$riderId';

  static String getAddressFromLatLng(LatLng position) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

  static String getLocationsSearch(String search) =>
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$search&key=$mapKey';

  // Keys
  static const String mapKey = 'AIzaSyBMTLXpuXtkEfbgChZzsj7LPYlpGxHI9iU';

  static String cancelTrip(String tripId) {
    return 'orders/$tripId/cancel';
  }
}
