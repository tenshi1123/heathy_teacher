import 'package:heathy_teacher/screens/authentication/login_screen.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class FilterDropdownDialog extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelected;

  const FilterDropdownDialog({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  void _openDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((e) {
              final isSelected = e == selected;

              return InkWell(
                onTap: () => Navigator.pop(context, e),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  color: isSelected ? Colors.blue : Colors.transparent,
                  child: Text(
                    e,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    if (result != null) {
      onSelected(result); // 👈 trả ra ngoài
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue.shade200, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class ScreenshotWarningDialog extends StatelessWidget {
  final String title;
  final String message;

  const ScreenshotWarningDialog({
    super.key,
    this.title = "Cảnh báo",
    this.message =
        "Bạn vừa chụp ảnh màn hình. Hãy cẩn thận với thông tin nhạy cảm.",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const LoginDialog(),
  );
}

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF4A8C3F), // 👈 xanh
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TITLE
            const Text(
              "Chọn để tiếp tục",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON FACEBOOK
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => (LoginScreen()))),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A1F), // 👈 cam
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Đăng nhập/Đăng ký",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// BUTTON OUTLINE
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse('https://m.me/cogiaohealthy'))) {
                  throw Exception('Could not launch ');
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Tư vấn thêm",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCitySelectionDialog({
  required BuildContext context,
  required Function(String city) onCitySelected, // 🔥 Callback truyền ra ngoài
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CHỌN KHU VỰC HỌC",
                style: defaultText16B.copyWith(
                  color: mainDarkGreen,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Vui lòng chọn thành phố bạn muốn tham gia lớp trực tiếp",
                textAlign: TextAlign.center,
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
              SizedBox(height: 20.h),

              // Nút Hà Nội
              _buildCityButton(
                context: context,
                cityName: "Hà Nội",
                icon: Icons.location_city,
                color: mainOrange,
                onTap: () {
                  Navigator.pop(context); // Đóng popup trước
                  onCitySelected("Hà Nội"); // Bắn dữ liệu ra bên ngoài xử lý
                },
              ),

              SizedBox(height: 12.h),

              // Nút TP. Hồ Chí Minh
              _buildCityButton(
                context: context,
                cityName: "TP. Hồ Chí Minh",
                icon: Icons.location_on,
                color: mainDarkGreen,
                onTap: () {
                  Navigator.pop(context); // Đóng popup trước
                  onCitySelected(
                    "TP. Hồ Chí Minh",
                  ); // Bắn dữ liệu ra bên ngoài xử lý
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Giao diện nút bấm giữ nguyên
Widget _buildCityButton({
  required BuildContext context,
  required String cityName,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10.r),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(10.r),
        color: color,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(width: 15.w),
          Text(
            cityName,
            style: defaultText14B.copyWith(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.white),
        ],
      ),
    ),
  );
}

void showOnlineCategoriesDialog({
  required BuildContext context,
  required Function(String category) onCategorySelected,
}) {
  final List<String> categories = const [
    "Khoá học nấu ăn Eatclean - Healthy - Vegan",
    "Khoá học Bánh Kẹo Healthy",
    "Khoá học Đồ uống Healthy",
    "Khoá học Đồ ăn vặt - Tráng miệng Healthy",
    "Khóa học Dưỡng sinh - Thảo mộc",
    "Lớp đồ uống lên men Junbucha và Kombucha",
    "Cộng đồng học viên VIP Cô Giáo Healthy",
  ];

  showDialog(
    context: context,
    barrierDismissible: true, // Bấm ra ngoài để đóng popup
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ), // Khoảng cách popup với 2 rìa màn hình
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          // Sử dụng Constraints để popup tự co giãn theo nội dung nhưng không vượt quá chiều cao màn hình
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tiêu đề của Dialog
              Text(
                "DANH MỤC KHÓA HỌC ONLINE".sanitizeForApple,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 60.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Danh sách cuộn các khung dọc
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(categories.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 12.h,
                        ), // Khoảng cách giữa các khung dọc
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context); // 1. Đóng Dialog trước
                            onCategorySelected(
                              categories[index],
                            ); // 2. Bắn dữ liệu ra ngoài xử lý
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  mainDarkGreen, // Khung xanh lá cây theo yêu cầu
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    categories[index],
                                    style: defaultText16B.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 14.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
