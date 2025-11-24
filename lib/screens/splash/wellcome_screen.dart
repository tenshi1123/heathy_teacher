import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottomBarScreen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wellcome_background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80.h),
            Image.asset(
              "assets/images/logo.png",
              height: 73.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 83.h),
            Image.asset(
              "assets/images/wellcome_hello.png",
              height: 160.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 20.h),
            Text('Sẵn sàng cho hành trình bếp healthy?', style: defaultText18B),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Khám phá công thức ngon – bổ – lành mạnh, học nấu ăn mọi lúc, mọi nơi',
                textAlign: TextAlign.center,
                style: defaultText16Re,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const BottomBarScreen()),
                  ),
                );
              },
              child: Container(
                height: 48.h,
                width: 340.w,
                margin: EdgeInsets.only(bottom: 20.h, top: 28.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: mainDarkGreen,
                ),
                child: Center(
                  child: Text(
                    'Đăng nhập trải nghiệm ngay',
                    textAlign: TextAlign.center,
                    style: defaultText16B.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const BottomBarScreen()),
                  ),
                );
              },
              child: Container(
                height: 48.h,
                width: 340.w,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.white,
                  border: Border.all(color: mainDarkGreen, width: 1.w),
                ),
                child: Center(
                  child: Text(
                    'Trải nghiệm với tư cách khách mời',
                    textAlign: TextAlign.center,
                    style: defaultText16B.copyWith(color: mainDarkGreen),
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
