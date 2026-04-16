class NotificationModel {
  final String title;
  final String image;
  final DateTime time;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.image,
    required this.time,
    this.isRead = false,
  });
}

String getDateTitle(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  if (difference == 0) {
    return 'Hôm nay';
  } else if (difference == 1) {
    return 'Hôm qua';
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}

Map<String, List<NotificationModel>> groupNotifications(
  List<NotificationModel> notifications,
) {
  Map<String, List<NotificationModel>> grouped = {};

  for (var item in notifications) {
    String key = getDateTitle(item.time);

    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }

    grouped[key]!.add(item);
  }

  return grouped;
}
