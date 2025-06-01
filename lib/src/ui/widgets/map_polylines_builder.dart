import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/navigation_state.dart';
import '../../tracking_config.dart';

class MapPolylinesBuilder {
  static Set<Polyline> build(NavigationState state) {
    final Set<Polyline> polylines = {};

    // Route polyline
    if (state.routePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: state.routePoints,
          color: Colors.blue.withValues(alpha: 0.9),
          width: TrackingConfig.routeWidth.toInt(),
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    // Traveled polyline
    if (state.traveledPoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('traveled'),
          points: state.traveledPoints,
          color: Colors.grey.withValues(alpha: .8),
          width: TrackingConfig.traveledWidth.toInt(),
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    return polylines;
  }
}
