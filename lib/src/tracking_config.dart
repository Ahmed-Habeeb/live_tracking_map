


import 'models/tracking_configuration.dart';

class TrackingConfig {
  // Private constructor
  TrackingConfig._internal();

  // Singleton instance
  static final TrackingConfig _instance = TrackingConfig._internal();

  // Factory constructor
  factory TrackingConfig() {
    return _instance;
  }

  // Static getter for easier access
  static TrackingConfig get instance => _instance;

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

  // Method to reset to defaults
  void resetToDefaults() {
    offRouteThreshold = 55.0;
    minDistanceFilter = 2.0;
    rerouteCooldown = const Duration(seconds: 5);
    rerouteDebounceDuration = const Duration(seconds: 2);
    positionUpdateDebounce = const Duration(milliseconds: 100);
    locationTimeout = const Duration(seconds: 10);
    cameraAnimationDuration = const Duration(milliseconds: 500);
    defaultZoom = 17.0;
    routeOverviewZoom = 15.0;
    mapTilt = 45.0;
    routeWidth = 6.0;
    traveledWidth = 8.0;
    cameraAnimationSteps = 20.0;
    defaultSpeedKmh = 60.0;
    minSpeedThreshold = 10.0;
    minETA = const Duration(minutes: 1);
    markerSize = 60.0;
    cameraBoundsPadding = 50.0;
    bearingLerpFactor = 0.2;
  }
 updateFromTrackingConfiguration(TrackingConfiguration config){

    updateConfig(
      offRouteThreshold: config.offRouteThreshold,
      minDistanceFilter: config.minDistanceFilter,
      rerouteCooldown: config.rerouteCooldown,
      rerouteDebounceDuration: config.rerouteDebounceDuration,
      positionUpdateDebounce: config.positionUpdateDebounce,
      locationTimeout: config.locationTimeout,
      cameraAnimationDuration: config.cameraAnimationDuration,
      defaultZoom: config.defaultZoom,
      routeOverviewZoom: config.routeOverviewZoom,
      mapTilt: config.mapTilt,
      routeWidth: config.routeWidth,
      traveledWidth: config.traveledWidth,
      cameraAnimationSteps: config.cameraAnimationSteps,
      defaultSpeedKmh: config.defaultSpeedKmh,
      minSpeedThreshold: config.minSpeedThreshold,
      minETA: config.minETA,
      markerSize: config.markerSize,
      cameraBoundsPadding: config.cameraBoundsPadding,
      bearingLerpFactor: config.bearingLerpFactor,
    );
 }
  TrackingConfig customConfig ({
    double? offRouteThreshold,
    double? minDistanceFilter,
    Duration? rerouteCooldown,
    Duration? rerouteDebounceDuration,
    Duration? positionUpdateDebounce,
    Duration? locationTimeout,
    Duration? cameraAnimationDuration,
    double? defaultZoom,
    double? routeOverviewZoom,
    double? mapTilt,
    double? routeWidth,
    double? traveledWidth,
    double? cameraAnimationSteps,
    double? defaultSpeedKmh,
    double? minSpeedThreshold,
    Duration? minETA,
    double? markerSize,
    double? cameraBoundsPadding,
    double? bearingLerpFactor,
  }) {
    TrackingConfig config = TrackingConfig._internal();
    return config
      ..updateConfig(
        offRouteThreshold: offRouteThreshold,
        minDistanceFilter: minDistanceFilter,
        rerouteCooldown: rerouteCooldown,
        rerouteDebounceDuration: rerouteDebounceDuration,
        positionUpdateDebounce: positionUpdateDebounce,
        locationTimeout: locationTimeout,
        cameraAnimationDuration: cameraAnimationDuration,
        defaultZoom: defaultZoom,
        routeOverviewZoom: routeOverviewZoom,
        mapTilt: mapTilt,
        routeWidth: routeWidth,
        traveledWidth: traveledWidth,
        cameraAnimationSteps: cameraAnimationSteps,
        defaultSpeedKmh: defaultSpeedKmh,
        minSpeedThreshold: minSpeedThreshold,
        minETA: minETA,
        markerSize: markerSize,
        cameraBoundsPadding: cameraBoundsPadding,
        bearingLerpFactor: bearingLerpFactor,
      );
  }

