import 'package:heathy_teacher/main.dart';

extension AppleSanitize on String {
  String get sanitizeForApple {
    if (isShow == 'true') return this;

    String result = this;

    // Handle "khoá học online", "khóa học online", "học online" (case insensitive)
    result = result.replaceAll(
      RegExp(r'khoá học online', caseSensitive: false),
      'Ôn tập',
    );
    result = result.replaceAll(
      RegExp(r'khóa học online', caseSensitive: false),
      'Ôn tập',
    );
    result = result.replaceAll(
      RegExp(r'học online', caseSensitive: false),
      'Ôn tập',
    );
    result = result.replaceAll(
      RegExp(r'online', caseSensitive: false),
      'trực tiếp',
    );
    return result;
  }
}

extension NullableAppleSanitize on String? {
  String? get sanitizeForApple {
    if (this == null) return null;
    return this!.sanitizeForApple;
  }
}
