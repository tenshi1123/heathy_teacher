import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottom_bar_screen.dart';
import 'package:heathy_teacher/screens/coursePage/course_screen.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/listCourse/list_free_course.dart';
import 'package:heathy_teacher/screens/listSanPham/list_sp.dart';
import 'package:heathy_teacher/screens/authentication/login_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_dialog.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/utils/widget/feedback_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/screens/splash/sale_screen.dart';
import 'package:heathy_teacher/screens/splash/list_class_off_external.dart';
import 'package:heathy_teacher/screens/splash/list_class_online_external.dart';
import 'package:heathy_teacher/screens/search/search_result_screen.dart';

class CoGiaoHealthyScreen extends StatefulWidget {
  const CoGiaoHealthyScreen({
    super.key,
    required this.type,
    required this.place,
  });
  final String type;
  final String place;
  @override
  State<CoGiaoHealthyScreen> createState() => _CoGiaoHealthyScreenState();
}

class _CoGiaoHealthyScreenState extends State<CoGiaoHealthyScreen> {
  List<PostModel> dummyLongList = [];
  List<PostModel> dummyLongList2 = [];
  List<CourseModel> listCourseOnline = [];
  List<CourseOffModel> listCourseOffline = [];
  List<CourseScheduleModel> purchasedCourses = [];
  UserModel? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      dummyLongList = await HomeRepo().getPosts(
        slug: 'cong-thuc-nau-an',
        limit: 4,
      );
      dummyLongList2 = await HomeRepo().getPosts(
        slug: 'nhat-ky-lop-hoc',
        limit: 4,
      );
      final futureCourse = await ExternalRepo().getListCourse(
        show: 20,
        offerMonth: 1,
        type: 'online',
      );
      final futureCourseOff = await ExternalRepo().getListCourseOff(show: 6);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        try {
          purchasedCourses = await CourseRepo().getCourse(show: 100);
          userModel = await HomeRepo().getUserProfile();
        } catch (e) {
          debugPrint("Không thể tải khóa học đã mua: $e");
        }
      }

      listCourseOnline = futureCourse;
      listCourseOffline = futureCourseOff;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: mainDarkGreen,
                onRefresh: _fetchData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 50), // Khoảng cách cho status bar

                      DefaultAppBar(),

                      // 2. SEARCH BAR AREA
                      CustomSearchBar(
                        iconColor: mainDarkGreen,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SearchResultScreen(query: value.trim()),
                              ),
                            );
                          }
                        },
                      ),

                      const CustomImageCarousel(),
                      ServiceGrid(),
                      const _AchievementBanner(),
                      SizedBox(height: 12.h),
                      if (isShow == 'true')
                        SizedBox(
                          width: 343.w,
                          child: Center(
                            child: Text(
                              ' KHOÁ HỌC ONLINE NỔI BẬT -\n ƯU ĐÃI ĐẶC BIỆT TRONG THÁNG',
                              textAlign: TextAlign.center,
                              style: defaultText18B.copyWith(
                                color: mainDarkGreen,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      if (isShow == 'true')
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listCourseOnline.length,
                          itemBuilder: (context, index) {
                            final model = listCourseOnline[index];
                            final purchasedCourseIndex = purchasedCourses
                                .indexWhere(
                                  (c) => c.courseTypeId == model.courseTypeId,
                                );
                            return Center(
                              child: _OnlineClassCard(
                                index: index,
                                model: model,
                                purchasedCourse: purchasedCourseIndex != -1
                                    ? purchasedCourses[purchasedCourseIndex]
                                    : null,
                                userModel: userModel,
                              ),
                            );
                          },
                        ),
                      //SizedBox(height: 20.h),
                      // if (isShow == 'true')
                      //   GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: ((context) => ListClassOnline()),
                      //         ),
                      //       );
                      //     },
                      //     child: SizedBox(
                      //       width: 343.w,
                      //       child: Row(
                      //         children: [
                      //           SvgPicture.asset('assets/icons/class_online.svg'),
                      //           Text(
                      //             ' Gợi ý các khóa học online'.sanitizeForApple,
                      //             style: defaultText16B.copyWith(
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //           Spacer(),
                      //           Text(
                      //             'Xem tất cả  ',
                      //             style: defaultText14SB.copyWith(
                      //               color: mainDarkGreen,
                      //               fontSize: 12.sp,
                      //             ),
                      //           ),
                      //           Icon(
                      //             Icons.keyboard_arrow_right,
                      //             color: mainDarkGreen,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // if (isShow == 'true')
                      //   SizedBox(
                      //     width: 375.w,
                      //     height: (294 + 48).h,
                      //     child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       shrinkWrap: true,
                      //       physics: const ScrollPhysics(),
                      //       itemCount: listCourseOnline.length,
                      //       itemBuilder: (context, index) {
                      //         final model = listCourseOnline[index];
                      //         final purchasedCourseIndex = purchasedCourses.indexWhere((c) => c.courseTypeId == model.courseTypeId);
                      //         return _OnlineClassCard(
                      //           index: index,
                      //           model: model,
                      //           purchasedCourse: purchasedCourseIndex != -1 ? purchasedCourses[purchasedCourseIndex] : null,
                      //           userModel: userModel,
                      //         );
                      //       },
                      //     ),
                      //   ),
                      SizedBox(height: 10.h),
                      FeedbackSlider(),
                      Container(
                        height: 150.h,
                        width: 375.w,
                        margin: EdgeInsets.only(bottom: 20.h),
                        padding: EdgeInsets.only(left: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            colors: [mainDarkGreen, mainGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: mainDarkGreen, width: 1.w),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// TEXT (tự co lại)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '',
                                    style: defaultText14B.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'ƯU ĐÃI ĐẶC QUYỀN GIẢM ĐẾN 30%\nNGUYÊN LIỆU VÀ DỤNG CỤ CHO HỌC VIÊN',
                                    style: GoogleFonts.baloo2(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) =>
                                              const ListSpScreen()),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Text(
                                        'Nhận ưu đãi ngay',
                                        style: defaultText16B.copyWith(
                                          color: mainDarkGreen,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// IMAGE (giữ kích thước mong muốn)
                            SizedBox(
                              height: 150.h, // 👈 bạn control size ảnh ở đây
                              child: CachedNetworkImage(
                                memCacheWidth: 800,
                                imageUrl:
                                    'https://cogiaohealthy.vn/wp-content/uploads/2025/07/cogiao.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'KIẾN THỨC & CÔNG THỨC TẶNG EATCLEAN - HEALTHY',
                        textAlign: TextAlign.center,
                        style: defaultText20B.copyWith(color: mainDarkGreen),
                      ),
                      Text(
                        'Cập nhật liên tục công thức nấu ăn eatclean - healthy mới nhất',
                        textAlign: TextAlign.center,
                        style: defaultText14M.copyWith(color: mainDarkGreen),
                      ),
                      RecipeGridWidget(recipes: dummyLongList, type: 1),
                      SizedBox(height: 10.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4.0,
                            ),
                          ],

                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [backGroundGreen, mainDarkGreen],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Làm trong suốt nền và bóng của nút để hiển thị gradient của Container
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            // Điều chỉnh kích thước của nút
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                              vertical: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoreRecipesScreen(
                                  title:
                                      'KIẾN THỨC & CÔNG THỨC TẶNG EATCLEAN - HEALTHY',
                                  recipes: dummyLongList,
                                  type: 1,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Xem thêm',
                            style: defaultText18M.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'NHẬT KÝ LỚP HỌC',
                        textAlign: TextAlign.center,
                        style: defaultText20B.copyWith(color: mainDarkGreen),
                      ),
                      Text(
                        'Các lớp học nấu ăn healthy với những công thức bổ dưỡng, dễ làm và đầy màu sắc.',
                        textAlign: TextAlign.center,
                        style: defaultText14M.copyWith(color: mainDarkGreen),
                      ),
                      RecipeGridWidget(recipes: dummyLongList2, type: 2),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4.0,
                            ),
                          ],

                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [backGroundGreen, mainDarkGreen],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Làm trong suốt nền và bóng của nút để hiển thị gradient của Container
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            // Điều chỉnh kích thước của nút
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                              vertical: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoreRecipesScreen(
                                  title: 'NHẬT KÝ LỚP HỌC',
                                  recipes: dummyLongList2,
                                  type: 2,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Xem thêm',
                            style: defaultText18M.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      const CustomFooterInfo(),

                      // Khoảng cách cuối trang
                    ],
                  ),
                ),
              ),
            ),
            BottomCustom(),
          ],
        ),
      ),
    );
  }
}

