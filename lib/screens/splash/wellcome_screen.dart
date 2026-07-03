import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottom_bar_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../services/social_service.dart';

class WellcomeScreen extends StatefulWidget {
  const WellcomeScreen({super.key});

  @override
  State<WellcomeScreen> createState() => _WellcomeScreenState();
}

class _WellcomeScreenState extends State<WellcomeScreen> {
  ValueNotifier userFb = ValueNotifier('');
  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();
  @override
  void initState() {
    super.initState();
    // Kích hoạt bảo vệ
    _preventScreenshotOn();
  }

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
            ValueListenableBuilder(
              valueListenable: userFb,
              builder: (context, value, child) {
                return (userFb.value == '' || userFb.value == null)
                    ? Center(
                        child: InkWell(
                          onTap: () async {
                            userFb.value = await signInWithFacebook();
                          },
                          child: googlefacebookbutton(
                            'Đăng nhập với Facebook',
                            300.0,
                            "https://upload.wikimedia.org/wikipedia/commons/b/b9/2023_Facebook_icon.svg",
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            googlefacebookbutton(
                              userFb.value["name"] ?? '',
                              300.0,
                              userFb.value["picture"]["data"]["url"],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                bool result = await signOutFromFacebook();
                                if (result) userFb.value = '';
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
              },
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
                    builder: ((context) => const CoGiaoHealthyScreen(
                      type: 'home',
                      place: 'Hà Nội',
                    )),
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

  Widget googlefacebookbutton(text, wid, image) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        height: 55.h,
        width: wid,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20.h,
              width: 20.w,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.asset('assets/images/facebook.png'),
            ),
            SizedBox(width: 16.w),
            Text(text, style: defaultText16B.copyWith(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
