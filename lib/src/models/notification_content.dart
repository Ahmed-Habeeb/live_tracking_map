class NotificationContent {
  NotificationContent({
    required this.title,
    required this.body,
    this.ongoing = true,
  });

  final String title;
  final String body;
  final bool ongoing;
}