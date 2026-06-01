import 'package:heathy_teacher/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<CourseSection>> fetchCourseData() async {
  final response = await http.post(
    Uri.parse('https://lms.cogiaohealthy.vn/api/chi-tiet-khoa-hoc'),
    // THÊM VÀO ĐÂY NHÉ:
    headers: {
      'Content-Type': 'application/json',
      'Token': 'Healthy1234567890HVG',
    },
    body: jsonEncode({
      "course_type_id": "163", // Thay bằng course_id thực tế nếu cần
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonList = json.decode(
      utf8.decode(response.bodyBytes),
    );
    return jsonList['topical']
        .map((json) => CourseSection.fromJson(json))
        .toList();
  } else {
    throw Exception('Lỗi tải dữ liệu hoặc Token hết hạn');
  }
}
