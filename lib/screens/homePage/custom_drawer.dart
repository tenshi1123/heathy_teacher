import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/screens/drawer/thong_tin_uu_dai.dart';
import 'package:heathy_teacher/screens/homePage/home_screen.dart';
import 'package:heathy_teacher/screens/productPage/product_screen.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottom_bar_screen.dart';
import 'package:heathy_teacher/screens/coursePage/course_screen.dart';
import 'package:heathy_teacher/screens/drawer/chinh_sach_screen.dart';
import 'package:heathy_teacher/screens/homePage/schedule_screen.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/screens/drawer/hoc_phi_screen.dart';
import 'package:heathy_teacher/screens/profilePage/profile_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/screens/profilePage/detail_info_screen.dart';
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
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ảnh đại diện (Bạn thay bằng NetworkImage hoặc AssetImage của bạn)
                avatar(userModel.img),
                const SizedBox(height: 16),
                // Tên người dùng
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userModel.fullName ?? 'Không xác định',
                      style: defaultText18B,
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailInfoScreen(model: userModel),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
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
                Text('${userModel.memberRanking}', style: defaultText14B),
                RichText(
                  text: TextSpan(
                    style: defaultText14M,
                    children: [
                      TextSpan(text: 'Điểm tích lũy: '),
                      TextSpan(
                        text: formatPrice(userModel.accumulatedPoint),
                        style: defaultText14B,
                      ),
                      TextSpan(text: ' điểm'),
                    ],
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
                // InkWell(
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const CoGiaoHealthyScreen(
                //           type: 'home',
                //           place: 'Hà Nội',
                //         ),
                //       ),
                //     );
                //   },
                //   child: Image.asset(
                //     "assets/images/logo.png",
                //     height: 73.h,
                //     fit: BoxFit.fitHeight,
                //   ),
                // ),
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
                          builder: (context) => BottomBarScreen(),
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
                _ExpandablePaymentHistory(
                  isSelected: selectedIndex == 3,
                  userModel: userModel,
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
                _buildMenuItem(
                  icon: Icons.view_in_ar_outlined,
                  title: 'Thông tin ưu đãi',
                  isSelected: selectedIndex == 5,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => UuDaiScreen())),
                    );
                  },
                ),
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

class _ExpandablePaymentHistory extends StatefulWidget {
  final bool isSelected;
  final UserModel userModel;
  const _ExpandablePaymentHistory({
    super.key,
    required this.isSelected,
    required this.userModel,
  });

  @override
  State<_ExpandablePaymentHistory> createState() =>
      _ExpandablePaymentHistoryState();
}

class _ExpandablePaymentHistoryState extends State<_ExpandablePaymentHistory> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final Color itemColor = widget.isSelected || _isExpanded
        ? Colors.white
        : const Color(0xFF4A5568);
    final Color bgColor = widget.isSelected || _isExpanded
        ? const Color(0xFF388E3C)
        : Colors.transparent;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(
                color: (widget.isSelected || _isExpanded)
                    ? Colors.transparent
                    : Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
            leading: Icon(Icons.attach_money, color: itemColor, size: 26),
            title: Text(
              'Lịch sử thanh toán',
              style: TextStyle(
                color: itemColor,
                fontSize: 16,
                fontWeight: (widget.isSelected || _isExpanded)
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: itemColor,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        if (_isExpanded)
          Container(
            color: const Color(0xFFF9FAFB),
            child: Column(
              children: [
                _buildSubItem('Sản phẩm', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductScreen(type: 2, userModel: widget.userModel),
                    ),
                  );
                }),
                _buildSubItem('Đã thanh toán', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HocPhiScreen(initialIndex: 1),
                    ),
                  );
                }),
                _buildSubItem('Chờ thanh toán', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HocPhiScreen(initialIndex: 0),
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48, right: 24),
      leading: const Icon(
        Icons.radio_button_unchecked,
        size: 14,
        color: Color(0xFF4A5568),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF4A5568), fontSize: 15),
      ),
      onTap: onTap,
    );
  }
}

Widget avatar(String? img) {
  return ClipOval(
    child: CachedNetworkImage(
      imageUrl: img!.contains('https://')
          ? img
          : 'https://lms.cogiaohealthy.vn/$img',
      width: 50.dg,
      height: 50.dg,
      fit: BoxFit.cover,
      // Hiển thị Icon mặc định khi lỗi tải ảnh
      errorWidget: (context, url, error) {
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
      placeholder: (context, url) {
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
