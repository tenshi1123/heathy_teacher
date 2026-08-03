import 'package:upgrader/upgrader.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/screens/chatPage/list_chat_screen.dart';
import 'package:heathy_teacher/screens/coursePage/course_screen.dart';
import 'package:heathy_teacher/screens/homePage/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heathy_teacher/screens/productPage/list_product_screen.dart';
import 'package:heathy_teacher/screens/profilePage/profile_screen.dart';
import 'package:heathy_teacher/screens/productPage/product_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => BottomBarScreenState();
}

class BottomBarScreenState extends State<BottomBarScreen> {
  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  CustomerModel? customerModel;
  UserModel? userModel;

  bool isLoading = true;
  int currentIndex = 4; // Default to Account tab (index 4)

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      customerModel = await HomeRepo().getCustomer();
      userModel = await HomeRepo().getUserProfile();
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu người dùng: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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

    if (userModel == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Không thể tải dữ liệu người dùng."),
              TextButton(
                onPressed: () {
                  setState(() => isLoading = true);
                  _fetchData();
                },
                child: const Text("Thử lại"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const CoGiaoHealthyScreen(
                        type: 'home',
                        place: 'Hà Nội',
                      )),
                    ),
                  );
                },
                child: const Text("Quay lại trang ngoài"),
              ),
            ],
          ),
        ),
      );
    }

    return UpgradeAlert(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: currentIndex,
              children: [
                HomeScreen(
                  userModel: userModel!,
                  customerModel: customerModel!,
                  onCourseTabRequested: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  onProductTabRequested: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                ),
                CourseScreen(userModel: userModel!),
                ListChatScreen(userModel: userModel!),
                ListProductScreen(userModel: userModel!),
                HomeScreen(
                  userModel: userModel!,
                  customerModel: customerModel!,
                  onCourseTabRequested: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  onProductTabRequested: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(
                          type: 1,
                          userModel: userModel!,
                        ),
                      ),
                    );
                  },
                ),
                //ofileScreen(userModel: userModel!),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: currentIndex,
              onTap: (i) {
                if (i == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const CoGiaoHealthyScreen(
                        type: 'home',
                        place: 'Hà Nội',
                      )),
                    ),
                  );
                } else {
                  setState(() => currentIndex = i);
                }
              },
            ),
          ),
          //if (isShow == 'true')
          Positioned(
            right: 20.w,
            bottom: 90.h,
            child: FloatingCartButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => ShoppingCartScreen()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
            label: "Khoá học".sanitizeForApple,
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
            label: isShow == 'true' ? "Gian Hàng" : "Nguyên liệu",
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
        width: 75.w,
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
