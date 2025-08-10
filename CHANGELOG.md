# Changelog

## 0.0.5
- feat: BackgroundLocationService for background tracking with Android/iOS settings
- feat: LiveTrackingMapWidget flag `useBackgroundService` and `onBackgroundLocation` callback
- feat: ILocationService.startLocationTracking now accepts optional onUpdate
- fix: replace Color.withValues with withOpacity in UI
- fix: null-guard onCurrentLocationUpdate callback
- chore: rename services/loctaion_service to services/location_service
- refactor: remove redundant public updateState in NavigationController 
