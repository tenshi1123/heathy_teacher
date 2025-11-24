import 'package:intl/intl.dart';

class ScheduleModel {
  final String courseName;
  final String buoiHoc;
  final DateTime createdDate;
  final String timeStart;
  final String timeEnd;
  final String? phongHocName;
  final String? cosoName;
  final String? checkinOffId;
  final String? linkZoom;
  final String? meetingId;
  final String typeLearn;
  ScheduleModel({
    required this.courseName,
    required this.buoiHoc,
    required this.createdDate,
    required this.timeStart,
    required this.timeEnd,
    this.phongHocName,
    this.cosoName,
    this.checkinOffId,
    this.linkZoom,
    this.meetingId,
    required this.typeLearn,
  });
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      courseName: json["course_name"] ?? '',
      buoiHoc: json["buoi_hoc"] ?? '',
      createdDate: DateFormat("dd-MM-yyyy").parse(json["created_date"] ?? ''),
      timeStart: json["time_start"] ?? '',
      timeEnd: json["time_end"] ?? '',
      phongHocName: json["phonghoc_name"],
      cosoName: json["coso_name"],
      checkinOffId: json["checkin_off_id"],
      linkZoom: json["link_zoom"],
      meetingId: json["meeting_id"],
      typeLearn: json["type_learn"] ?? '',
    );
  }
}
