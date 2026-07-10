import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/shoppingCart/order_payment_screen.dart';

class RegisterClassON extends StatefulWidget {
  const RegisterClassON({super.key, required this.id});
  final String id;
  @override
  State<RegisterClassON> createState() => _RegisterClassONState();
}

class _RegisterClassONState extends State<RegisterClassON> {
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
          'Chi tiết khoá online',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
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
                    Image.network(
                      courses.image ?? '',
                      width: 343.w,
                      height: 280.h,
                    ),

                    SizedBox(height: 20.h),
                    if (isShow == 'true')
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

                    SizedBox(height: 12.h),
                    if (isShow == 'true') ...[
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

    // Tạm thời hiển thị thumbnail giả lập có nút Play.
    // Trong thực tế, bạn gắn package `youtube_player_flutter` vào đây
    return Container(
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
            "Nội dung bài Giảng",
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
                  title: Text(
                    topic.name ?? 'Chưa cập nhật',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  children: lessons.map((lesson) {
                    return ListTile(
                      leading: Icon(
                        Icons.play_circle_outline,
                        color: Colors.green,
                        size: 20.w,
                      ),
                      title: Text(
                        lesson.name ?? '',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      trailing: Text(
                        lesson.time ?? '',
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
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
          height: 280.h, // Đã tăng chiều cao để đủ chỗ cho ảnh dọc và text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final fb = feedbacks[index];
              final String? imgPath = fb['img'];
              final bool hasImage = imgPath != null && imgPath.isNotEmpty;

              return Container(
                width: 300.w, // Độ rộng hợp lý cho thẻ dọc
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
                          height: 120.h,
                          fit: BoxFit.cover,
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
                        maxLines: hasImage ? 3 : 8,
                        overflow: TextOverflow.ellipsis,
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
