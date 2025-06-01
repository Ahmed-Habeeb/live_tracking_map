

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import '../../map_service/map_service.dart';
import '../../models/enums.dart';
import '../../models/navigation_state.dart';
import '../../services/loctaion_service/location_service.dart';
import '../../services/route_service/route_service.dart';
import '../controller/map_animation_controller.dart';
import '../controller/navigation_controller.dart';
import 'map_markers_builder.dart';
import 'map_polylines_builder.dart';
import 'navigation_status_overlay.dart';

class LiveTrackingMapWidget extends StatefulWidget {
  const LiveTrackingMapWidget({
    required this.destination,
    required this.mapService,
    super.key,
    this.pickUpLocation,
    this.onDistanceUpdate,
    this.onETAUpdate,
    this.onRoutePointsUpdate,
    this.autoRecenter = true,
    this.adjustCamera = true,
    this.pickUpMarker,
    this.carMarker,
    this.destinationMarker,
    this.liveTracking = true,
    this.currentLocation,
    this.initialRoute,
  });

  final MapService mapService; // Your existing MapService
  final LatLng destination;
  final LatLng? pickUpLocation;
  final Function(double)? onDistanceUpdate;
  final Function(Duration)? onETAUpdate;
  final Function(List<LatLng>)? onRoutePointsUpdate;
  final bool autoRecenter;
  final bool adjustCamera;
  final Marker? pickUpMarker;
  final Marker? carMarker;
  final Marker? destinationMarker;
  final bool liveTracking;
  final LatLng? currentLocation;
  final Set<Polyline>? initialRoute;

  @override
  State<LiveTrackingMapWidget> createState() => _LiveTrackingMapWidgetState();
}

class _LiveTrackingMapWidgetState extends State<LiveTrackingMapWidget>
    with SingleTickerProviderStateMixin {
  late NavigationController _navigationController;
  late MapAnimationController _mapAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  // bool _isInitialized = false;

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 15,
    tilt: 45,
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startNavigation();
  }

  void _initializeControllers() {
    final locationService = LocationService();
    final routeService = RouteService(widget.mapService);

    _navigationController = NavigationController(
      locationService: locationService,
      routeService: routeService,
    );

    _mapAnimationController = MapAnimationController();

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeInOut),
    );

    _navigationController.addListener(_onNavigationStateChanged);
  }

  Future<void> _startNavigation() async {
    try {
      // Initialize with current location if provided
      if (widget.currentLocation != null) {
        _navigationController.updateState(
          _navigationController.state.copyWith(
            currentPosition: widget.currentLocation,
          ),
        );
      }

      await _navigationController.startNavigation(
        widget.destination,
        pickupLocation: widget.pickUpLocation,
      );

      setState(() {
        // _isInitialized = true;
      });

      _fadeAnimationController.forward();
    } catch (e) {
      debugPrint('Failed to start navigation: $e');
    }
  }

  void _onNavigationStateChanged() {
    final NavigationState state = _navigationController.state;

    // Update callbacks
    widget.onDistanceUpdate?.call(state.remainingDistance);
    widget.onETAUpdate?.call(state.estimatedETA);
    widget.onRoutePointsUpdate?.call(state.routePoints);

    // Handle camera animation
    if (widget.autoRecenter && state.currentPosition != null) {
      _mapAnimationController.animateToPosition(
        state.currentPosition!,
        bearing: state.currentBearing,
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(LiveTrackingMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle external location updates
    if (widget.currentLocation != null &&
        widget.currentLocation != oldWidget.currentLocation) {
      _navigationController.updateState(
        _navigationController.state.copyWith(
          currentPosition: widget.currentLocation,
        ),
      );

      if (widget.autoRecenter) {
        _mapAnimationController.animateToPosition(
          widget.currentLocation!,
          bearing: _navigationController.state.currentBearing,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _navigationController,
      child: Consumer<NavigationController>(
        builder: (context, controller, child) {
          return Stack(
            children: [
              _buildGoogleMap(controller.state),
              NavigationStatusOverlay(
                state: controller.state,
                fadeAnimation: _fadeAnimation,
              ),
              _buildRecenterButton(),
              _buildManualRerouteButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoogleMap(NavigationState state) {
    return GoogleMap(
      initialCameraPosition: _defaultPosition,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      polylines: MapPolylinesBuilder.build(state),
      markers: MapMarkersBuilder.build(
        state: state,
        pickUpLocation: widget.pickUpLocation,
        destination: widget.destination,
        pickUpMarker: widget.pickUpMarker,
        carMarker: widget.carMarker,
        destinationMarker: widget.destinationMarker,
        liveTracking: widget.liveTracking,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapAnimationController.setMapController(controller);
        if (state.currentPosition != null && widget.autoRecenter) {
          _mapAnimationController.animateToPosition(
            state.currentPosition!,
            bearing: state.currentBearing,
          );
        }
      },
      padding: const EdgeInsets.only(top: 100),
    );
  }

  Widget _buildRecenterButton() {
    return Positioned(
      bottom: 100,
      right: 20,
      child: FloatingActionButton(
        heroTag: "recenter",
        mini: true,
        onPressed: () {
          final state = _navigationController.state;
          if (state.currentPosition != null) {
            _mapAnimationController.animateToPosition(
              state.currentPosition!,
              bearing: state.currentBearing,
            );
          }
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  Widget _buildManualRerouteButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Consumer<NavigationController>(
        builder: (context, controller, child) {
          final bool isCalculating = controller.state.status == NavigationStatus.recalculating;

          return FloatingActionButton(
            heroTag: "reroute",
            onPressed: !isCalculating ? () => controller.recalculateRoute() : null,
            backgroundColor: isCalculating ? Colors.grey : Colors.blue,
            child: isCalculating
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.refresh),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationController.dispose();
    _mapAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }
}

// ==================== USAGE EXAMPLE ====================
/*
// Example of how to use the widget:

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final MapService _mapService = MapService(); // Your map service instance
  double _currentDistance = 0;
  Duration _currentETA = Duration.zero;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveTrackingMapWidget(
        mapService: _mapService,
        destination: LatLng(37.7849, -122.4094), // Your destination
        pickUpLocation: LatLng(37.7749, -122.4194), // Optional pickup
        autoRecenter: true,
        adjustCamera: true,
        liveTracking: true,
        onDistanceUpdate: (distance) {
          setState(() {
            _currentDistance = distance;
          });
        },
        onETAUpdate: (eta) {
          setState(() {
            _currentETA = eta;
          });
        },
        onRoutePointsUpdate: (points) {
          print('Route updated with ${points.length} points');
        },
        carMarker: Marker(
          markerId: MarkerId('car'),
          position: LatLng(0, 0), // Will be updated by widget
        ),
        destinationMarker: Marker(
          markerId: MarkerId('destination'),
          position: LatLng(37.7849, -122.4094),
        ),
      ),
    );
  }
}
*/