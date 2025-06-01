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

- 🗺️ Real-time location tracking with high accuracy
- 🛣️ Route visualization and turn-by-turn navigation
- 🎯 Intelligent off-route detection and automatic rerouting
- 📍 Custom marker support with animations
- 🎨 Highly configurable UI components
- ⚡ Performance optimized with smart debouncing
- 🔄 Real-time ETA calculations and updates
- 📱 Automatic device location tracking
- 🎮 Manual location control support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  live_tracking_map: ^latest_version
```

Then run:
```bash
flutter pub get
```

## Quick Start

### Basic Implementation (Using Device Location)

```dart
import 'package:flutter/material.dart';
import 'package:live_tracking_map/live_tracking_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String etaText = '';
  String distanceText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Tracking')),
      body: Column(
        children: [
          Expanded(
            child: LiveTrackingMapWidget(
              destination: const LatLng(30.314850, 31.314357),
              pickUpLocation: const LatLng(30.0537097, 31.4341895),
              mapService: GoogleMapService(
                apiKey: "YOUR_GOOGLE_MAPS_API_KEY_HERE",
              ),
              // currentLocation is null - will use device location automatically
              currentLocation: null,
              onRoutePointsUpdate: (points) {
                // Handle route points updates
              },
              onDistanceUpdate: (distance) {
                if (mounted) {
                  setState(() {
                    distanceText = '${(distance / 1000).toStringAsFixed(1)} km';
                  });
                }
              },
              onETAUpdate: (eta) {
                if (mounted) {
                  setState(() {
                    etaText = eta.inMinutes > 0 ? '${eta.inMinutes} min' : 'Arrived';
                  });
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Distance: $distanceText'),
                Text('ETA: $etaText'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Custom Location Tracking Implementation

If you need to handle location updates manually (e.g., simulated tracking, custom location provider, or specific tracking logic):

```dart
class CustomTrackingScreen extends StatefulWidget {
  @override
  _CustomTrackingScreenState createState() => _CustomTrackingScreenState();
}

class _CustomTrackingScreenState extends State<CustomTrackingScreen> {
  LatLng? currentLocation;
  String etaText = '';
  String distanceText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Tracking')),
      body: Column(
        children: [
          Expanded(
            child: LiveTrackingMapWidget(
              destination: const LatLng(30.314850, 31.314357),
              pickUpLocation: const LatLng(30.0537097, 31.4341895),
              mapService: GoogleMapService(
                apiKey: "YOUR_GOOGLE_MAPS_API_KEY_HERE",
              ),
              // Provide custom location updates
              currentLocation: currentLocation,
              onRoutePointsUpdate: (points) {
                // Handle route updates
              },
              onDistanceUpdate: (distance) {
                if (mounted) {
                  setState(() {
                    distanceText = '${(distance / 1000).toStringAsFixed(1)} km';
                  });
                }
              },
              onETAUpdate: (eta) {
                if (mounted) {
                  setState(() {
                    etaText = eta.inMinutes > 0 ? '${eta.inMinutes} min' : 'Arrived';
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Example of custom location update
  void updateLocation(LatLng newLocation) {
    setState(() {
      currentLocation = newLocation;
    });
  }
}
```

## Location Tracking Options

### Automatic Device Location (Default)
When `currentLocation` is set to `null`, the package will:
- Automatically request location permissions
- Handle real-time device location updates
- Manage location services state
- Handle background location updates (if configured)

### Manual Location Updates
When providing a `currentLocation`:
- You have full control over the location source
- Useful for custom tracking implementations
- Can be used for simulation or testing
- Allows integration with custom location providers

## Configuration Options

### Map Service Setup

You can use either Google Maps or OpenStreetMap as your map service:

```dart
// For Google Maps
final mapService = GoogleMapService(
  apiKey: "YOUR_GOOGLE_MAPS_API_KEY_HERE",
);

// For OpenStreetMap with OSRM
final mapService = OsrmMapService(
  osrmUrl: "YOUR_OSRM_SERVER_URL",
);
```

### Customizing the Map

```dart
LiveTrackingMapWidget(
  destination: LatLng(latitude, longitude),
  pickUpLocation: LatLng(latitude, longitude),
  mapService: mapService,
  
  // Optional customization
  markerBuilder: (context, markerType) {
    return Icon(
      markerType == MarkerType.destination 
        ? Icons.location_on 
        : Icons.my_location,
      color: Colors.blue,
      size: 30,
    );
  },
  routeColor: Colors.blue,
  routeWidth: 4.0,
);
```

## Project Structure

```
lib/
  ├── src/
  │   ├── models/           # Data models
  │   ├── services/         # Map services
  │   └── widgets/          # UI components
  └── live_tracking_map.dart
```

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For bugs and feature requests, please create an issue on the [GitHub repository](https://github.com/yourusername/live_tracking_map).

For detailed documentation and more examples, visit our [documentation site](https://docs.yourpackage.dev).
