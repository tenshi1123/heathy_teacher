import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottomBarScreen.dart';
import 'package:heathy_teacher/screens/coursePage/course_screen.dart';
import 'package:heathy_teacher/screens/drawer/chinh_sach_screen.dart';
import 'package:heathy_teacher/screens/homePage/schedule_screen.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/screens/drawer/hoc_phi_screen.dart';
import 'package:heathy_teacher/screens/profilePage/profile_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class MyCustomDrawer extends StatelessWidget {
  const MyCustomDrawer({
    super.key,
    required this.userModel,
    required this.selectedIndex,
  });
  final UserModel userModel;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // --- PHẦN HEADER ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ảnh đại diện (Bạn thay bằng NetworkImage hoặc AssetImage của bạn)
                avatar(userModel.img),
                const SizedBox(height: 16),
                // Tên người dùng
                Text(
                  userModel.fullName ?? 'Không xác định',
                  style: defaultText18B,
                ),
                const SizedBox(height: 4),
                // Số điện thoại
                Text(
                  userModel.phone ?? 'Không xác định',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF858C94), // Màu xám nhạt
                  ),
                ),
              ],
            ),
          ),

          // --- PHẦN DANH SÁCH MENU ---
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CoGiaoHealthyScreen(
                          type: 'home',
                          place: 'Hà Nội',
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 73.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.home_outlined,
                  title: 'Tổng quan',
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    final bottomBarState = context
                        .findAncestorStateOfType<BottomBarScreenState>();
                    if (bottomBarState != null) {
                      bottomBarState.changeTab(0);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseScreen(userModel: userModel),
                        ),
                      );
                    }
                  },
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'Khóa học của tôi'.sanitizeForApple,
                  badgeCount: 0,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    final bottomBarState = context
                        .findAncestorStateOfType<BottomBarScreenState>();
                    if (bottomBarState != null) {
                      bottomBarState.changeTab(1);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseScreen(userModel: userModel),
                        ),
                      );
                    }
                  },
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Lịch học trực tiếp',
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => CalenderScreen()),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.attach_money,
                  title: 'Lịch sử thanh toán',
                  //hasTrailingArrow: true,
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => HocPhiScreen())),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications_none,
                  title: 'Thông báo',
                  isSelected: selectedIndex == 4,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                ),
                // _buildMenuItem(
                //   icon: Icons.view_in_ar_outlined,
                //   title: 'Thông tin ưu đãi',
                //   isSelected: selectedIndex == 5,
                // ),
                _buildMenuItem(
                  icon: Icons.format_list_bulleted,
                  title: 'Chính sách',
                  isSelected: selectedIndex == 6,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ChinhSachScreen()),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  onTap: () => dialogBuilder(context, type: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HÀM XÂY DỰNG TỪNG ITEM ---
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
    int? badgeCount,
    bool hasTrailingArrow = false,
  }) {
    // Màu sắc thay đổi dựa trên trạng thái "được chọn"
    final Color itemColor = isSelected ? Colors.white : const Color(0xFF4A5568);
    final Color bgColor = isSelected
        ? const Color(0xFF388E3C)
        : Colors.transparent; // Xanh lá cây

    // Xử lý Icon và Badge (Chấm đỏ thông báo)
    Widget iconWidget = Icon(icon, color: itemColor, size: 26);

    if (badgeCount != null) {
      iconWidget = Badge(
        label: Text(
          '$badgeCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        offset: const Offset(8, -8), // Chỉnh vị trí badge cho khớp thiết kế
        child: iconWidget,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          // Đường kẻ xám mờ ở dưới mỗi item
          bottom: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        leading: iconWidget,
        title: Text(
          title,
          style: TextStyle(
            color: itemColor,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: hasTrailingArrow
            ? const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A5568))
            : null,
        onTap: onTap,
      ),
    );
  }
}

Widget avatar(String? img) {
  return ClipOval(
    child: Image.network(
      img!.contains('https://') ? img : 'https://lms.cogiaohealthy.vn/$img',
      width: 50.dg,
      height: 50.dg,
      fit: BoxFit.cover,
      // Hiển thị Icon mặc định khi lỗi tải ảnh
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Container(
              width: 50.dg,
              height: 50.dg,
              color: Colors.grey[200], // Màu nền của icon mặc định
              child: Icon(
                Icons.person, // Hoặc Icons.error_outline tuỳ ý bạn
                size: 30.dg,
                color: Colors.grey,
              ),
            );
          },
      // (Tuỳ chọn) Hiển thị vòng xoay loading trong lúc đang tải ảnh
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child; // Đã tải xong
            }
            return Container(
              width: 80.w,
              height: 80.h,
              color: Colors.grey[100],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
    ),
  );
}
