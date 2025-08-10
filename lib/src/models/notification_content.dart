class NotificationContent {
  NotificationContent({
    required this.title,
    required this.body,
    this.ongoing = true,
    this.showProgress = false,
    this.indeterminate = false,
    this.progress,
    this.maxProgress,
  });

  final String title;
  final String body;
  final bool ongoing;

  // Progress (Android)
  final bool showProgress;
  final bool indeterminate;
  final int? progress; // 0..maxProgress
  final int? maxProgress; // commonly 100
}