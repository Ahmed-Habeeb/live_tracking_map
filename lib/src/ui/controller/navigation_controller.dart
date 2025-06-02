import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_map/src/models/enums.dart';

import '../../models/navigation_execption.dart';
import '../../models/navigation_state.dart';
import '../../services/loctaion_service/ilocation_service.dart';
import '../../services/route_service/iroute_service.dart';
import '../../tracking_config.dart';

class NavigationController extends ChangeNotifier {
  NavigationController({
    required ILocationService locationService,
    required IRouteService routeService,
  }) : _locationService = locationService,
       _routeService = routeService;
  final ILocationService _locationService;
  final IRouteService _routeService;

  NavigationState _state = const NavigationState(status: NavigationStatus.idle);
  NavigationState get state => _state;

  StreamSubscription<Position>? _positionSubscription;
  Timer? _debounceTimer;
  Timer? _rerouteTimer;
  DateTime? _lastRerouteTime;
  LatLng? _previousPosition;
  LatLng? _destination;

  Future<void> startNavigation(
    LatLng destination, {
    LatLng? pickupLocation,
  }) async {
    try {
      _destination = destination;
      _updateState(_state.copyWith(status: NavigationStatus.navigating));

      final LatLng currentPosition = await _locationService
          .getCurrentPosition();
      _updateState(_state.copyWith(currentPosition: currentPosition));

      // Calculate initial route
      final List<LatLng> waypoints = pickupLocation != null
          ? [pickupLocation, destination]
          : [currentPosition, destination];

      await _calculateRoute(waypoints);
      await _startLocationTracking();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> stopNavigation() async {
    _positionSubscription?.cancel();
    _debounceTimer?.cancel();
    _rerouteTimer?.cancel();
    _locationService.stopLocationTracking();
    _updateState(const NavigationState(status: NavigationStatus.idle));
  }

  Future<void> recalculateRoute() async {
    if (_state.currentPosition == null || _destination == null) return;

    await _calculateRoute([_state.currentPosition!, _destination!]);
  }

  Future<void> _startLocationTracking() async {
    await _locationService.startLocationTracking();
    _positionSubscription = _locationService.positionStream.listen(
      _handlePositionUpdate,
      onError: _handleError,
    );
  }

  void _handlePositionUpdate(Position position) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(TrackingConfig().positionUpdateDebounce, () {
      _processPositionUpdate(position);
    });
  }

  void _processPositionUpdate(Position position) {
    final LatLng currentPosition = LatLng(
      position.latitude,
      position.longitude,
    );
    final double bearing = _calculateBearing(position);

    _updateState(
      _state.copyWith(
        currentPosition: currentPosition,
        currentBearing: bearing,
      ),
    );

    _updateTravelProgress();
    _checkOffRoute();
    _updateETAAndDistance(position.speed);

    _previousPosition = currentPosition;
  }

  double _calculateBearing(Position position) {
    if (_previousPosition == null) return _state.currentBearing;

    final double newBearing = _routeService.calculateBearing(
      _previousPosition!,
      LatLng(position.latitude, position.longitude),
    );

    return _lerpBearing(
      _state.currentBearing,
      newBearing,
      TrackingConfig().bearingLerpFactor,
    );
  }

  double _lerpBearing(double current, double target, double t) {
    double diff = (target - current) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return (current + diff * t) % 360;
  }

  void _updateTravelProgress() {
    if (_state.currentPosition == null || _state.routePoints.isEmpty) return;

    final int closestIndex = _routeService.findClosestPointIndex(
      _state.currentPosition!,
      _state.routePoints,
    );

    final List<LatLng> traveledPoints = _state.routePoints.sublist(
      0,
      closestIndex + 1,
    );
    final List<LatLng> remainingPoints = _state.routePoints.sublist(
      closestIndex,
    );

    _updateState(
      _state.copyWith(
        traveledPoints: traveledPoints,
        routePoints: remainingPoints,
      ),
    );
  }

  void _checkOffRoute() {
    if (_state.currentPosition == null || _state.routePoints.isEmpty) return;

    final bool isNearRoute = _routeService.isPointNearRoute(
      _state.currentPosition!,
      _state.routePoints,
    );

    if (!isNearRoute && _state.status != NavigationStatus.offRoute) {
      _updateState(_state.copyWith(status: NavigationStatus.offRoute));
      _scheduleReroute();
    } else if (isNearRoute && _state.status == NavigationStatus.offRoute) {
      _updateState(_state.copyWith(status: NavigationStatus.navigating));
      _rerouteTimer?.cancel();
    }
  }

  void _scheduleReroute() {
    _rerouteTimer?.cancel();
    _rerouteTimer = Timer(TrackingConfig().rerouteDebounceDuration, () {
      if (_state.status == NavigationStatus.offRoute) {
        _performReroute();
      }
    });
  }

  Future<void> _performReroute() async {
    if (_state.currentPosition == null || _destination == null) return;

    final DateTime now = DateTime.now();
    if (_lastRerouteTime != null &&
        now.difference(_lastRerouteTime!) < TrackingConfig().rerouteCooldown) {
      return;
    }

    try {
      _updateState(_state.copyWith(status: NavigationStatus.recalculating));
      await _calculateRoute([_state.currentPosition!, _destination!]);
      _updateState(_state.copyWith(status: NavigationStatus.navigating));
      _lastRerouteTime = now;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _calculateRoute(List<LatLng> waypoints) async {
    try {
      final List<LatLng> routePoints = await _routeService.calculateRoute(
        waypoints,
      );
      _updateState(_state.copyWith(routePoints: routePoints));
    } catch (e) {
      _handleError(e);
    }
  }

  void _updateETAAndDistance(double speed) {
    if (_state.routePoints.isEmpty) return;

    final double distance = _routeService.calculateDistance(_state.routePoints);
    final Duration eta = _routeService.calculateETA(distance, speed);

    _updateState(
      _state.copyWith(remainingDistance: distance, estimatedETA: eta),
    );
  }

  void _handleError(dynamic error) {
    NavigationException navError;

    if (error is NavigationException) {
      navError = error;
    } else {
      navError = NavigationException(TrackingError.unknown, error.toString());
    }

    _updateState(
      _state.copyWith(
        status: NavigationStatus.error,
        error: navError.type,
        errorMessage: navError.message,
      ),
    );
  }

  void updateState(NavigationState newState) {
    _state = newState;
    notifyListeners();
  }

  void _updateState(NavigationState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    stopNavigation();
    _locationService.dispose();
    super.dispose();
  }
}