  // Method to update configuration with validation
  void updateConfig({
    double? offRouteThreshold,
    double? minDistanceFilter,
    Duration? rerouteCooldown,
    Duration? rerouteDebounceDuration,
    Duration? positionUpdateDebounce,
    Duration? locationTimeout,
    Duration? cameraAnimationDuration,
    double? defaultZoom,
    double? routeOverviewZoom,
    double? mapTilt,
    double? routeWidth,
    double? traveledWidth,
    double? cameraAnimationSteps,
    double? defaultSpeedKmh,
    double? minSpeedThreshold,
    Duration? minETA,
    double? markerSize,
    double? cameraBoundsPadding,
    double? bearingLerpFactor,
  }) {
    if (offRouteThreshold != null && offRouteThreshold > 0) {
      this.offRouteThreshold = offRouteThreshold;
    }
    if (minDistanceFilter != null && minDistanceFilter >= 0) {
      this.minDistanceFilter = minDistanceFilter;
    }
    if (rerouteCooldown != null) this.rerouteCooldown = rerouteCooldown;
    if (rerouteDebounceDuration != null) this.rerouteDebounceDuration = rerouteDebounceDuration;
    if (positionUpdateDebounce != null) this.positionUpdateDebounce = positionUpdateDebounce;
    if (locationTimeout != null) this.locationTimeout = locationTimeout;
    if (cameraAnimationDuration != null) this.cameraAnimationDuration = cameraAnimationDuration;
    if (defaultZoom != null && defaultZoom >= 1 && defaultZoom <= 21) {
      this.defaultZoom = defaultZoom;
    }
    if (routeOverviewZoom != null && routeOverviewZoom >= 1 && routeOverviewZoom <= 21) {
      this.routeOverviewZoom = routeOverviewZoom;
    }
    if (mapTilt != null && mapTilt >= 0 && mapTilt <= 60) {
      this.mapTilt = mapTilt;
    }
    if (routeWidth != null && routeWidth > 0) this.routeWidth = routeWidth;
    if (traveledWidth != null && traveledWidth > 0) this.traveledWidth = traveledWidth;
    if (cameraAnimationSteps != null && cameraAnimationSteps > 0) {
      this.cameraAnimationSteps = cameraAnimationSteps;
    }
    if (defaultSpeedKmh != null && defaultSpeedKmh > 0) {
      this.defaultSpeedKmh = defaultSpeedKmh;
    }
    if (minSpeedThreshold != null && minSpeedThreshold >= 0) {
      this.minSpeedThreshold = minSpeedThreshold;
    }
    if (minETA != null) this.minETA = minETA;
    if (markerSize != null && markerSize > 0) this.markerSize = markerSize;
    if (cameraBoundsPadding != null && cameraBoundsPadding >= 0) {
      this.cameraBoundsPadding = cameraBoundsPadding;
    }
    if (bearingLerpFactor != null && bearingLerpFactor >= 0 && bearingLerpFactor <= 1) {
      this.bearingLerpFactor = bearingLerpFactor;
    }
  }

  // Method to get current configuration as a map
  Map<String, dynamic> toMap() {
    return {
      'offRouteThreshold': offRouteThreshold,
      'minDistanceFilter': minDistanceFilter,
      'rerouteCooldown': rerouteCooldown.inMilliseconds,
      'rerouteDebounceDuration': rerouteDebounceDuration.inMilliseconds,
      'positionUpdateDebounce': positionUpdateDebounce.inMilliseconds,
      'locationTimeout': locationTimeout.inMilliseconds,
      'cameraAnimationDuration': cameraAnimationDuration.inMilliseconds,
      'defaultZoom': defaultZoom,
      'routeOverviewZoom': routeOverviewZoom,
      'mapTilt': mapTilt,
      'routeWidth': routeWidth,
      'traveledWidth': traveledWidth,
      'cameraAnimationSteps': cameraAnimationSteps,
      'defaultSpeedKmh': defaultSpeedKmh,
      'minSpeedThreshold': minSpeedThreshold,
      'minETA': minETA.inMilliseconds,
      'markerSize': markerSize,
      'cameraBoundsPadding': cameraBoundsPadding,
      'bearingLerpFactor': bearingLerpFactor,
    };
  }
}

