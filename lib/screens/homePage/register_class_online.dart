import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/screens/coursePage/video_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/shoppingCart/order_payment_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RegisterClassON extends StatefulWidget {
  const RegisterClassON({super.key, required this.id, this.isTrial = false});
  final String id;
  final bool isTrial;
  @override
  State<RegisterClassON> createState() => _RegisterClassONState();
}

class _RegisterClassONState extends State<RegisterClassON> {
  bool isLoading = true;
  late CourseDetailModel courses;
  bool _isVideoPlaying = false;
  WebViewController? _webViewController;

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final String htmlContent =
        '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        body { margin: 0; padding: 0; background-color: black; overflow: hidden; }
        iframe { width: 100vw; height: 100vh; border: none; }
      </style>
    </head>
    <body>
      <iframe 
        src="${courses.youtubeUrl}" 
        allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;" 
        allowfullscreen="true">
      </iframe>
    </body>
    </html>
    ''';

    _webViewController = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString(htmlContent, baseUrl: 'https://lms.cogiaohealthy.vn/');
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ExternalRepo().getDetailCourseExternal(widget.id);
      setState(() {
        courses = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  String _formatHtml(String? html) {
    if (html == null || html.isEmpty) return '';
    return html
        .replaceAll(RegExp(r'width:\s*\d+px;?'), '')
        .replaceAll(RegExp(r'height:\s*\d+px;?'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        toolbarHeight: 40.h,
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isShow == 'true')
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
                    color: Colors.white,
                    size: 28, // Giảm size Icon giỏ hàng một chút
                  ),
                ],
              ),
            ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SizedBox(
                      width: 343.w,
                      child: Text(
                        courses.title ?? '',
                        style: defaultText20B.copyWith(color: mainDarkGreen),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    CachedNetworkImage(
                      imageUrl: courses.image ?? '',
                      width: 343.w,
                      height: 280.h,
                    ),

                    SizedBox(height: 20.h),
                    if (isShow == 'true')
                      SizedBox(
                        width: 343.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              NumberFormat.decimalPattern(
                                'vi_VN',
                              ).format(int.parse(courses.price ?? '')),
                              style: defaultText16B.copyWith(
                                color: mainDarkGreen,
                                fontSize: 24.sp,
                              ),
                            ),
                            if (courses.priceOld != null && courses.priceOld != '0' && courses.priceOld != '')
                              Text(
                                NumberFormat.decimalPattern(
                                  'vi_VN',
                                ).format(int.parse(courses.priceOld ?? '')),
                                style: defaultText14Re.copyWith(
                                  fontSize: 10.sp,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: mainDarkGreen.withValues(alpha: 0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Text(
                                '  ${courses.lessonNumber} bài học',
                                style: defaultText12M.copyWith(
                                  color: mainDarkGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isShow == 'true')
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: mainDarkGreen.withValues(alpha: 0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                Text(
                                  '  ${int.parse(courses.startCount ?? '0')} lượt học',
                                  style: defaultText12M.copyWith(
                                    color: mainDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    if (isShow == 'true') ...[
                      if (widget.isTrial) ...[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterClassON(
                                  id: widget.id,
                                  isTrial: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 48.h,
                            width: 343.w,
                            margin: EdgeInsets.only(bottom: 12.h, top: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: const Color(0xFFF98825),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Đăng ký khoá học đầy đủ',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            LessonModel? trialLesson;
                            if (courses.topicals != null) {
                              for (var topical in courses.topicals!) {
                                if (topical.lessons != null) {
                                  for (var lesson in topical.lessons!) {
                                    if (lesson.isTrial != '0') {
                                      trialLesson = lesson;
                                      break;
                                    }
                                  }
                                }
                                if (trialLesson != null) break;
                              }
                            }

                            if (trialLesson != null) {
                              String url = await ExternalRepo().getStreamingUrl(
                                lessonId: trialLesson.lessonsId ?? '',
                              );
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return VideoPopupWidget(
                                      url: url,
                                      name:
                                          trialLesson!.name ??
                                          'Không có tên bài giảng',
                                    );
                                  },
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Không tìm thấy video học thử cho khóa học này!',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 48.h,
                            width: 343.w,
                            margin: EdgeInsets.only(bottom: 28.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: const Color(0xFFF98825),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Xem video học thử ngay',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        InkWell(
                          onTap: () {
                            globalListCart.clear();
                            globalListCart.add(
                              CartItem(
                                id: courses.id ?? '',
                                name: courses.title ?? '',
                                image: courses.image ?? '',
                                price: int.tryParse(courses.price ?? '0') ?? 0,
                                isCourse: true,
                                courseTypeId: courses.courseTypeId,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderPaymentScreen(),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: Container(
                            height: 48.h,
                            width: 343.w,
                            margin: EdgeInsets.only(bottom: 28.h, top: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: mainDarkGreen,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/lingting.png'),
                                Text(
                                  '  Đăng ký ngay',
                                  textAlign: TextAlign.center,
                                  style: defaultText16B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            int existingIndex = globalListCart.indexWhere(
                              (element) => element.id == courses.id,
                            );
                            if (existingIndex != -1) {
                              globalListCart[existingIndex].quantity++;
                            } else {
                              globalListCart.add(
                                CartItem(
                                  id: courses.id ?? '',
                                  name: courses.title ?? '',
                                  image: courses.image ?? '',
                                  price:
                                      int.tryParse(courses.price ?? '0') ?? 0,
                                  isCourse: true,
                                  courseTypeId: courses.courseTypeId,
                                ),
                              );
                            }
                            setState(() {});
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                    'Sản phẩm đã được thêm vào giỏ hàng của bạn.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 48.h,
                            width: 340.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                              border: Border.all(
                                color: mainDarkGreen,
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/gio_hang.png'),
                                Text(
                                  '  Thêm vào giỏ hàng',
                                  textAlign: TextAlign.center,
                                  style: defaultText16B.copyWith(
                                    color: mainDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ] else ...[
                      Container(
                        height: 48.h,
                        width: 343.w,
                        margin: EdgeInsets.only(bottom: 28.h, top: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.grey,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Đã khóa',
                          style: defaultText16B.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                    SizedBox(height: 28.h),
                    Html(data: _formatHtml(courses.description)),
                    _buildVideoSection(),

                    _buildCourseContent(),
                    _buildFeedbackSection(),
                    SizedBox(height: 36.h),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    if (courses.youtubeUrl == null || courses.youtubeUrl!.isEmpty) {
      return const SizedBox.shrink(); // Không có link thì ẩn
    }

    if (_isVideoPlaying && _webViewController != null) {
      return Container(
        width: double.infinity,
        height: 220.h,
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: WebViewWidget(controller: _webViewController!),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _initWebView();
        setState(() {
          _isVideoPlaying = true;
        });
      },
      child: Container(
        width: double.infinity,
        height: 220.h,
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12.r),
          image: courses.image != null
              ? DecorationImage(
                  image: NetworkImage(courses.image!), // Gắn URL thật vào
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 60.w),
        ),
      ),
    );
  }

  Widget _buildCourseContent() {
    final topicals = courses.topicals ?? [];
    if (topicals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "NỘI DUNG BÀI GIẢNG",
            style: defaultText20B.copyWith(color: mainDarkGreen),
          ),
          SizedBox(height: 12.h),
          // Danh sách các chương
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topicals.length,
            itemBuilder: (context, index) {
              final topic = topicals[index];
              final lessons = topic.lessons ?? [];
              final bool hasTrialLesson = lessons.any(
                (lesson) => lesson.isTrial != '0',
              );

              return Card(
                elevation: 0,
                color: const Color(0xffF5FAF5),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.only(bottom: 12.h),
                // Mở rộng/Thu gọn bài học
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          topic.name ?? 'Chưa cập nhật',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      if (hasTrialLesson) ...[
                        SizedBox(width: 8.w),
                        Text(
                          'Học thử',
                          style: defaultText14B.copyWith(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                  children: lessons.map((lesson) {
                    return GestureDetector(
                      onTap: () async {
                        if (lesson.isTrial != '0') {
                          String url = await ExternalRepo().getStreamingUrl(
                            lessonId: lesson.lessonsId ?? '',
                          );
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return VideoPopupWidget(
                                  url: url,
                                  name: lesson.name ?? 'Không có tên bài giảng',
                                );
                              },
                            );
                          }
                        }
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.play_circle_outline,
                          color: Colors.green,
                          size: 20.w,
                        ),
                        title: Text(
                          lesson.name ?? '',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lesson.time ?? '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (lesson.isTrial == '0')
                              Icon(Icons.lock, color: Colors.grey, size: 16.sp)
                            else
                              Text(
                                'Học\nthử',
                                style: defaultText14B.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // ================= 4. FEEDBACK CHẠY (Bản cập nhật có Ảnh) =================
  Widget _buildFeedbackSection() {
    final feedbacks = courses.feedbacks ?? [];
    if (feedbacks.isEmpty) return const SizedBox.shrink();

    return _FeedbackCarousel(
      feedbacks: feedbacks,
      courseTitle: courses.title ?? '',
    );
  }
}

class _FeedbackCarousel extends StatefulWidget {
  final List<dynamic> feedbacks;
  final String courseTitle;

  const _FeedbackCarousel({required this.feedbacks, required this.courseTitle});

  @override
  State<_FeedbackCarousel> createState() => _FeedbackCarouselState();
}

class _FeedbackCarouselState extends State<_FeedbackCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < widget.feedbacks.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'https://lms.cogiaohealthy.vn';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "FEEDBACK CỦA HỌC VIÊN",
            style: defaultText20B.copyWith(
              color: mainDarkGreen,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 540.h, // Đủ chiều cao cho thẻ đè
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.feedbacks.length,
                itemBuilder: (context, index) {
                  final fb = widget.feedbacks[index];
                  final String? imgPath = fb['img'];
                  final bool hasImage = imgPath != null && imgPath.isNotEmpty;
                  final String imageUrl = hasImage
                      ? (imgPath.startsWith('http')
                            ? imgPath
                            : '$baseUrl$imgPath')
                      : '';

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 48.w),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 360.h, // Chiều cao của khung ảnh
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xffF5FAF5),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: hasImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 20.h,
                            left: 12.w,
                            right: 12.w,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 24.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.courseTitle.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: defaultText16B.copyWith(
                                  color: mainDarkGreen,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                fb['content'] ?? '',
                                textAlign: TextAlign.center,
                                style: defaultText14M.copyWith(
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                (fb['user_name'] ?? 'Học viên').toUpperCase(),
                                textAlign: TextAlign.center,
                                style: defaultText14B.copyWith(
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (_currentIndex > 0)
                Positioned(
                  left: 12.w,
                  child: InkWell(
                    onTap: _prevPage,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: mainGreen, width: 1.5),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: mainGreen,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
              if (_currentIndex < widget.feedbacks.length - 1)
                Positioned(
                  right: 12.w,
                  child: InkWell(
                    onTap: _nextPage,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: mainGreen, width: 1.5),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: mainGreen,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoPopupWidget extends StatefulWidget {
  final String url;
  final String name;
  const VideoPopupWidget({super.key, required this.url, required this.name});

  @override
  State<VideoPopupWidget> createState() => _VideoPopupWidgetState();
}

class _VideoPopupWidgetState extends State<VideoPopupWidget> {
  late final WebViewController _controller;

  String _getEmbedUrl(String url) {
    if (url.contains("youtube.com/watch?v=")) {
      final videoId = url.split("v=")[1].split("&")[0];
      return "https://www.youtube.com/embed/$videoId";
    } else if (url.contains("youtu.be/")) {
      final videoId = url.split("youtu.be/")[1].split("?")[0];
      return "https://www.youtube.com/embed/$videoId";
    } else if (url.contains("youtube.com/shorts/")) {
      final videoId = url.split("shorts/")[1].split("?")[0];
      return "https://www.youtube.com/embed/$videoId";
    }
    return url;
  }

  @override
  void initState() {
    super.initState();
    final embedUrl = _getEmbedUrl(widget.url);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(_buildHtml(embedUrl));
  }

  String _buildHtml(String url) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          body { margin: 0; padding: 0; background-color: black; overflow: hidden; }
          iframe { width: 100vw; height: 100vh; border: none; }
        </style>
      </head>
      <body>
        <iframe 
          src="$url" 
          allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;" 
          allowfullscreen="true">
        </iframe>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 220.h,
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: WebViewWidget(controller: _controller),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Positioned(
          //   bottom: 20,
          //   right: 20,
          //   child: IconButton(
          //     icon: const Icon(Icons.fullscreen, color: Colors.white, size: 32),
          //     onPressed: () {
          //       Navigator.pop(context);
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => DetailVideo(
          //             streamingUrl: widget.url,
          //             name: widget.name,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
