# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package for real-time location tracking and navigation. It provides a customizable map widget with automatic route calculation, off-route detection, and ETA updates. Supports both Google Maps and OpenStreetMap (OSRM) backends.

**Package Name**: live_tracking_map
**Version**: 0.0.4
**SDK**: Dart >=3.0.0 <4.0.0, Flutter >=1.17.0

## Development Commands

### Package Management
```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/live_tracking_map_test.dart
```

### Code Quality
```bash
# Run static analysis (uses flutter_lints)
flutter analyze

# Format code
dart format .

# Check formatting without making changes
dart format --set-exit-if-changed .
```

### Package Publishing (for maintainers)
```bash
# Dry run publish check
flutter pub publish --dry-run

# Actual publish
flutter pub publish
```

## Architecture Overview

### Core Design Pattern: Layered Architecture

The codebase follows a clean layered architecture with clear separation of concerns:

```
UI Layer (widgets/)
    ↓
Controller Layer (controller/)
    ↓
Service Layer (services/)
    ↓
API Layer (api/, map_service/)
```

### Key Architectural Components

**1. State Management**: Uses Provider pattern with ChangeNotifier
- `NavigationController` extends ChangeNotifier and manages navigation state
- Widget tree subscribes to changes via `ChangeNotifierProvider`

**2. Location Tracking Modes**: Dual-mode architecture
- **Device Mode**: When `currentLocation` is null, uses Geolocator for automatic tracking
- **Manual Mode**: When `currentLocation` is provided, caller controls location updates
- This design enables both production use (device GPS) and testing/simulation scenarios

**3. Abstract Map Service Pattern**: Plugin-style extensibility
- `MapService` is an abstract interface
- Two implementations: `GoogleMapService` and `OsrmMapService`
- Easy to add new routing providers by implementing the interface

**4. Singleton Configuration**: `TrackingConfig`
- Global configuration accessible via `TrackingConfig.instance`
- All timing, threshold, and UI parameters centralized
- Can be customized via `TrackingConfiguration` model or direct updates

### Critical Data Flow

1. **Navigation Initialization**:
   - `LiveTrackingMapWidget` creates `NavigationController`
   - Controller calls `startNavigation()` with destination/pickup
   - Route is fetched from `MapService` via `RouteService`
   - Location stream starts (either device or manual)

2. **Position Update Cycle**:
   - New position arrives → debounced (100ms)
   - RouteService calculates distance to route
   - If off-route (>55m) → triggers rerouting with cooldown (5s)
   - Updates ETA, distance, navigation status
   - Notifies listeners → UI rebuilds

3. **Off-Route Detection**:
   - Uses point-to-polyline distance calculation
   - Threshold: 55m (configurable via `TrackingConfig.offRouteThreshold`)
   - Rerouting has both debounce (2s) and cooldown (5s) to prevent spam

### Service Abstractions

**ILocationService** → `LocationService`
- Wraps Geolocator plugin
- Handles permissions and settings
- Provides position stream

**IRouteService** → `RouteService`
- Distance calculations (Haversine formula)
- ETA computation
- Off-route detection logic

**MapService** → `GoogleMapService` / `OsrmMapService`
- Route fetching from external APIs
- Returns list of LatLng points
- Error handling via `NavigationException`

## Important Implementation Details

### Configuration System

The `TrackingConfig` singleton has validation in `updateConfig()`:
- Zoom levels: 1-21 (Google Maps range)
- Map tilt: 0-60 degrees
- Speed thresholds: must be positive
- Bearing lerp factor: 0.0-1.0 (for smooth rotation)

**Usage Pattern**:
```dart
// Global configuration
TrackingConfig.instance.updateConfig(
  offRouteThreshold: 75.0,
  defaultZoom: 18.0,
);

// Or use TrackingConfiguration model
final config = TrackingConfiguration(offRouteThreshold: 75.0);
TrackingConfig.instance.updateFromTrackingConfiguration(config);
```

### Map Animation System

`MapAnimationController` uses frame-based interpolation:
- Smooth camera transitions over `cameraAnimationSteps` (default: 20)
- Lerp for position, bearing, zoom, and tilt
- Bearing uses special lerp to handle 0°/360° wraparound

### Error Handling

- Custom exception: `NavigationException` with error type enum
- API errors wrapped by `ApiErrorHandler`
- Location service errors surface through `NavigationStatus.failed`

### Navigation Status Lifecycle

```
idle → calculating_route → navigating → [off_route] → rerouting → navigating → arrived
                                    ↓
                                  failed (if errors)
```

## Testing Considerations

- Test file exists but is currently minimal (test/live_tracking_map_test.dart)
- When adding tests, mock:
  - `ILocationService` for location streams
  - `MapService` for route API calls
  - `IRouteService` for distance/ETA calculations

## API Integration

### Google Maps Setup
Requires API key with:
- Directions API enabled
- Maps SDK for Android/iOS enabled (if using platform views)

### OSRM Setup
- Self-hosted or public OSRM server
- Endpoint format: `{baseUrl}/route/v1/driving/{start},{end}`
- Returns GeoJSON with route geometry

## Widget Customization

The `LiveTrackingMapWidget` exposes several customization points:
- `markerBuilder`: Custom marker widgets (destination, pickup, current location)
- `routeColor`/`routeWidth`: Route polyline styling
- `trackingConfiguration`: Override all timing/threshold defaults
- Callbacks: `onRoutePointsUpdate`, `onDistanceUpdate`, `onETAUpdate`, `onCurrentLocationUpdate`

## Common Patterns in Codebase

1. **Null-safe navigation**: All service calls use null-aware operators and early returns
2. **Stream management**: Controllers dispose of stream subscriptions in `dispose()`
3. **Debouncing**: Uses `Timer` with cancel-and-reschedule pattern
4. **Builder pattern**: `MapMarkersBuilder` and `MapPolylinesBuilder` for UI construction
5. **Callback propagation**: Events bubble up from services → controller → widget → parent

## Dependency Management

**Critical dependencies**:
- `google_maps_flutter` ^2.10.0 - Map UI
- `geolocator` ^13.0.2 - Location tracking
- `dio` ^5.8.0 - HTTP client
- `provider` ^6.1.5 - State management

**Development**:
- `flutter_lints` ^5.0.0 - Linting rules (standard Flutter lint set)

## Git Workflow

- Main development on feature branches prefixed with `claude/`
- Branch format: `claude/<feature-name>-<session-id>`
- Commits should be descriptive and reference the feature area (e.g., "feat(NavigationController): add reroute cooldown")
- Always use `git push -u origin <branch-name>` for pushing

## Important Notes

- This is a Flutter **package**, not an app - no `main.dart` or runnable application
- The package is designed to be consumed by Flutter apps via pub dependency
- All public APIs are exported through `lib/live_tracking_map.dart`
- Location permissions must be handled by the consuming app (see README examples)
