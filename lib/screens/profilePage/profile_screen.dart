import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/screens/payment/hoc_phi_screen.dart';
import 'package:heathy_teacher/screens/profilePage/detail_info_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            width: 375.w,
            height: 200.h,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    width: 375.w,
                    height: 200.h,
                    image: const AssetImage(
                      'assets/images/person_background.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 40.h,
                  child: SizedBox(
                    width: 375.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 24.w),
                            Text(
                              'Tài khoản',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        NotificationScreen()),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/bell.svg',
                                width: 24.w,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 375.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 138.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lms.cogiaohealthy.vn/${widget.userModel.img}',
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            widget.userModel.fullName ?? 'không xác định',
            style: defaultText18B,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            widget.userModel.phone ?? 'không xác định',
            style: defaultText14M.copyWith(
              color: colorText.withValues(alpha: 0.6),
            ),
          ),
          Text(
            widget.userModel.email ?? 'không xác định',
            style: defaultText14M.copyWith(
              color: colorText.withValues(alpha: 0.6),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailInfoScreen(model: widget.userModel),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/person.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text("Thông tin tài khoản", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/key.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text("Đổi mật khẩu", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => HocPhiScreen())),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(child: Icon(Icons.payment)),
                    ),
                    SizedBox(width: 12.w),
                    Text("Học phí và thanh toán", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _dialogBuilder(context, type: 0),
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(child: Icon(Icons.delete)),
                    ),
                    SizedBox(width: 12.w),
                    Text("Xóa tài khoản", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _dialogBuilder(context, type: 1),
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/logout.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Đăng xuất",
                      style: defaultText14B.copyWith(color: Color(0xffF70B22)),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, {required int type}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          type == 0 ? 'Cảnh báo !!' : 'Đăng xuất',
          style: defaultText16B,
        ),
        content: Text(
          type == 0
              ? 'Bạn có chắc muốn xóa tài khoản ?'
              : 'Bạn có chắc muốn đăng xuất ?',
          style: defaultText14M,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              'Hủy',
              style: defaultText14M.copyWith(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              type == 0 ? 'Xóa Tài Khoản' : 'Đăng xuất',
              style: defaultText14B.copyWith(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) =>
                      const CoGiaoHealthyScreen(type: 'home', place: 'Hà Nội')),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
