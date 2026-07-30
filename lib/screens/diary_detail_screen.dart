import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                  const CustomFooterInfo(),
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
