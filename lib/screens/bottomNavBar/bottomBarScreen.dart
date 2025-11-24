import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/chatPage/chat_screen.dart';
import 'package:heathy_teacher/screens/coursePage/course_screen.dart';
import 'package:heathy_teacher/screens/homePage/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heathy_teacher/screens/productPage/product_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: currentIndex,
            children: const [
              HomeScreen(),
              CourseScreen(),
              ChatScreen(),
              ProductScreen(type: 1),
              HomeScreen(),
            ],
          ),

          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: (i) => setState(() => currentIndex = i),
          ),
        ),
        Positioned(
          right: 20.w,
          bottom: 90.h, // nằm ngay trên bottom nav
          child: FloatingCartButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => ShoppingCartScreen())),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            index: 0,
            label: "Trang chủ",
            activeIcon: 'enable_home_icon.svg',
            disableIcon: 'disable_home_icon.svg',
          ),
          _buildItem(
            index: 1,
            label: "Khoá học",
            activeIcon: 'enable_course_icon.svg',
            disableIcon: 'disable_course_icon.svg',
          ),
          _buildItem(
            index: 2,
            label: "Chat",
            activeIcon: 'enable_chat_icon.svg',
            disableIcon: 'disable_chat_icon.svg',
          ),
          _buildItem(
            index: 3,
            label: "Sản phẩm",
            activeIcon: 'enable_product_icon.svg',
            disableIcon: 'disable_product_icon.svg',
          ),
          _buildItem(
            index: 4,
            label: "Tài khoản",
            activeIcon: 'enable_profile_icon.svg',
            disableIcon: 'disable_profile_icon.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,

    required String activeIcon,
    required String disableIcon,
  }) {
    final bool selected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 72.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/${selected ? activeIcon : disableIcon}',
              height: 18.h,
              width: 18.w,
            ),
            // Icon(
            //   icon,
            //   size: 28.r,
            //   color: selected ? Colors.green : Colors.black87,
            // ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: defaultText14M.copyWith(
                color: selected ? mainDarkGreen : colorText,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
