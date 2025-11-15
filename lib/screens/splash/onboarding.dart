import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/splash/wellcome_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import '../../../utils/constants/mediaqury.dart';
import '../../../utils/constants/vn_languegua.dart';
import '../../utils/constants/styles.dart';

class Onbonding extends StatefulWidget {
  const Onbonding({super.key});

  @override
  OnbondingState createState() => OnbondingState();
}

class OnbondingState extends State<Onbonding> {
  final int _numPages = 3;

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  late bool isLoading;

  @override
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: mainOrange, // Màu nền của vùng ngày giờ
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light, // Màu icon ngày giờ
      ),
    );
    super.initState();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 8.h,
      width: isActive ? 20.w : 8.h,
      decoration: BoxDecoration(
        color: isActive ? mainDarkGreen : Color(0xffC7DDB8),
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    height: 700.h,
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 36.h),
                            Image.asset(
                              "assets/images/logo.png",
                              height: 73.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 60.h),
                            Image.asset(
                              "assets/images/onboard1.png",
                              height: 260.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Nấu ăn ngon – Sống khỏe mỗi ngày',
                              style: defaultText18B,
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                VnString.itisrecommended,
                                textAlign: TextAlign.center,
                                style: defaultText16Re,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 36.h),
                            Image.asset(
                              "assets/images/logo.png",
                              height: 73.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 60.h),
                            Image.asset(
                              "assets/images/onboard2.png",
                              height: 260.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Bài học trực tuyến sinh động',
                              style: defaultText18B,
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                VnString.withtimelynotification,
                                textAlign: TextAlign.center,
                                style: defaultText16Re,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 36.h),
                            Image.asset(
                              "assets/images/logo.png",
                              height: 73.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 60.h),
                            Image.asset(
                              "assets/images/onboard3.png",
                              height: 260.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 20.h),
                            Text('Kết nối & chia sẻ', style: defaultText18B),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                VnString.thaksforfunevent,
                                textAlign: TextAlign.center,
                                style: defaultText16Re,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Spacer(),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildPageIndicator(),
                            ),
                          ),
                          SizedBox(height: 102.h),
                          InkWell(
                            onTap: () {
                              _currentPage != _numPages - 1
                                  ? _pageController.nextPage(
                                      duration: const Duration(
                                        microseconds: 300,
                                      ),
                                      curve: Curves.easeIn,
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            const WellcomeScreen()),
                                      ),
                                    );
                            },
                            child: Container(
                              height: 48.h,
                              width: 340.w,
                              margin: EdgeInsets.only(bottom: 20.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.r),
                                color: mainDarkGreen,
                              ),
                              child: Center(
                                child: Text(
                                  'Tiếp tục',
                                  textAlign: TextAlign.center,
                                  style: defaultText16B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
