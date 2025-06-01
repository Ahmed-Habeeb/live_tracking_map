enum NavigationStatus {
  idle,
  navigating,
  offRoute,
  recalculating,
  completed,
  error,
}

enum TrackingError {
  locationServiceDisabled,
  permissionDenied,
  permissionDeniedForever,
  networkError,
  routeCalculationFailed,
  noRouteFound,
  timeout,
  unknown,
}
