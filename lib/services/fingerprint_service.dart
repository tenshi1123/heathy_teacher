import 'dart:io';
import 'package:flutter/material.dart';

class FingerprintService {
  static Future<String> generateFingerprint(BuildContext context) async {
    final mediaQuery = MediaQuery.of(context);

    // Giống screen.width / screen.height của JS
    final width = mediaQuery.size.width.round();
    final height = mediaQuery.size.height.round();

    // JS đang force max = 24
    final colorDepth = 24;
    final pixelDepth = 24;

    // Timezone normalize
    final timezone = normalizeTimezone(_getTimezone());

    // hardwareConcurrency
    final normalizedCores = normalizeHardwareConcurrency(
      Platform.numberOfProcessors,
    );

    final data = [
      width,
      height,
      colorDepth,
      pixelDepth,
      timezone,
      normalizedCores,
    ].join('|');

    debugPrint('Fingerprint data: $data');

    return simpleHash(data);
  }

  static String _getTimezone() {
    // Android thường trả +07
    // map cứng cho giống JS browser
    final now = DateTime.now();
    final offset = now.timeZoneOffset.inHours;

    switch (offset) {
      case 7:
        return 'Asia/Ho_Chi_Minh';

      case 5:
        return 'Asia/Kolkata';

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

  static String normalizeHardwareConcurrency(int? cores) {
    if (cores == null) return 'unknown';

    if (cores <= 2) return '2';
    if (cores <= 4) return '4';
    if (cores <= 8) return '8';
    if (cores <= 16) return '16';

    return '16+';
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
