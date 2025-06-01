import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/navigation_state.dart';

class MapMarkersBuilder {
  static Set<Marker> build({
    required NavigationState state,
    LatLng? pickUpLocation,
    required LatLng destination,
    Marker? pickUpMarker,
    Marker? carMarker,
    Marker? destinationMarker,
    bool liveTracking = true,
  }) {
    final Set<Marker> markers = {};

    // Car marker
    if (carMarker != null && state.currentPosition != null) {
      markers.add(carMarker.copyWith(
        positionParam: liveTracking ? state.currentPosition : carMarker.position,
      ));
    }

    // Pickup marker
    if (pickUpMarker != null && pickUpLocation != null) {
      markers.add(pickUpMarker.copyWith(
        positionParam: pickUpLocation,
      ));
    }

    // Destination marker
    if (destinationMarker != null) {
      markers.add(destinationMarker.copyWith(
        positionParam: destination,
      ));
    }

    return markers;
  }
}