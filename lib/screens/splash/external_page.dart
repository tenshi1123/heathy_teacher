import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
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
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/homePage/list_class_off.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/screens/splash/sale_screen.dart';
import 'package:heathy_teacher/screens/splash/list_class_off_external.dart';
import 'package:heathy_teacher/screens/splash/list_class_online_external.dart';

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50), // Khoảng cách cho status bar

                    DefaultAppBar(),

                    // 2. SEARCH BAR AREA
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFC0CA33),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Nhập để tìm kiếm...',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.search,
                              color: mainDarkGreen,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const CustomImageCarousel(),
                    ServiceGrid(),
                    const _AchievementBanner(),
                    if (isShow == 'true')
                      SizedBox(
                        width: 343.w,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => ListClassOff()),
                              ),
                            );
                          },
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
                      ),
                    if (isShow == 'true')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listCourseOnline.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: _OnlineClassCard(
                              index: index,
                              model: listCourseOnline[index],
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
                    //         return _OnlineClassCard(
                    //           index: index,
                    //           model: listCourseOnline[index],
                    //         );
                    //       },
                    //     ),
                    //   ),
                    SizedBox(height: 10.h),
                    FeedbackSlider(),
                    Container(
                      height: 160.h,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'ƯU ĐÃI ĐẶC QUYỀN GIẢM ĐẾN 30%',
                                  style: defaultText14B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'NGUYÊN LIỆU VÀ DỤNG CỤ CHO HỌC VIÊN',
                                  style: defaultText14B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    'Nhận ưu đãi ngay',
                                    style: defaultText16B.copyWith(
                                      color: mainDarkGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// IMAGE (giữ kích thước mong muốn)
                          SizedBox(
                            height: 140.h, // 👈 bạn control size ảnh ở đây
                            child: CachedNetworkImage(
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
                    Container(
                      width: 375.w,

                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        color: mainDarkGreen,
                        border: Border.all(color: mainDarkGreen, width: 1.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://cogiaohealthy.vn/wp-content/uploads/2025/07/logo_footer.png',
                            height: 60.h,
                            fit: BoxFit.contain,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: defaultText14M.copyWith(
                                      color: Colors.white,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Hà Nội:',
                                        style: defaultText14B.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' 214 Lạc Long Quân, quận Tây Hồ, Hà Nội',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: defaultText14M.copyWith(
                                      color: Colors.white,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'HCM:',
                                        style: defaultText14B.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' SkyVilla P2406, Celadon City, số 02 Tân Thanh, phường Tân Sơn Nhì, thành phố Hồ Chí Minh',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: defaultText14M.copyWith(
                                      color: Colors.white,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Hotline:',
                                        style: defaultText14B.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(text: '\n(+84)96 691 2016'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'CÔNG TY TNHH CÔ GIÁO HEALTHY',
                            style: defaultText16B.copyWith(color: Colors.white),
                          ),
                          Text(
                            'MST: 0109187074 \nĐăng ký lần đầu ngày 19 háng 05 năm 2020 \nĐăng ký thay đổi lần thứ 4, ngày 20 tháng 06 năm 2024 \nNơi cấp: Sở kế hoạch và đầu tư thành phố Hà Nội - Phòng đăng ký kinh doanh \nĐịa chỉ trụ sở chính: Tầng 7, Tòa nhà Luxury Ofice, số 214 Lạc Long Quân, Phường Tây Hồ, Thành phố Hà Nội, Việt Nam',
                            style: defaultText14M.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Thông tin',
                            style: defaultText16B.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Giới thiệu chung',
                            style: defaultText14M.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Khóa học'.sanitizeForApple,
                            style: defaultText14M.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Sản phẩm',
                            style: defaultText14M.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Chính sách bảo mật - học tập',
                            style: defaultText14M.copyWith(color: Colors.white),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: mainGreen,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(height: 8.h),
                                Text(
                                  'Theo dõi Cô Giáo Healthy',
                                  style: defaultText16B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Nhận thông tin mới nhất về khoá học, kiến thức nấu ăn!'
                                      .sanitizeForApple,
                                  style: defaultText14M.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildImage(
                                      'assets/images/facebook.png',
                                      size: 25,
                                    ),
                                    buildImage(
                                      'assets/images/youtube.png',
                                      size: 25,
                                    ),
                                    buildImage(
                                      'assets/images/tiktok.png',
                                      size: 25,
                                    ),
                                    buildImage(
                                      'assets/images/zalo.png',
                                      size: 25,
                                    ),
                                    buildImage(
                                      'assets/images/ins.png',
                                      size: 20,
                                    ),
                                    buildImage(
                                      'assets/images/threads.png',
                                      size: 25,
                                    ),

                                    buildImage(
                                      'assets/images/lemon8.png',
                                      size: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '© 2025 Cô Giáo Healthy | All Rights Reserved.',
                            style: defaultText14M.copyWith(color: Colors.white),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),

                    // Khoảng cách cuối trang
                  ],
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
            showOnlineCategoriesDialog(
              context: context,
              onCategorySelected: (category) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListClassOnlineExternal(category: category),
                  ),
                );
              },
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
        //const StatisticsBannerWidget(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return ServiceItem(item: services[index], isHighlight: index == 0);
          },
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
        'title': 'Gọi hotline',
        'iconPath': 'assets/images/call.png',
        'url': '0966912016',
        'type': 'phone',
      },
      {
        'title': 'Hỗ trợ ngay',
        'iconPath': 'assets/images/suport.png',
        'type': 'login',
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
              } else if (item['type'] == 'login') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LoginScreen()),
                  ),
                );
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
    super.key,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '') ?? 0)}đ',
                    style: defaultText16B,
                  ),
                  if (model.priceOld != '0')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '') ?? 0)}đ',
                      style: defaultText12Re.copyWith(
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
  const _OnlineClassCard({required this.index, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                RegisterClassON(id: model.courseTypeId ?? '')),
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
                      if (model.priceOld != null && model.priceOld != '0')
                        Text(
                          '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '') ?? 0)}đ',
                          style: defaultText14M.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '') ?? 0)}đ',
                        style: defaultText18B.copyWith(
                          color: mainDarkGreen,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: mainDarkGreen,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Đăng ký ngay',
                      style: defaultText14SB.copyWith(color: Colors.white),
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

class _AchievementBanner extends StatelessWidget {
  const _AchievementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainGreen,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItem(
            icon: 'assets/images/exp.png',
            number: '10+',
            text: 'Năm kinh nghiệm đào tạo và setup F&B\nViệt Nam',
          ),
          _buildItem(
            icon: 'assets/images/course.png',
            number: '60+',
            text: 'Khoá học nấu ăn dinh dưỡng, làm bánh và đồ uống\nhealthy',
          ),
          _buildItem(
            icon: 'assets/images/like.png',
            number: 'No.1',
            text:
                'Trung tâm đầu tiên giảng dạy dinh dưỡng & thực\nphẩm healthy',
          ),
          _buildItem(
            icon: 'assets/images/exp.png',
            number: '10.000+',
            text: 'Học viên ứng dụng & kinh doanh thành công trên toàn quốc',
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String icon,
    required String number,
    required String text,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            Image.asset(icon, height: 30.h, width: 30.w),
            SizedBox(height: 8.h),
            Text(
              number,
              style: defaultText20B.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              text,
              style: defaultText14B.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
