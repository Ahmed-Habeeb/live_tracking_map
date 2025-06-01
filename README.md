<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Live Tracking Map

A Flutter package for implementing real-time location tracking and navigation features with customizable map interfaces.

## Features

- 🗺️ Real-time location tracking
- 🛣️ Route visualization and navigation
- 🎯 Off-route detection and rerouting
- 📍 Custom marker support
- 🎨 Configurable UI components
- ⚡ Optimized performance with debouncing
- 🔄 Automatic ETA calculations

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  live_tracking_map: ^latest_version
```

## Usage

### Basic Implementation

```dart
// Import the package
import 'package:live_tracking_map/live_tracking_map.dart';

// Use the tracking configuration
final config = TrackingConfig();

// Use in your widget
class MyMapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiveTrackingMap(
      // Add your configuration here
    );
  }
}
```

### Configuration Options

The package provides extensive configuration through `TrackingConfig` with the following default values:

#### Route Detection
- Off-route threshold: 30.0 meters
- Minimum distance filter: 2.0 meters

#### Timing Settings
- Reroute cooldown: 5 seconds
- Reroute debounce: 2 seconds
- Position update debounce: 100 milliseconds
- Location timeout: 10 seconds
- Camera animation duration: 500 milliseconds

#### Map Display
- Default zoom level: 17.0
- Route overview zoom: 15.0
- Map tilt: 45.0
- Route width: 6.0
- Traveled path width: 8.0
- Camera animation steps: 20.0
- Marker size: 60.0
- Camera bounds padding: 50.0
- Bearing lerp factor: 0.2

#### ETA Calculation
- Default speed: 60 km/h
- Minimum speed threshold: 10 km/h
- Minimum ETA: 1 minute

## Project Structure

The package is organized into several key components:

- `api/`: API integration layer
- `models/`: Data models and state management
- `services/`: Business logic and services
- `map_service/`: Map rendering and interaction
- `ui/`: User interface components
- `tracking_config.dart`: Central configuration file

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For bugs and feature requests, please create an issue on the GitHub repository.
