class TrackingConfiguration {
  // Route Detection
  double offRouteThreshold = 55.0;
  double minDistanceFilter = 2.0;

  // Timing Constants
  Duration rerouteCooldown = const Duration(seconds: 5);
  Duration rerouteDebounceDuration = const Duration(seconds: 2);
  Duration positionUpdateDebounce = const Duration(milliseconds: 100);
  Duration locationTimeout = const Duration(seconds: 10);
  Duration cameraAnimationDuration = const Duration(milliseconds: 500);

  // Map Display
  double defaultZoom = 17.0;
  double routeOverviewZoom = 15.0;
  double mapTilt = 45.0;
  double routeWidth = 6.0;
  double traveledWidth = 8.0;
  double cameraAnimationSteps = 20.0;

  // ETA Calculation
  double defaultSpeedKmh = 60.0;
  double minSpeedThreshold = 10.0;
  Duration minETA = const Duration(minutes: 1);

  // UI
  double markerSize = 60.0;
  double cameraBoundsPadding = 50.0;
  double bearingLerpFactor = 0.2;

  // constructor
  TrackingConfiguration({
    this.offRouteThreshold = 55.0,
    this.minDistanceFilter = 2.0,
    this.rerouteCooldown = const Duration(seconds: 5),
    this.rerouteDebounceDuration = const Duration(seconds: 2),
    this.positionUpdateDebounce = const Duration(milliseconds: 100),
    this.locationTimeout = const Duration(seconds: 10),
    this.cameraAnimationDuration = const Duration(milliseconds: 500),
    this.defaultZoom = 17.0,
    this.routeOverviewZoom = 15.0,
    this.mapTilt = 45.0,
    this.routeWidth = 6.0,
    this.traveledWidth = 8.0,
    this.cameraAnimationSteps = 20.0,
    this.defaultSpeedKmh = 60.0,
    this.minSpeedThreshold = 10.0,
    this.minETA = const Duration(minutes: 1),
    this.markerSize = 60.0,
    this.cameraBoundsPadding = 50.0,
    this.bearingLerpFactor = 0.2,
  });
}