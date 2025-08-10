class NotificationOptions {
  NotificationOptions({
    this.channelId = 'live_tracking_channel',
    this.channelName = 'Live Tracking',
    this.channelDescription = 'Live tracking status updates',
    this.iconName,
    this.enableOngoing = true,
    this.playSound = false,
    this.importanceHigh = true,
    this.showWhen = false,
  });

  final String channelId;
  final String channelName;
  final String channelDescription;
  final String? iconName; // Android drawable name
  final bool enableOngoing;
  final bool playSound;
  final bool importanceHigh;
  final bool showWhen;
}