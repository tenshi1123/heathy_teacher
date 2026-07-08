import 'package:flutter/material.dart';

class FingerprintService {
  static Future<String> generateFingerprint() async {
    // Đồng bộ với JS:
    // - width/height    : BỎ — không ổn định (rotation, split screen)
    // - hardwareConcurrency: BỎ — không dùng trong JS nữa
    // - colorDepth/pixelDepth: cố định 24
    // - timezone        : normalize alias
    // - maxTouchPoints  : mobile luôn là touch → cố định 5 (giống navigator.maxTouchPoints trên mobile browser)
    // Platform (iOS/Android) được kết hợp ở server qua buildFingerprint() — không cần gửi lên

    const colorDepth = 24;
    const pixelDepth = 24;
    const maxTouchPoints = 5; // mobile luôn là touch device

    final timezone = normalizeTimezone(_getTimezone());

    final data = [colorDepth, pixelDepth, timezone, maxTouchPoints].join('|');

    debugPrint('Fingerprint data: $data');

    return simpleHash(data);
  }

  static String _getTimezone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset.inHours;

    // Map offset về tên chuẩn giống browser JS
    switch (offset) {
      case 7:
        return 'Asia/Ho_Chi_Minh';
      case 5:
        return 'Asia/Kolkata';
      case 6:
        return 'Asia/Yangon';
      case 8:
        return 'Asia/Shanghai';
      case 9:
        return 'Asia/Tokyo';
      default:
        return now.timeZoneName;
    }
  }

  static String normalizeTimezone(String tz) {
    const aliases = {
      'Asia/Saigon': 'Asia/Ho_Chi_Minh',
      'Asia/Calcutta': 'Asia/Kolkata',
      'Asia/Rangoon': 'Asia/Yangon',
      'Asia/Katmandu': 'Asia/Kathmandu',
      'Asia/Dacca': 'Asia/Dhaka',
      'Asia/Ulaanbaatar': 'Asia/Ulan_Bator',
    };

    return aliases[tz] ?? tz;
  }

  static String simpleHash(String str) {
    int hash = 0;

    for (int i = 0; i < str.length; i++) {
      final char = str.codeUnitAt(i);
      hash = ((hash << 5) - hash + char) & 0xFFFFFFFF;
    }

    return (hash & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
  }
}
