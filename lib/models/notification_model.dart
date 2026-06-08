class NotificationModel {
  final String id;
  final String title;
  final String content;
  final String link;
  final String customerId;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.customerId,
    required this.createdAt,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"] ?? '',
      title: json["title"] ?? '',
      content: json["content"] ?? '',
      link: json["link"] ?? '',
      customerId: json["customer_id"] ?? '',
      createdAt: DateTime.parse(
        json["created_at"] ?? DateTime.now().toString(),
      ),
    );
  }
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
    String key = getDateTitle(item.createdAt);

    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }

    grouped[key]!.add(item);
  }

  return grouped;
}