Widget buildImage(String iconPath, {double size = 28}) {
  return Container(
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Image.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    ),
  );
}

class ServiceItem extends StatefulWidget {
  final ServiceModel item;
  final bool isHighlight;

  const ServiceItem({super.key, required this.item, this.isHighlight = false});

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.item.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(
          0,
          isPressed ? 4 : 0, // 👈 hiệu ứng nhấn xuống
          0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Center(
              child: Image.asset(widget.item.icon, width: 80.dm, height: 80.dm),
            ),
            const SizedBox(height: 12),

            /// title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: defaultText14B.copyWith(color: mainDarkGreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceModel> services = [
      ServiceModel(
        title: "KHÓA HỌC TRỰC TIẾP".sanitizeForApple,
        icon: "assets/images/home1.png",
        onTap: () {
          showCitySelectionDialog(
            context: context,
            onCitySelected: (selectedCity) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ListClassOffExternal(place: selectedCity),
                ),
              );
            },
          );
        },
      ),
      if (isShow == 'true')
        ServiceModel(
          title: "KHÓA HỌC ONLINE".sanitizeForApple,
          icon: "assets/images/home2.png",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ListClassOnlineExternal(),
              ),
            );
          },
        ),
      ServiceModel(
        title: "HỌC THỬ MIỄN PHÍ",
        icon: "assets/images/home3.png",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListFreeCourse()),
          );
        },
      ),
      ServiceModel(
        title: "GIAN HÀNG NGUYÊN LIỆU",
        icon: "assets/images/home4.png",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => const ListSpScreen())),
          );
        },
      ),

      // ServiceModel(
      //   title: "HỖ TRỢ KỸ THUẬT SAU HỌC",
      //   icon: "assets/images/home5.png",
      //   onTap: () async {
      //     if (!await launchUrl(Uri.parse('https://m.me/cogiaohealthy'))) {
      //       throw Exception('Could not launch ');
      //     }
      //   },
      // ),
      ServiceModel(
        title: "ƯU ĐÃI VÀ KHUYẾN MÃI",
        icon: "assets/images/home6.png",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SaleScreen()),
          );
        },
      ),
    ];

    return Column(
      children: [
        Text(
          "DỊCH VỤ CỦA CHÚNG TÔI",
          style: defaultText20B.copyWith(color: mainDarkGreen),
        ),
        const SizedBox(height: 6),
        Text(
          "Các dịch vụ nổi bật tại Cô giáo healthy",
          style: defaultText14M.copyWith(color: mainDarkGreen),
        ),
        SizedBox(height: 8.h),
        //const StatisticsBannerWidget(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ), // Thêm padding 2 bên nếu cần thiết
          child: LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 16.0;
              // Tính toán chiều rộng mỗi item (2 item 1 hàng)
              final itemWidth = (constraints.maxWidth - spacing) / 2;

              return Wrap(
                alignment:
                    WrapAlignment.center, // Sẽ canh giữa các item ở dòng cuối
                spacing: spacing, // khoảng cách ngang
                runSpacing: 16.0, // khoảng cách dọc
                children: List.generate(services.length, (index) {
                  return SizedBox(
                    width: itemWidth,
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: ServiceItem(
                        item: services[index],
                        isHighlight: index == 0,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Định nghĩa màu sắc xanh lá cây
const Color appPrimaryColor = Color(
  0xFF4CAF50,
); // Xanh lá cây đậm của icon và text
const Color appRippleColor = Color(0xFFA1D0A3); // Xanh lá cây nhạt cho ripple

class BottomCustom extends StatelessWidget {
  const BottomCustom({super.key});

  // Hàm trợ giúp để launch URL
  Future<void> _launchUrl(
    BuildContext context,
    String url, {
    bool isPhone = false,
  }) async {
    final Uri uri = isPhone ? Uri(scheme: 'tel', path: url) : Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Có thể hiển thị SnackBar nếu cần
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể mở $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tinh chỉnh khoảng trắng và bo tròn
    final double horizontalPadding = 16.w;
    final double verticalPadding =
        2.h; // Giảm đáng kể khoảng trắng dọc để thanh mỏng
    final double barBorderRadius = 20.r; // Bo tròn nhẹ nhàng hơn

    // Danh sách dữ liệu cấu hình các nút
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Messenger',
        'iconPath': 'assets/icons/fb_messsage.svg',
        'url': 'https://m.me/cogiaohealthy',
        'type': 'url',
      },
      {
        'title': 'Zalo',
        'iconPath': 'assets/icons/icon_zalo.svg',
        'url': 'https://zalo.me/0966912016',
        'type': 'url',
      },
      {
        'title': 'Trang chủ',
        'iconPath': 'assets/icons/icon_home.svg',
        'type': 'external_home',
      },
      {
        'title': 'Gọi hotline',
        'iconPath': 'assets/images/call.png',
        'url': '0966912016',
        'type': 'phone',
      },
    ];

    return Container(
      // Padding dọc rất thấp để giảm khoảng trắng
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(barBorderRadius),
          topRight: Radius.circular(barBorderRadius),
        ),
        // Thêm một shadow cực nhẹ
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return GestureDetector(
            onTap: () async {
              if (item['type'] == 'url') {
                await _launchUrl(context, item['url']);
              } else if (item['type'] == 'phone') {
                await _launchUrl(context, item['url'], isPhone: true);
              } else if (item['type'] == 'external_home') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoGiaoHealthyScreen(
                      type: 'home',
                      place: 'Hà Nội',
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
              } else if (item['type'] == 'login') {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');
                if (token != null && token.isNotEmpty) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const BottomBarScreen()),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const LoginScreen()),
                    ),
                  );
                }
              }
            },
            child: _BottomNavItem(
              title: item['title'],
              iconPath: item['iconPath'],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Widget con cho mỗi mục
class _BottomNavItem extends StatelessWidget {
  final String title;
  final String iconPath;

  const _BottomNavItem({required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    // Điều chỉnh kích thước của icon và ripple
    final double totalRippleSize = 50.r; // Kích thước của vòng ngoài cùng
    final double centralIconSize = 24.r; // Kích thước của icon chính
    final double textFontSize = 11.sp; // Chữ hơi lớn hơn để dễ đọc

    return Column(
      mainAxisSize: MainAxisSize.min, // Giảm chiều cao tối thiểu của Column
      children: [
        // Hiệu ứng icon với ripple concentric
        _ConcentricRippleIcon(
          iconPath: iconPath,
          centralSize: centralIconSize,
          totalSize: totalRippleSize,
        ),
        SizedBox(height: 1.h), // Khoảng cách cực nhỏ giữa icon và text
        Text(
          title,
          style: TextStyle(
            color: appPrimaryColor,
            fontSize: textFontSize,
            fontWeight: FontWeight.w400, // Regular weight, giống ảnh mẫu
          ),
        ),
      ],
    );
  }
}

// Widget con chuyên biệt cho hiệu ứng concentric ripple
class _ConcentricRippleIcon extends StatefulWidget {
  final String iconPath;
  final double centralSize;
  final double totalSize;

  const _ConcentricRippleIcon({
    required this.iconPath,
    required this.centralSize,
    required this.totalSize,
  });

  @override
  State<_ConcentricRippleIcon> createState() => _ConcentricRippleIconState();
}

class _ConcentricRippleIconState extends State<_ConcentricRippleIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Tạo AnimationController với thời gian chạy dài hơn để sóng chậm và mềm mại
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(); // Lặp lại liên tục
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.totalSize,
      height: widget.totalSize,
      child: Stack(
        clipBehavior: Clip.none, // Cho phép sóng tràn ra ngoài
        alignment: Alignment.center,
        children: [
          // AnimatedBuilder để vẽ các vòng sóng
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: List.generate(3, (index) {
                  // Tạo 3 vòng sóng lệch pha nhau
                  double phase = (_controller.value - index * 0.333) % 1.0;
                  if (phase < 0) phase += 1.0;

                  // Dùng curve để sóng mở rộng tự nhiên hơn
                  double curvedPhase = Curves.easeOutQuad.transform(phase);

                  // Kích thước sóng mở rộng từ centralSize đến lớn hơn totalSize để tràn hẳn ra ngoài bottombar
                  double maxSize = widget.totalSize * 2.8;
                  double currentSize =
                      widget.centralSize +
                      (maxSize - widget.centralSize) * curvedPhase;

                  // Độ mờ giảm dần (fade out)
                  double opacity = 0.5 * (1.0 - phase);

                  return Container(
                    width: currentSize,
                    height: currentSize,
                    decoration: BoxDecoration(
                      color: appRippleColor.withOpacity(opacity),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              );
            },
          ),

          // Icon chính ở trung tâm
          Container(
            width: widget.centralSize,
            height: widget.centralSize,
            decoration: const BoxDecoration(
              color: appPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _buildIconWidget(
                widget.iconPath,
                widget.centralSize * 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm trợ giúp để tạo Widget icon từ đường dẫn
  Widget _buildIconWidget(String path, double size) {
    if (path.endsWith('.svg')) {
      // Giả định SvgPicture được import (package:flutter_svg/svg.dart)
      return SvgPicture.asset(path, width: size, height: size);
    } else {
      // Dùng Image.asset cho png
      return Image.asset(path, width: size, height: size);
    }
  }
}

class MoreRecipesScreen extends StatefulWidget {
  final String title;
  final List<PostModel> recipes;
  final int type;

  const MoreRecipesScreen({
    super.key,
    required this.title,
    required this.recipes,
    required this.type,
  });

  @override
  State<MoreRecipesScreen> createState() => _MoreRecipesScreenState();
}

class _MoreRecipesScreenState extends State<MoreRecipesScreen> {
  late List<PostModel> _recipes;
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentLimit = 4;

  @override
  void initState() {
    super.initState();
    _recipes = List.from(widget.recipes);
    _currentLimit = widget.recipes.isNotEmpty ? widget.recipes.length : 4;
    _scrollController = ScrollController()..addListener(_onScroll);

    // Tự động tải thêm ngay khi vừa vào màn hình "Xem thêm"
    // vì 4 item ban đầu không đủ để lấp đầy màn hình và tạo thanh cuộn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return; // Tránh gọi nhiều lần cùng lúc

    setState(() {
      _isLoading = true;
    });

    _currentLimit += 10; // Tăng limit lên 10 item mỗi lần load

    // Xác định slug dựa vào type
    String slug = widget.type == 1 ? 'cong-thuc-nau-an' : 'nhat-ky-lop-hoc';

    try {
      final newRecipes = await HomeRepo().getPosts(
        slug: slug,
        limit: _currentLimit,
      );

      if (mounted) {
        setState(() {
          // Nếu danh sách trả về không dài hơn danh sách cũ, nghĩa là đã hết dữ liệu
          if (newRecipes.length <= _recipes.length) {
            _hasMore = false;
          } else {
            _recipes = newRecipes;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  DefaultAppBar(),
                  SizedBox(height: 16.h),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: defaultText20B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 16.h),
                  RecipeGridWidget(recipes: _recipes, type: widget.type),
                  if (_isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CircularProgressIndicator(color: mainDarkGreen),
                    ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          BottomCustom(),
        ],
      ),
    );
  }
}

class _OfflineClassCard extends StatelessWidget {
  final CourseOffModel model;
  const _OfflineClassCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => RegisterClassOff(id: model.id ?? '')),
          ),
        );
      },
      child: Container(
        height: 260.h,
        width: 200.w,
        margin: EdgeInsets.only(
          left: 16.w,
          right: 8.w,
          top: 16.h,
          bottom: 14.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff062905).withValues(alpha: 0.16),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              memCacheWidth: 800,
              imageUrl: model.img ?? '',
              width: 184.w,
              fit: BoxFit.fitWidth,
              errorWidget: (context, url, error) {
                return Icon(Icons.broken_image, color: Colors.grey);
              },
              placeholder: (context, url) {
                return Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
            Text(
              model.name ?? 'Không xác định',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: defaultText14SB,
            ),
            if (isShow == 'true')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '') ?? 0)}đ',
                    style: defaultText16B,
                  ),
                  if (model.priceOld != null &&
                      model.priceOld != '0' &&
                      model.priceOld != '')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '') ?? 0)}đ',
                      style: defaultText12Re.copyWith(
                        fontSize: 10.sp,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            Container(
              height: 32.h,
              width: 184.w,
              decoration: BoxDecoration(
                color: mainDarkGreen,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tham gia ngay ',
                    style: defaultText14SB.copyWith(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnlineClassCard extends StatelessWidget {
  final int index;
  final CourseModel model;
  final CourseScheduleModel? purchasedCourse;
  final UserModel? userModel;
  const _OnlineClassCard({
    required this.index,
    required this.model,
    this.purchasedCourse,
    this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                RegisterClassON(id: model.courseTypeId ?? '', model: model)),
          ),
        );
      },
      child: Container(
        width: 343.w,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: AspectRatio(
                    aspectRatio: 483 / 397.76,
                    child: CachedNetworkImage(
                      memCacheWidth: 800,
                      imageUrl:
                          model.img ??
                          'https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: mainDarkGreen),
                    ),
                    child: Text(
                      model.topicName ?? 'Bánh kẹo healthy',
                      style: defaultText12Re.copyWith(
                        color: mainDarkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              model.courseName ?? 'Không xác định',
              maxLines: 2,
              style: defaultText16B.copyWith(color: mainDarkGreen, height: 1.4),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: mainDarkGreen,
                  size: 20.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Học Online qua App',
                  style: defaultText14M.copyWith(color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${model.lessonNumber ?? 0} bài học',
                        style: defaultText12Re.copyWith(color: mainDarkGreen),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '${int.parse(model.totalEnrollments ?? '0') + int.parse(model.startCount ?? '0')} lượt học',
                        style: defaultText12Re.copyWith(color: mainDarkGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (isShow == 'true')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '') ?? 0)}đ',
                        style: defaultText18B.copyWith(
                          color: mainDarkGreen,
                          fontSize: 20.sp,
                        ),
                      ),
                      if (model.priceOld != null &&
                          model.priceOld != '0' &&
                          model.priceOld != '')
                        Text(
                          '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '') ?? 0)}đ',
                          style: defaultText14M.copyWith(
                            fontSize: 10.sp,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (purchasedCourse != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => CourseScreen(
                              userModel: userModel ?? UserModel(),
                            )),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => RegisterClassON(
                              id: model.courseTypeId ?? '',
                              model: model,
                            )),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: mainDarkGreen,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        purchasedCourse != null ? 'Học ngay' : 'Đăng ký ngay',
                        style: defaultText14SB.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AchievementBanner extends StatefulWidget {
  const _AchievementBanner({super.key});

  @override
  State<_AchievementBanner> createState() => _AchievementBannerState();
}

class _AchievementBannerState extends State<_AchievementBanner> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('achievement-banner'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 20 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        } else if (visiblePercentage == 0 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      },
      child: Container(
        color: mainGreen,
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),

        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Chia làm 4 cột trên 1 hàng (như cũ)
            // Nếu có 5 item thì item thứ 5 sẽ xuống dòng và WrapAlignment.center sẽ đưa nó ra giữa
            final itemWidth = constraints.maxWidth / 4;

            return Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 10.h,
              children: [
                _buildItem(
                  width: itemWidth,
                  icon: 'assets/images/exp.png',
                  targetNumber: 10,
                  suffix: '+',
                  text: 'Năm kinh nghiệm đào tạo và setup F&B\nViệt Nam',
                ),
                _buildItem(
                  width: itemWidth,
                  icon: 'assets/images/course.png',
                  targetNumber: 60,
                  suffix: '+',
                  text:
                      'Khoá học nấu ăn dinh dưỡng, làm bánh và đồ uống\nhealthy',
                ),
                _buildItem(
                  width: itemWidth,
                  icon: 'assets/images/like.png',
                  number: 'No.1',
                  text:
                      'Trung tâm đầu tiên giảng dạy dinh dưỡng & thực\nphẩm healthy',
                ),
                _buildItem(
                  width: itemWidth,
                  icon: 'assets/images/exp.png',
                  targetNumber: 10000,
                  suffix: '+',
                  text:
                      'Học viên ứng dụng & kinh doanh thành công trên toàn quốc',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem({
    required double width,
    required String icon,
    String? number,
    int? targetNumber,
    String suffix = '',
    required String text,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          children: [
            Image.asset(icon, height: 24.h, width: 24.w),
            SizedBox(height: 4.h),
            if (targetNumber != null)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 1,
                  end: _isVisible ? targetNumber.toDouble() : 1,
                ),
                duration: _isVisible
                    ? const Duration(seconds: 3)
                    : const Duration(milliseconds: 0),
                builder: (context, value, child) {
                  String formatted = NumberFormat(
                    '#,###',
                    'vi_VN',
                  ).format(value.toInt());
                  return Text(
                    '$formatted$suffix',
                    style: defaultText16B.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                },
              )
            else
              Text(
                number ?? '',
                style: defaultText16B.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 2.h),
            Text(
              text,
              style: defaultText12B.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
