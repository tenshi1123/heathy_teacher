import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DiaryDetailScreen extends StatefulWidget {
  final String slug;
  final List<PostModel> relatedDiaries;

  const DiaryDetailScreen({
    super.key,
    required this.slug,
    required this.relatedDiaries,
  });

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late final WebViewController _controller;
  bool isLoading = true;
  late PostModel item;
  @override
  void initState() {
    super.initState();
    _fetchData();
    // _controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..loadRequest(Uri.parse('https://www.youtube.com/shorts/ywL-cgn0raI'));
  }

  Future<void> _fetchData() async {
    try {
      item = await HomeRepo().getDetailPost(widget.slug);
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
  Widget build(BuildContext context) {
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
                                text: item.title,
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
                          item.title,
                          style: defaultText20B.copyWith(
                            color: mainDarkGreen,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Date
                        Text(
                          item.date,
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
                        //RecipeGridWidget(recipes: relatedDiaries, type: 2),
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
          CachedNetworkImage(
  imageUrl: 'https://cogiaohealthy.vn/wp-content/uploads/2025/07/logo_footer.png',
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
