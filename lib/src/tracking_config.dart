// ==================== CONFIG FILE ====================

class TrackingConfig {
  // Route Detection
  static const double offRouteThreshold = 30.0;
  static const double minDistanceFilter = 2.0;

  // Timing Constants
  static const Duration rerouteCooldown = Duration(seconds: 5);
  static const Duration rerouteDebounceDuration = Duration(seconds: 2);
  static const Duration positionUpdateDebounce = Duration(milliseconds: 100);
  static const Duration locationTimeout = Duration(seconds: 10);
  static const Duration cameraAnimationDuration = Duration(milliseconds: 500);

  // Map Display
  static const double defaultZoom = 17.0;
  static const double routeOverviewZoom = 15.0;
  static const double mapTilt = 45.0;
  static const double routeWidth = 6.0;
  static const double traveledWidth = 8.0;
  static const double cameraAnimationSteps = 20.0;

  // ETA Calculation
  static const double defaultSpeedKmh = 60.0;
  static const double minSpeedThreshold = 10.0;
  static const Duration minETA = Duration(minutes: 1);

  // UI
  static const double markerSize = 60.0;
  static const double cameraBoundsPadding = 50.0;
  static const double bearingLerpFactor = 0.2;
}
