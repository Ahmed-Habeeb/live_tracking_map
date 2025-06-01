import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'enums.dart';

class NavigationState {
  final NavigationStatus status;
  final LatLng? currentPosition;
  final List<LatLng> routePoints;
  final List<LatLng> traveledPoints;
  final double remainingDistance;
  final Duration estimatedETA;
  final double currentBearing;
  final TrackingError? error;
  final String? errorMessage;

  const NavigationState({
    required this.status,
    this.currentPosition,
    this.routePoints = const [],
    this.traveledPoints = const [],
    this.remainingDistance = 0.0,
    this.estimatedETA = Duration.zero,
    this.currentBearing = 0.0,
    this.error,
    this.errorMessage,
  });

  NavigationState copyWith({
    NavigationStatus? status,
    LatLng? currentPosition,
    List<LatLng>? routePoints,
    List<LatLng>? traveledPoints,
    double? remainingDistance,
    Duration? estimatedETA,
    double? currentBearing,
    TrackingError? error,
    String? errorMessage,
  }) {
    return NavigationState(
      status: status ?? this.status,
      currentPosition: currentPosition ?? this.currentPosition,
      routePoints: routePoints ?? this.routePoints,
      traveledPoints: traveledPoints ?? this.traveledPoints,
      remainingDistance: remainingDistance ?? this.remainingDistance,
      estimatedETA: estimatedETA ?? this.estimatedETA,
      currentBearing: currentBearing ?? this.currentBearing,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}