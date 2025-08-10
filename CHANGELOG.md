# Changelog

## 0.0.5
- feat: BackgroundLocationService for background tracking with Android/iOS settings
- feat: LiveTrackingMapWidget flag `useBackgroundService` and `onBackgroundLocation` callback
- feat: ILocationService.startLocationTracking now accepts optional onUpdate
- fix: replace Color.withValues with withOpacity in UI
- fix: null-guard onCurrentLocationUpdate callback
- chore: rename services/loctaion_service to services/location_service
- refactor: remove redundant public updateState in NavigationController 

## 0.0.6
- feat: customizable notifications (interface + local implementation) with fully developer-controlled content and options
- feat: widget/controller wiring to enable notifications and inject custom service
- deps: add flutter_local_notifications 

## 0.0.7
- feat: notification presenters (simple + progress) with Android progress bar that reaches 100% on arrival
- feat: widget/controller accept custom presenter injection 
