import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_dialog.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:intl/intl.dart';

class ListFreeCourse extends StatefulWidget {
  const ListFreeCourse({super.key});

  @override
  State<ListFreeCourse> createState() => _ListFreeCourseState();
}

class _ListFreeCourseState extends State<ListFreeCourse> {
  // Màu xanh lá logo
  static const Color secondaryGreen = Color(
    0xFF7CB342,
  ); // Màu xanh nút đăng nhập
  final List<String> _productImages = [
    'assets/images/home1.jpg',
    'assets/images/home2.jpg',
    'assets/images/home3.jpg',
    'assets/images/home4.jpg',
  ];
  int _currentSlide = 0;
  final PageController _pageController =
      PageController(); // Điều khiển PageView

  late int currentPage = 1;
  int itemsPerPage = 6;
  bool isLoading = false;
  List<CourseModel> localListCourse = [];

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    int startIndex = (page - 1) * itemsPerPage;
    if (startIndex >= localListCourse.length) {
      setState(() {
        isLoading = true;
      });
      try {
        final newItems = await ExternalRepo().getListFreeCourse(
          page: page,
          show: itemsPerPage,
        );
        setState(() {
          localListCourse.addAll(newItems);
        });
      } catch (e) {
        // print('Lỗi: $e');
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  List<CourseModel> get currentItems {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (startIndex >= localListCourse.length) return [];
    if (endIndex > localListCourse.length) endIndex = localListCourse.length;
    return localListCourse.sublist(startIndex, endIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập để tìm kiếm...',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: secondaryGreen),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. SLIDE SHOW AREA (Phần bạn yêu cầu)
                  Container(
                    width: double.infinity,
                    height: 375.w * 4 / 3,
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: _productImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentSlide = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: ((context) =>
                                //         const ListSpScreen()),
                                //   ),
                                // );
                                // Xử lý khi người dùng nhấn vào ảnh (nếu cần)
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.asset(
                                  _productImages[index],
                                  width: double.infinity,
                                  fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                                ),
                              ),
                            );
                          },
                        ),

                        /// DOT INDICATOR
                        Positioned(
                          bottom: 10.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _productImages.length,
                              (index) => Container(
                                width: 8.w,
                                height: 8.w,
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentSlide == index
                                      ? mainDarkGreen
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //list
                  if (currentItems.isEmpty && !isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Không có khóa học nào.', style: defaultText16B),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FreeCourseItem(model: currentItems[index]);
                      },
                    ),

                  if (currentItems.isNotEmpty)
                    Container(
                      height: 76.h,
                      width: 375.w,
                      padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: PaginationWidget(
                        currentPage: currentPage,
                        totalPages: 6,
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                          _loadPage(page);
                        },
                      ),
                    ),

                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: mainDarkGreen),
                    ),
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
  imageUrl: 'https://cogiaohealthy.vn/wp-content/uploads/2025/07/cogiao.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
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
  imageUrl: 'https://cogiaohealthy.vn/wp-content/uploads/2025/07/logo_footer.png',
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
                                'Nhận thông tin mới nhất về khoá học, kiến thức nấu ăn!'.sanitizeForApple,
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
                                  buildImage('assets/images/ins.png', size: 20),
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
    );
  }
}

Widget buildIcon(String iconPath, {double size = 28}) {
  if (iconPath.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(iconPath, width: size, height: size);
  } else {
    return Image.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
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

class PulseIcon extends StatefulWidget {
  final String iconPath;

  const PulseIcon({super.key, required this.iconPath});

  @override
  State<PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<PulseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = _controller.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              /// vòng lan 1
              _buildWave(value),

              /// vòng lan 2 (trễ hơn chút cho đẹp)
              _buildWave((value + 0.5) % 1),

              /// nút chính
              child!,
            ],
          );
        },
        child: Transform.translate(
          offset: Offset(
            (sin(_controller.value * 2 * pi) * 2), // rung ngang nhẹ
            0,
          ),
          child: _buildMainButton(),
        ),
      ),
    );
  }

  Widget _buildWave(double value) {
    return Container(
      width: 50 + (value * 40), // 👈 nở ra
      height: 50 + (value * 40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mainDarkGreen.withOpacity(1 - value), // 👈 mờ dần
      ),
    );
  }

  Widget _buildMainButton() {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(color: mainDarkGreen, shape: BoxShape.circle),
      child: Center(child: buildIcon(widget.iconPath, size: 18)),
    );
  }
}

class FreeCourseItem extends StatelessWidget {
  final CourseModel model;
  const FreeCourseItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: model.img ?? 'https://lms.cogiaohealthy.vn/images/AVAMOI/B%E1%BA%A3n%20sao%20c%E1%BB%A7a%20%E1%BA%A2nh%20%C4%91%E1%BA%A1i%20di%E1%BB%87n%20kho%C3%A1%20h%E1%BB%8Dc%20tr%C3%AAn%20website%20%285%29.jpg',
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: mainDarkGreen, width: 1.5),
                  color: Colors.white,
                ),
                child: Text(
                  'Học thử miễn phí',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            (model.courseName ?? 'Không xác định').sanitizeForApple,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: defaultText18B.copyWith(color: mainDarkGreen),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: mainDarkGreen,
                size: 16,
              ),
              Text(
                '  Cô giáo Healthy',
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    Text(
                      '  ${model.lessonNumber} bài học',
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.yellow, size: 16),
                    Text(
                      '  ${model.totalEnrollments} lượt học',
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: InkWell(
              onTap: () {
                showLoginDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 8.h),

                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: mainDarkGreen,
                ),
                child: Text(
                  'Học thử ngay',
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
