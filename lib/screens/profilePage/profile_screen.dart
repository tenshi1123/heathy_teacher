import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/screens/splash/onboarding.dart';
import 'package:heathy_teacher/screens/splash/wellcome_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
                    child: Image.asset(
                      'assets/images/avatar1.png',
                      width: 100.w,
                      //height: 48.h,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Dương Huyền Anh',
            style: defaultText18B,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            '097 111 6262',
            style: defaultText14M.copyWith(
              color: colorText.withValues(alpha: 0.6),
            ),
          ),
          Text(
            'Abcxyz@cogiaohealthy.com',
            style: defaultText14M.copyWith(
              color: colorText.withValues(alpha: 0.6),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         DetailInfoScreen(model: profileModel),
              //   ),
              // );
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
            onTap: () => _dialogBuilder(context),
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

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Đăng xuất', style: defaultText16B),
        content: Text('Bạn có chắc muốn đăng xuất ?', style: defaultText14M),
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
              'Đăng xuất',
              style: defaultText14B.copyWith(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const Onbonding())),
              );
            },
          ),
        ],
      );
    },
  );
}
