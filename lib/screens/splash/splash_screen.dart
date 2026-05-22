import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/screens/splash/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  @override
  void initState() {
    super.initState();
    initDeepLinks();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const CoGiaoHealthyScreen(type: 'home', place: 'Hà Nội'),
        ),
      ),
    );
  }

  void initDeepLinks() async {
    _appLinks = AppLinks();

    // 1. Xử lý link khi app đang TẮT và được mở lên
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      _handleNavigation(appLink);
    }

    // 2. Xử lý link khi app đang CHẠY NGẦM
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleNavigation(uri);
    });
  }

  void _handleNavigation(Uri uri) {
    print('Điều hướng đến: $uri');
    // Dùng Navigator hoặc GoRouter để đẩy học sinh đi đúng trang
  }

  @override
  void dispose() {
    _linkSubscription?.cancel(); // Quan trọng: Hủy để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Image.asset(
        "assets/images/splash.png",
        height: 844.h,
        width: 390.w,
        fit: BoxFit.fill,
      ),
    );
  }
}
