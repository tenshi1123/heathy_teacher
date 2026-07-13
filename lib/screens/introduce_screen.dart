import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  // Màu xanh lá logo
  static const Color secondaryGreen = Color(0xFF7CB342);
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

                  Container(
                    margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 32.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Image.asset(
                      'assets/images/introduce_image.png',
                      width: double.infinity,
                      fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                    ),
                  ),
                  Container(
                    width: double.infinity,

                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: backGroundGreen,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GIỚI THIỆU VỀ NGƯỜI SÁNG LẬP',
                          style: defaultText18B.copyWith(color: Colors.white),
                        ),
                        Text(
                          'CÔ GIÁO HEALTHY LINH PHAN',
                          style: defaultText20B.copyWith(
                            color: mainYellow,
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          'Linh Phan – người tiên phong chuyên nghiệp hóa lĩnh vực đào tạo Eatclean tại Việt Nam.',
                          style: defaultText16M.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Với hơn 10 năm kinh nghiệm trong ngành thực phẩm và giáo dục sức khỏe, chị là người đầu tiên tại Việt Nam xây dựng trung tâm đào tạo trực tiếp chuyên sâu về Eatclean tại cả Hà Nội và TP. Hồ Chí Minh. Không chỉ dừng lại ở vai trò giảng viên, Linh xác lập cho mình một sứ mệnh lớn hơn: kiến tạo nền tảng đào tạo Eatclean bài bản, thực tiễn và có trách nhiệm với cộng đồng.',
                          style: defaultText16M.copyWith(color: Colors.white),
                        ),
                        RotatedBox(
                          quarterTurns: 2, // Xoay 2 góc vuông (180 độ)
                          child: Icon(
                            Icons.format_quote,
                            size: 60,
                            color: Color(0xFFFEFDF0), // Màu trắng kem
                          ),
                        ),
                        Text(
                          'Tôi tin rằng, Eatclean không chỉ là chế độ ăn, mà là một phong cách sống – và có thể trở thành một nghề nghiệp tử tế nếu được đào tạo đúng cách.',
                          style: defaultText16M.copyWith(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Linh Phan, sáng lập Cô Giáo Healthy',
                          style: defaultText16B.copyWith(color: mainYellow),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    //height: 375.w * 4 / 3,
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    child: Image.asset(
                      'assets/images/introduce_image2.png',
                      width: double.infinity,
                      fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VỀ CÔ GIÁO HEALTHY',
                          style: defaultText20B.copyWith(
                            color: mainDarkGreen,
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          'Một doanh nghiệp giáo dục mang sứ mệnh phụng sự',
                          style: defaultText16M.copyWith(color: mainDarkGreen),
                        ),
                        Text(
                          'Khác với mô hình dạy nấu ăn đơn lẻ, Cô Giáo Healthy được thành lập như một tổ chức giáo dục chuyên biệt, với tầm nhìn dài hạn: trở thành nơi đào tạo – định hướng – đồng hành cùng những người xây dựng mô hình Eatclean tử tế và bền vững.',
                          style: defaultText16M.copyWith(color: Colors.black87),
                        ),
                        Text(
                          'Chúng tôi phục vụ 3 nhóm học viên chính:',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
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
                            color: backGroundGreen,
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
