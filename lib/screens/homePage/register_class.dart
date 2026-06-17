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

class RegisterClassOff extends StatefulWidget {
  const RegisterClassOff({super.key});
  @override
  State<RegisterClassOff> createState() => _RegisterClassOffState();
}

class _RegisterClassOffState extends State<RegisterClassOff> {
  late int currentPage = 1;
  bool isLoading = true;
  late CourseDetailModel courses;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading = true;
    courses = await ExternalRepo().getDetailCourseExternal();
    setState(() {
      isLoading = false;
    });
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

                    SizedBox(height: 20.h),
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
                    Row(
                      children: [
                        SizedBox(width: 16.w),
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
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.location_on_outlined,
                          color: mainDarkGreen,
                          size: 16,
                        ),
                        Text(
                          '  Trực tiếp tại Hà Nội',
                          style: defaultText14M.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.person_outline,
                          color: mainDarkGreen,
                          size: 16,
                        ),
                        Text(
                          '  Giảng viên: Linh Phan',
                          style: defaultText14M.copyWith(
                            color: mainDarkGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //title:  Text('Đã thêm vào giỏ hàng'),
                              content: const Text('Tiếp tục tư vấn'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancle'),
                                  child: const Text('Cancle'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (!await launchUrl(
                                      Uri.parse(
                                        'https://www.messenger.com/t/104656608601884/?messaging_source=source%3Apages%3Amessage_shortlink&source_id=1441792&recurring_notification=0',
                                      ),
                                    )) {
                                      throw Exception('Could not launch ');
                                    }
                                  },

                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            //cartItems.add(courses[0]);
                            return AlertDialog(
                              //title:  Text('Đã thêm vào giỏ hàng'),
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
                    SizedBox(height: 28.h),
                    Html(data: courses.description ?? ''),
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
            "Nội dung bài học",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
          height: 170.h, // Nới chiều cao lên một chút để chứa ảnh đẹp hơn
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final fb = feedbacks[index];
              final String? imgPath = fb['img'];
              final bool hasImage = imgPath != null && imgPath.isNotEmpty;

              return Container(
                width: 320.w, // Rộng ra chút để đủ chỗ cho cả chữ và ảnh
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cột trái: Tên user và Nội dung feedback
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 12.h),
                          Expanded(
                            child: Text(
                              fb['content'] ?? '',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[800],
                                height: 1.4,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Cột phải: Hiển thị ảnh trả bài (Nếu có)
                    if (hasImage) ...[
                      SizedBox(width: 12.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          '$baseUrl$imgPath',
                          width: 80.w,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80.w,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ],
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
