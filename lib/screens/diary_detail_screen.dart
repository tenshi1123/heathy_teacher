import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiaryDetailScreen extends StatefulWidget {
  final RecipeModel item;

  const DiaryDetailScreen({super.key, required this.item});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://www.youtube.com/shorts/ywL-cgn0raI'));
  }

  @override
  Widget build(BuildContext context) {
    // Dummy related diaries
    final List<RecipeModel> relatedDiaries = [
      RecipeModel(
        title:
            "Ngày 3 – Mô hình kinh doanh toàn diện, smoothie – nước ép kết hợp cùng suất ăn...",
        imageUrl: "assets/images/dairy3.jpg",
        date: "06/09/2025",
      ),
      RecipeModel(
        title:
            "Ngày 2 – Tiếp tục khám phá lớp học kinh doanh suất ăn healthy cao cấp có gì nha?",
        imageUrl: "assets/images/dairy2.jpg",
        date: "06/09/2025",
      ),
      RecipeModel(
        title:
            "Nhật ký lớp học trà sữa hạt chuyên sâu trực tiếp: Trà sữa hạt thuần chay tại Cô Giáo...",
        imageUrl: "assets/images/dairy4.jpg",
        date: "22/08/2025",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  DefaultAppBar(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Breadcrumbs
                        RichText(
                          text: TextSpan(
                            style: defaultText12M.copyWith(color: Colors.grey),
                            children: [
                              TextSpan(text: 'Trang chủ > Blog > '),
                              TextSpan(
                                text: widget.item.title,
                                style: defaultText12M.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Title
                        Text(
                          widget.item.title,
                          style: defaultText20B.copyWith(
                            color: mainDarkGreen,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Date
                        Text(
                          widget.item.date ?? "06/09/2025",
                          style: defaultText12M.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 24.h),

                        // YouTube embed widget
                        Center(
                          child: Container(
                            width: 300.w, // Approximate width for youtube short
                            height: 500.h,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: WebViewWidget(controller: _controller),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Description Content
                        Text(
                          "Cùng khám phá lịch trình ngày 1 tại lớp trực tiếp của Cô Giáo Healthy nha 😍\n"
                          "ĐĂNG KÝ NGAY SUẤT HỌC TRONG THÁNG...",
                          style: defaultText14M.copyWith(
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Related posts
                        Center(
                          child: Text(
                            'CÁC BÀI VIẾT LIÊN QUAN',
                            style: defaultText20B.copyWith(
                              color: mainDarkGreen,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Related Posts Grid (Using type 2)
                        RecipeGridWidget(recipes: relatedDiaries, type: 2),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),

                  // Footer
                  _buildFooter(context),
                ],
              ),
            ),
          ),
          BottomCustom(),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: defaultText14M.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Hà Nội:',
                        style: defaultText14B.copyWith(color: Colors.white),
                      ),
                      TextSpan(text: ' 214 Lạc Long Quân, quận Tây Hồ, Hà Nội'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: defaultText14M.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'HCM:',
                        style: defaultText14B.copyWith(color: Colors.white),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.phone_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: defaultText14M.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Hotline: ',
                        style: defaultText14B.copyWith(color: Colors.white),
                      ),
                      TextSpan(text: '(+84)96 691 2016'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'CÔNG TY TNHH CÔ GIÁO HEALTHY',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            'MST: 0109187074 \nĐăng ký lần đầu ngày 19 tháng 05 năm 2020 \nĐăng ký thay đổi lần thứ 4, ngày 20 tháng 06 năm 2024 \nNơi cấp: Sở kế hoạch và đầu tư thành phố Hà Nội - Phòng đăng ký kinh doanh \nĐịa chỉ trụ sở chính: Tầng 7, Tòa nhà Luxury Ofice, số 214 Lạc Long Quân, Phường Tây Hồ, Thành phố Hà Nội, Việt Nam',
            style: defaultText14M.copyWith(color: Colors.white, height: 1.5),
          ),
          SizedBox(height: 24.h),
          Text(
            'Thông tin',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            'Giới thiệu chung',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text('Khóa học', style: defaultText14M.copyWith(color: Colors.white)),
          SizedBox(height: 8.h),
          Text('Sản phẩm', style: defaultText14M.copyWith(color: Colors.white)),
          SizedBox(height: 8.h),
          Text(
            'Chính sách bảo mật - học tập',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: mainGreen,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theo dõi Cô Giáo Healthy',
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Nhận thông tin mới nhất về khoá học, kiến thức nấu ăn!',
                  style: defaultText14M.copyWith(color: Colors.white),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSocialIcon('assets/images/facebook.png'),
                    _buildSocialIcon('assets/images/youtube.png'),
                    _buildSocialIcon('assets/images/tiktok.png'),
                    _buildSocialIcon('assets/images/zalo.png'),
                    _buildSocialIcon('assets/images/ins.png', size: 20),
                    _buildSocialIcon('assets/images/threads.png'),
                    _buildSocialIcon('assets/images/lemon8.png'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            '© 2025 Cô Giáo Healthy | All Rights Reserved.',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String path, {double size = 28}) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(path, width: size, height: size, fit: BoxFit.contain),
    );
  }
}
