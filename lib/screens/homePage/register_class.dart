import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/shoppingCart/order_payment_screen.dart';

class RegisterClassOff extends StatefulWidget {
  const RegisterClassOff({super.key, required this.id});
  final String id;
  @override
  State<RegisterClassOff> createState() => _RegisterClassOffState();
}

class _RegisterClassOffState extends State<RegisterClassOff> {
  bool isLoading = true;
  late CourseDetailModel courses;
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
    if (html == null) return '';
    return html
        .replaceAll(RegExp(r'width:\s*\d+px;?'), '')
        .replaceAll(RegExp(r'height:\s*\d+px;?'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chi tiết lớp trực tiếp',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => ShoppingCartScreen())),
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
                    Image.network(
                      courses.image ?? '',
                      width: 343.w,
                      height: 280.h,
                    ),
                    Html(data: _formatHtml(courses.description)),
                    SizedBox(height: 20.h),
                    //if (isShow == 'true')
                    SizedBox(
                      width: 343.w,
                      child: Row(
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
                          SizedBox(width: 12.w),
                          if (courses.priceOld != '0')
                            Text(
                              NumberFormat.decimalPattern(
                                'vi_VN',
                              ).format(int.parse(courses.priceOld ?? '')),
                              style: defaultText14Re.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ),

                    //SizedBox(height: 12.h),
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
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderPaymentScreen(),
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
                              price: int.tryParse(courses.price ?? '0') ?? 0,
                              isCourse: true,
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
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                          border: Border.all(color: mainDarkGreen, width: 1.w),
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

                    _buildVideoSection(),
                    SizedBox(height: 28.h),
                    Row(
                      children: [
                        SizedBox(width: 16.w),
                        Text(
                          "Nội dung Khóa học",
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ],
                    ),
                    Html(data: _formatHtml(courses.content)),
                    //_buildCourseContent(),
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
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () async {
        String urlString = courses.youtubeUrl!;
        // Chuyển link embed thành link watch thông thường để app YouTube dễ mở hơn
        if (urlString.contains('youtube.com/embed/')) {
          final uri = Uri.parse(urlString);
          final pathSegments = uri.pathSegments;
          if (pathSegments.isNotEmpty && pathSegments.first == 'embed') {
            final videoId = pathSegments.length > 1 ? pathSegments[1] : '';
            if (videoId.isNotEmpty) {
              urlString = 'https://www.youtube.com/watch?v=$videoId';
            }
          }
        }

        final url = Uri.parse(urlString);
        try {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } catch (_) {
          try {
            await launchUrl(url, mode: LaunchMode.platformDefault);
          } catch (e) {
            debugPrint("Không thể mở link: $url");
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 220.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12.r),
          image: courses.image != null
              ? DecorationImage(
                  image: NetworkImage(courses.image!),
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

  Widget _buildFeedbackSection() {
    final feedbacks = courses.feedbacks ?? [];
    if (feedbacks.isEmpty) return const SizedBox.shrink();

    // Thay domain thật của bạn vào đây để nối với đường dẫn ảnh tương đối
    const String baseUrl = 'https://lms.cogiaohealthy.vn';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Đánh giá từ học viên",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 400.h, // Đã tăng chiều cao để đủ chỗ cho ảnh dọc và text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final fb = feedbacks[index];
              final String? imgPath = fb['img'];
              final bool hasImage = imgPath != null && imgPath.isNotEmpty;

              return Container(
                width: 320.w, // Độ rộng hợp lý cho thẻ dọc
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần trên: Hiển thị ảnh trả bài (Nếu có)
                    if (hasImage) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          imgPath.startsWith('http')
                              ? imgPath
                              : '$baseUrl$imgPath',
                          width: double.infinity,
                          //height: 120.h,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: double.infinity,
                                height: 120.h,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    // Phần dưới: Tên user và Nội dung feedback
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14.r,
                          backgroundColor: Colors.green[100],
                          child: Text(
                            fb['user_name']?.substring(0, 1) ?? 'U',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            fb['user_name'] ?? 'Học viên',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: Text(
                        fb['content'] ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                        //maxLines: hasImage ? 3 : 8,
                        //overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
