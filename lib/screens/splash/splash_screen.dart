import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:restart_app/restart_app.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottom_bar_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final _shorebirdUpdater = ShorebirdUpdater();
  final bool _isDownloadingPatch = false;

  // Biến cờ để theo dõi xem app đã được mở từ Deep Link chưa
  bool _openedFromDeepLink = false;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    _checkTokenAndNavigate();
  }

  Future<bool> _checkForUpdate() async {
    try {
      final status = await _shorebirdUpdater.checkForUpdate();
      if (status == UpdateStatus.outdated) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                title: Text(
                  'Có bản cập nhật mới',
                  style: defaultText16B,
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: mainDarkGreen),
                    SizedBox(height: 16.h),
                    Text(
                      'Hệ thống đang tải dữ liệu bản vá mới, vui lòng không tắt ứng dụng...',
                      style: defaultText14M,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        }

        await _shorebirdUpdater.update();

        if (mounted) {
          Navigator.pop(context); // Đóng dialog đang tải
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                title: Text('Cập nhật hoàn tất', style: defaultText16B),
                content: Text(
                  'Vui lòng khởi động lại ứng dụng để áp dụng thay đổi mới nhất.',
                  style: defaultText14M,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Restart.restartApp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainDarkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Khởi động lại ngay',
                      style: defaultText16B.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return true; // Có update và đang chờ restart
      }
    } catch (e) {
      print('Lỗi cập nhật Shorebird: $e');
    }
    return false; // Không có update
  }

  Future<void> _checkTokenAndNavigate() async {
    // Kiểm tra bản vá Shorebird trước tiên
    bool isUpdating = await _checkForUpdate();
    if (isUpdating) return; // Dừng luồng chờ user khởi động lại

    if (_openedFromDeepLink) return;

    // Lấy danh sách lớp on và off lúc chờ vào app
    try {
      final futureCourse = ExternalRepo().getListCourse(show: 6);
      final futureFreeCourse = ExternalRepo().getListFreeCourse(show: 6);
      final futureCourseOff = ExternalRepo().getListCourseOff(show: 6);

      globalListCourse = await futureCourse;
      globalListFreeCourse = await futureFreeCourse;
      globalListCourseOff = await futureCourseOff;
    } catch (e) {
      print('Lỗi gọi danh sách khoá học: $e'.sanitizeForApple);
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CoGiaoHealthyScreen(type: 'home', place: 'Hà Nội'),
      ),
    );
  }

  void initDeepLinks() async {
    _appLinks = AppLinks();

    // 1. Xử lý link khi app đang TẮT và được mở lên
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      _openedFromDeepLink = true; // Đánh dấu đã mở từ Deep Link
      _handleNavigation(appLink);
    }

    // 2. Xử lý link khi app đang CHẠY NGẦM
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleNavigation(uri);
    });
  }

  void _handleNavigation(Uri uri) {
    print('Điều hướng đến: $uri');
    // TODO: Dùng Navigator hoặc GoRouter để đẩy học sinh đi đúng trang
    // Lưu ý: Nhớ dùng pushReplacement nếu chuyển hướng thẳng từ Splash
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
      body: Stack(
        children: [
          Image.asset(
            "assets/images/splash.png",
            height: 844.h,
            width: 390.w,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: mainDarkGreen),
                if (_isDownloadingPatch) ...[
                  SizedBox(height: 16.h),
                  Text(
                    'Đang tải bản cập nhật, vui lòng đợi...',
                    style: TextStyle(
                      color: mainDarkGreen,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
