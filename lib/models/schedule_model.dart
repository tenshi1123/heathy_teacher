import 'package:heathy_teacher/utils/apple_sanitizer.dart';

class ScheduleModel {
  final String id;
  final String name;
  final String? title;
  final String? className;
  final String? nameLesson;
  final String? address;

  final String? courseScheduleName;
  final String? cosoName;
  final String? phongHocName;
  final String? gvStatus;

  // Thời gian đã được đưa về chung kiểu DateTime
  final DateTime? startTime;
  final DateTime? endTime;

  ScheduleModel({
    required this.id,
    required this.name,
    this.title,
    this.className,
    this.nameLesson,
    this.address,
    this.courseScheduleName,
    this.cosoName,
    this.phongHocName,
    this.gvStatus,
    this.startTime,
    this.endTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    // 1. Xử lý Start Time (Gộp Data 1 hoặc ghép chuỗi Data 2)
    DateTime? parsedStartTime;
    if (json["start"] != null) {
      parsedStartTime = DateTime.tryParse(json["start"]);
    } else if (json["created_date"] != null && json["time_start"] != null) {
      // Nối "2025-12-26" và "08:54:00" thành "2025-12-26 08:54:00" rồi mới parse
      parsedStartTime = DateTime.tryParse(
        "${json['created_date']} ${json['time_start']}",
      );
    }

    // 2. Xử lý End Time (Gộp Data 1 hoặc ghép chuỗi Data 2)
    DateTime? parsedEndTime;
    if (json["end"] != null) {
      parsedEndTime = DateTime.tryParse(json["end"]);
    } else if (json["created_date"] != null && json["time_end"] != null) {
      parsedEndTime = DateTime.tryParse(
        "${json['created_date']} ${json['time_end']}",
      );
    }

    return ScheduleModel(
      id: json["id"] ?? '',
      name: ((json["name"] as String?)?.sanitizeForApple) ?? '',
      title: (json["title"] as String?)?.sanitizeForApple,
      className: (json["className"] as String?)?.sanitizeForApple,
      nameLesson: (json["name_lesson"] as String?)?.sanitizeForApple,

      // Vẫn giữ cơ chế gộp address như trước
      address: json["address"] ?? json["coso_address"],
      courseScheduleName: (json["course_schedule_name"] as String?)?.sanitizeForApple,
      cosoName: json["coso_name"],
      phongHocName: json["phonghoc_name"],
      gvStatus: json["gv_status"],

      // Gắn DateTime đã parse vào đây
      startTime: parsedStartTime,
      endTime: parsedEndTime,
    );
  }
}

class RecipeModel {
  final String title;
  final String imageUrl;
  final String date;
  final String? detail;

  RecipeModel({
    required this.title,
    required this.imageUrl,
    required this.date,
    this.detail,
  });
}
