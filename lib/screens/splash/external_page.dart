import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/screens/introduce_screen.dart';
import 'package:heathy_teacher/screens/listCourse/list_free_course.dart';
import 'package:heathy_teacher/screens/listSanPham/list_sp.dart';
import 'package:heathy_teacher/screens/login_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_dialog.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/utils/widget/feedback_slider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final List<Map<String, dynamic>> _productImages = [
    {'image': 'assets/images/home1.jpg', 'screen': const ListSpScreen()},
    {'image': 'assets/images/home2.jpg', 'screen': const IntroduceScreen()},
    {'image': 'assets/images/home3.jpg', 'screen': const ListFreeCourse()},
    {'image': 'assets/images/home4.jpg', 'screen': const ListSpScreen()},
  ];
  final List<RecipeModel> dummyLongList = List.generate(4, (index) {
    // Luân phiên thay đổi nội dung để giao diện nhìn thực tế
    if (index % 4 == 0) {
      return RecipeModel(
        title: "Bánh bao kẹp Đài Loan nguyên cám",
        imageUrl: "assets/images/gift_formula.jpg",
        date: "14/01/2026",
      );
    } else if (index % 4 == 1) {
      return RecipeModel(
        title: "Công thức Ginger Shot cho 7 ngày",
        imageUrl: "assets/images/gift_formula2.jpg",
        date: "14/01/2026",
      );
    } else if (index % 4 == 2) {
      return RecipeModel(
        title: "Ức gà bọc trứng",
        imageUrl: "assets/images/gift_formula3.jpg",
        date: "14/01/2026",
      );
    } else {
      return RecipeModel(
        title: "Tặng công thức cá hấp xì dầu cho bữa cơm nhà trở nên hấp dẫn",
        imageUrl: "assets/images/gift_formula4.png",
        date: "13/11/2025",
      );
    }
  });

  final List<RecipeModel> dummyLongList2 = List.generate(4, (index) {
    // Luân phiên thay đổi nội dung để giao diện nhìn thực tế
    if (index % 4 == 0) {
      return RecipeModel(
        title:
            "Ngày 1 – Lớp học TRỰC TIẾP kinh doanh suất ăn healthy cao cấp có gì?",
        imageUrl: "assets/images/dairy1.jpg",
        date: "14/01/2026",
        detail:
            "Cùng khám phá lịch trình ngày 1 tại lớp trực tiếp của Cô Giáo Healthy nha",
      );
    } else if (index % 4 == 1) {
      return RecipeModel(
        title:
            "Ngày 2 – Tiếp tục khám phá lớp học kinh doanh suất ăn healthy cao cấp có gì nha?",
        imageUrl: "assets/images/dairy2.jpg",
        date: "14/01/2026",
        detail:
            "Tiếp tục khám phá ngày 2 của lớp học kinh doanh suất ăn healthy cao cấp của Cô Giáo Healthy ",
      );
    } else if (index % 4 == 2) {
      return RecipeModel(
        title:
            "Ngày 3 – Mô hình kinh doanh toàn diện, smoothie – nước ép kết hợp cùng suất ăn healthy cao cấp",
        imageUrl: "assets/images/dairy3.jpg",
        date: "14/01/2026",
        detail:
            "Từ một người yêu bếp trở thành người vận hành mô hình suất ăn lành mạnh – bắt đầu từ việc học bài bản và thực hành đúng cách. ",
      );
    } else {
      return RecipeModel(
        title:
            "Nhật ký lớp học trà sữa hạt chuyên sâu trực tiếp: Trà sữa hạt thuần chay tại Cô Giáo Healthy có gì khác biệt so với trà sữa thông thường?",
        imageUrl: "assets/images/dairy4.jpg",
        date: "13/11/2025",
        detail:
            "Nhật ký lớp học trà sữa hạt chuyên sâu trực tiếp: Trà sữa hạt thuần chay tại Cô Giáo Healthy có gì khác biệt so với trà sữa thông thường?",
      );
    }
  });

  int _currentSlide = 0;
  final PageController _pageController = PageController(initialPage: 0);

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel(); // 🔥 Hủy timer khi không dùng nữa để tránh leak memory
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentSlide < _productImages.length - 1) {
          _currentSlide++;

          // Lướt sang trang kế tiếp
          _pageController.animateToPage(
            _currentSlide,
            duration: const Duration(
              milliseconds: 500,
            ), // Tăng nhẹ thời gian lướt cho mượt
            curve: Curves.easeInOut,
          );
        } else {
          _currentSlide = 0; // Đặt về 0

          // 🔥 Lướt mượt ngược từ cuối về đầu
          _pageController.animateToPage(
            _currentSlide,
            duration: const Duration(
              milliseconds: 800,
            ), // Thời gian cuộn ngược dài hơn chút nhìn sẽ đẹp hơn
            curve: Curves.easeInOut,
          );
        }
      }
    });
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
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập để tìm kiếm...',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: mainDarkGreen),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 470.w,
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
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          _productImages[index]['screen']
                                              as Widget),
                                    ),
                                  );
                                  // Xử lý khi người dùng nhấn vào ảnh (nếu cần)
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.asset(
                                    _productImages[index]['image'] as String,
                                    width: double.infinity,
                                    fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
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
                  ServiceGrid(),
                  //list
                  CourseItem(type: widget.type, place: widget.place),
                  CourseItem(type: widget.type, place: widget.place),
                  SizedBox(height: 20.h),
                  Text(
                    'KHOÁ HỌC ONLINE NỔI BẬT - ƯU ĐÃI ĐẶC BIỆT TRONG THÁNG',
                    textAlign: TextAlign.center,
                    style: defaultText20B.copyWith(color: mainDarkGreen),
                  ),
                  CourseItemOnline(type: 'on', place: widget.place),
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
                          child: Image.network(
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
                        Image.network(
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
                          'Khóa học',
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
                                'Nhận thông tin mới nhất về khoá học, kiến thức nấu ăn!',
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
              child: Text(
                widget.item.title,
                textAlign: TextAlign.center,
                style: defaultText16B.copyWith(color: mainDarkGreen),
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
        title: "KHÓA HỌC TRỰC TIẾP",
        icon: "assets/images/home1.png",
        onTap: () {
          showCitySelectionDialog(
            context: context,
            onCitySelected: (selectedCity) {
              // 🔥 Cả 2 thành phố đều vào chung 1 màn hình (Ví dụ: CoursesScreen)
              // Truyền tên thành phố vừa chọn vào màn hình đó
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CoGiaoHealthyScreen(type: 'off', place: selectedCity),
                ),
              );
            },
          );
        },
      ),
      ServiceModel(
        title: "KHÓA HỌC ONLINE",
        icon: "assets/images/home2.png",
        onTap: () {
          showOnlineCategoriesDialog(
            context: context,
            onCategorySelected: (selectedCategory) {
              // 🔥 Cả 2 loại khóa học đều
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CoGiaoHealthyScreen(type: 'on', place: ''),
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
      ServiceModel(
        title: "HỖ TRỢ KỸ THUẬT SAU HỌC",
        icon: "assets/images/home5.png",
        onTap: () async {
          if (!await launchUrl(Uri.parse('https://m.me/cogiaohealthy'))) {
            throw Exception('Could not launch ');
          }
        },
      ),
      ServiceModel(
        title: "ƯU ĐÃI VÀ KHUYẾN MÃI",
        icon: "assets/images/home6.png",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CoGiaoHealthyScreen(type: 'sale', place: ''),
            ),
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

class BottomCustom extends StatelessWidget {
  const BottomCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse('https://m.me/cogiaohealthy'))) {
                throw Exception('Could not launch ');
              }
            },
            child: ServiceIconButton(
              title: 'Messenger',
              iconPath: 'assets/icons/fb_messsage.svg',
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse('https://zalo.me/0966912016'))) {
                throw Exception('Could not launch ');
              }
            },
            child: ServiceIconButton(
              title: 'Zalo',
              iconPath: 'assets/icons/icon_zalo.svg',
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri(scheme: 'tel', path: '0966912016'))) {
                throw Exception('Could not launch ');
              }
            },
            child: ServiceIconButton(
              title: 'Gọi hotline',
              iconPath: 'assets/images/call.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const LoginScreen())),
              );
            },
            child: ServiceIconButton(
              title: 'Hỗ trợ ngay',
              iconPath: 'assets/images/suport.png',
            ),
          ),
        ],
      ),
    );
  }
}
