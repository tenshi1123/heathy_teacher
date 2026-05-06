import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottomBarScreen.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/listSanPham/list_sp.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class CoGiaoHealthyScreen extends StatefulWidget {
  const CoGiaoHealthyScreen({super.key});

  @override
  State<CoGiaoHealthyScreen> createState() => _CoGiaoHealthyScreenState();
}

class _CoGiaoHealthyScreenState extends State<CoGiaoHealthyScreen> {
  // --- Dữ liệu giả lập ---
  // Bạn có thể thay đổi danh sách link ảnh web ở đây
  final List<String> _productImages = [
    'assets/images/home1.jpg',
    'assets/images/home2.jpg',
    'assets/images/home3.jpg',
    'assets/images/home4.jpg',
  ];

  // Màu sắc chủ đạo từ giao diện
  static const Color primaryGreen = Color(0xFF689F38); // Màu xanh lá logo
  static const Color secondaryGreen = Color(
    0xFF7CB342,
  ); // Màu xanh nút đăng nhập
  static const Color accentBrown = Color(0xFFD4A76A); // Màu chữ và giỏ hàng
  static const Color accentGreenText = Color(
    0xFF558B2F,
  ); // Màu xanh chữ tiêu đề

  int _currentSlide = 0; // Theo dõi slide hiện tại
  final PageController _pageController =
      PageController(); // Điều khiển PageView

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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nút Đăng nhập
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const BottomBarScreen()),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // LOGO
                        Image.asset(
                          'assets/images/logo.png', // Hãy thay bằng logo thật của bạn
                          height: 80.h,
                          errorBuilder: (context, error, stackTrace) => Column(
                            children: const [
                              Text(
                                'Cô Giáo',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: accentBrown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'healthy',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 1.w),
                        // Giỏ hàng
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => ShoppingCartScreen()),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: mainDarkGreen,
                                size: 35,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: const BoxDecoration(
                                      color: Color(
                                        0xFFFFF176,
                                      ), // Màu vàng của số
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      ' 0 ',
                                      style: TextStyle(
                                        color: accentBrown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        const ListSpScreen()),
                                  ),
                                );
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
                                      ? accentGreenText
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
                  CourseItem(),
                  CourseItem(),
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
          Container(
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
              children: const [
                ServiceIconButton(
                  title: 'Messenger',
                  iconPath: 'assets/icons/fb_messsage.svg',
                ),
                ServiceIconButton(
                  title: 'Zalo',
                  iconPath: 'assets/icons/icon_zalo.svg',
                ), // Cần custom icon Zalo thật
                ServiceIconButton(
                  title: 'Gọi hotline',
                  iconPath: 'assets/images/call.png',
                ),
                ServiceIconButton(
                  title: 'Hỗ trợ ngay',
                  iconPath: 'assets/images/suport.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget nhỏ tùy chỉnh cho các nút dịch vụ tròn

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

class CourseItem extends StatelessWidget {
  const CourseItem({super.key});

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
          Image.network(
            'https://lms.cogiaohealthy.vn/images/AVAMOI/B%E1%BA%A3n%20sao%20c%E1%BB%A7a%20%E1%BA%A2nh%20%C4%91%E1%BA%A1i%20di%E1%BB%87n%20kho%C3%A1%20h%E1%BB%8Dc%20tr%C3%AAn%20website%20%285%29.jpg',
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
                  'Đồ uống healthy',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'KHÓA HỌC MÔ HÌNH KINH DOANH SỮA HẠT DƯỠNG SINH HIỆN ĐẠI - MASTER CLASS 2026',
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
                '  07/05/2026 - 09/05/2026',
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: mainDarkGreen, size: 16),
              Text(
                '  TP.HCM',
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                    Icon(Icons.person_outline, color: Colors.yellow, size: 16),
                    Text(
                      '  1036 lượt học',
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5,990,000đ',
                    style: defaultText16B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '6,990,000đ',
                    style: defaultText12M.copyWith(
                      color: colorText,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => RegisterClassOff(type: 'off')),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),

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
                    'Đăng ký ngay',
                    style: defaultText16B.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
