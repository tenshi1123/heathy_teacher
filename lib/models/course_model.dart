import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';

class CourseScheduleModel {
  final String? courseId;
  final String? courseName;
  final String? courseScheduleId;
  final String? courseTypeId;
  final String? courseScheduleName;
  final String? slug;
  final String? img;
  final String? metaDescription;
  final String? soBuoiHoc;
  final String? lessonNumber;
  final String? settingCourseTypeId;
  final String? settingCourseTypeName;
  final String? settingCourseTypeType;
  final String? price;
  final int? percentLearning;

  CourseScheduleModel({
    this.courseId,
    this.courseName,
    this.courseScheduleId,
    this.courseTypeId,
    this.courseScheduleName,
    this.slug,
    this.img,
    this.metaDescription,
    this.soBuoiHoc,
    this.lessonNumber,
    this.settingCourseTypeId,
    this.settingCourseTypeName,
    this.settingCourseTypeType,
    this.price,
    this.percentLearning,
  });

  factory CourseScheduleModel.fromJson(Map<String, dynamic> json) {
    return CourseScheduleModel(
      courseId: json['course_id'],
      courseName: (json['course_name'] as String?).sanitizeForApple,
      courseScheduleId: json['course_schedule_id'],
      courseTypeId: json['course_type_id'],
      courseScheduleName:
          (json['course_schedule_name'] as String?).sanitizeForApple,
      slug: json['slug'],
      img: json['img'],
      metaDescription: (json['meta_description'] as String?).sanitizeForApple,
      soBuoiHoc: json['so_buoi_hoc'],
      lessonNumber: json['lesson_number'],
      settingCourseTypeId: json['setting_course_type_id'],
      settingCourseTypeName: json['setting_course_type_name'],
      settingCourseTypeType: json['setting_course_type_type'],
      price: json['price'],
      percentLearning: json['percent_learning'],
    );
  }
}

class LessonModel {
  final String? lessonsId;
  final String? name;
  final String? time;

  LessonModel({this.lessonsId, this.name, this.time});

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    lessonsId: json['lessons_id'],
    name: json['name'],
    time: json['time'],
  );
}

class DocumentModel {
  final String? id;
  final String? name;
  final String? url;

  DocumentModel({this.id, this.name, this.url});

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      DocumentModel(id: json['id'], name: json['name'], url: json['url']);
}

class TopicalModel {
  final String? id;
  final String? name;
  final List<LessonModel>? lessons;
  final List<DocumentModel>? documents;

  TopicalModel({this.id, this.name, this.lessons, this.documents});

  factory TopicalModel.fromJson(Map<String, dynamic> json) => TopicalModel(
    id: json['id'],
    name: json['name'],
    // Quét list lesson và document, nếu null thì trả về mảng rỗng
    lessons:
        (json['lesson'] as List?)
            ?.map((e) => LessonModel.fromJson(e))
            .toList() ??
        [],
    documents:
        (json['document'] as List?)
            ?.map((e) => DocumentModel.fromJson(e))
            .toList() ??
        [],
  );
}

class CourseDetailModel {
  final String? id;
  final String? title;
  final String? description;
  final String? content;
  final String? image;
  final String? price;
  final String? priceOld;
  final String? youtubeUrl;
  final List<TopicalModel>? topicals;
  final List<dynamic>? feedbacks; // Thêm list feedback

  CourseDetailModel({
    this.id,
    this.title,
    this.description,
    this.content,
    this.image,
    this.price,
    this.priceOld,
    this.youtubeUrl,
    this.topicals,
    this.feedbacks,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    final rootObj =
        json['course'] ??
        (json['data'] != null ? json['data']['value'] : json) ??
        {};

    // Xử lý chuỗi JSON của Feedback
    List<dynamic> parsedFeedbacks = [];
    if (rootObj['feedback'] != null &&
        rootObj['feedback'] is String &&
        rootObj['feedback'].isNotEmpty) {
      try {
        final fbData = jsonDecode(rootObj['feedback']);
        parsedFeedbacks = fbData['value'] ?? [];
      } catch (e) {
        debugPrint("Lỗi parse feedback: $e");
      }
    }

    return CourseDetailModel(
      id: rootObj['course_id'] ?? rootObj['id'],
      title: (rootObj['course_name'] ?? rootObj['name'] ?? json['title'])
          ?.toString()
          .sanitizeForApple,
      description:
          (rootObj['meta_description'] ??
                  rootObj['description'] ??
                  json['description'])
              ?.toString()
              .sanitizeForApple,
      content: rootObj['content'] ?? json['content'],
      image: rootObj['img'] ?? json['image'],
      price: rootObj['price']?.toString(),
      priceOld: rootObj['price_old']?.toString(),
      // Lấy link youtube
      youtubeUrl: rootObj['url_youtube_2']?.toString().isNotEmpty == true
          ? rootObj['url_youtube_2']
          : rootObj['url_youtube'],
      topicals:
          (json['topical'] as List?)
              ?.map((e) => TopicalModel.fromJson(e))
              .toList() ??
          [],
      feedbacks: parsedFeedbacks,
    );
  }
}

class CourseModel {
  final String? categoryName;
  final String? topicName;
  final String? courseId;
  final String? courseName;
  final String? slug;
  final String? description;
  final String? img;
  final String? lessonNumber;
  final String? startCount;
  final String? categoryId;
  final String? courseTypeName;
  final String? courseTypeId;
  final String? price;
  final String? priceOld;
  final String? totalEnrollments;
  final String? lecturerName;

  CourseModel({
    this.categoryName,
    this.topicName,
    this.courseId,
    this.courseName,
    this.slug,
    this.description,
    this.img,
    this.lessonNumber,
    this.startCount,
    this.categoryId,
    this.courseTypeName,
    this.courseTypeId,
    this.price,
    this.priceOld,
    this.totalEnrollments,
    this.lecturerName,
  });
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      categoryName: json['category_name'] as String?,
      topicName: json['topic_name'] as String?,
      courseId: json['course_id'] as String?,
      courseName: (json['course_name'] as String?).sanitizeForApple,
      slug: json['slug'] as String?,
      description: (json['description'] as String?).sanitizeForApple,
      img: json['img'] as String?,
      lessonNumber: json['lesson_number'] as String?,
      startCount: json['start_count'] as String?,
      categoryId: json['category_id'] as String?,
      courseTypeName: json['course_type_name'] as String?,
      courseTypeId: json['course_type_id'] as String?,
      price: json['price'] as String?,
      priceOld: json['price_old'] as String?,
      totalEnrollments: json['total_enrollments'] as String?,
      lecturerName: json['lecturer_name'] as String?,
    );
  }
}

class CourseOffModel {
  final String? id, name, img, price, priceOld, dateStart, province, lecturer;
  CourseOffModel({
    this.id,
    this.name,
    this.img,
    this.price,
    this.priceOld,
    this.dateStart,
    this.province,
    this.lecturer,
  });
  factory CourseOffModel.fromJson(Map<String, dynamic> json) {
    return CourseOffModel(
      id: json['course_type_id'],
      name: (json['course_schedule_name'] as String?).sanitizeForApple,
      img: json['img'],
      price: json['price'],
      priceOld: json['price_old'],
      dateStart: json['date_start'],
      province: json['coso_province'],
      lecturer: json['lecturer_name'],
    );
  }
}
