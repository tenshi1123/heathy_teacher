import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterClassON extends StatefulWidget {
  const RegisterClassON({super.key});
  @override
  State<RegisterClassON> createState() => _RegisterClassONState();
}

class _RegisterClassONState extends State<RegisterClassON> {
  late int currentPage = 1;
  @override
  void initState() {
    super.initState();
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
          child: Column(
            children: [
              SizedBox(
                width: 343.w,
                child: Text(
                  'Lớp bánh mì sandwich & pate, ăn kèm heakthy',
                  style: defaultText20B.copyWith(color: mainDarkGreen),
                ),
              ),
              Image.asset(
                'assets/images/online_class_1.png',
                width: 343.w,
                height: 280.h,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20.h),
              if (isShow == 'true')
                SizedBox(
                  width: 343.w,
                  child: Row(
                    children: [
                      Text(
                        '3.000.000đ',
                        style: defaultText16B.copyWith(
                          color: mainDarkGreen,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '4.000.000đ',
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
                    '  Học online qua app',
                    style: defaultText14M.copyWith(color: mainDarkGreen),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (isShow == 'true') ...[
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
                              onPressed: () => Navigator.pop(context, 'Cancle'),
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
                          style: defaultText16B.copyWith(color: Colors.white),
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
                          style: defaultText16B.copyWith(color: mainDarkGreen),
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Khóa học này chính là lựa chọn lý tưởng dành cho bạn! Với lộ trình bài bản, giảng viên giàu kinh nghiệm và môi trường học tập hiện đại, bạn sẽ được hướng dẫn từng bước – từ kỹ thuật cơ bản đến cách trình bày món ăn đẹp mắt.',
                  style: defaultText14M,
                ),
              ),
              VideoLessonPreviewWidget(),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    Text(
                      'Nội dung bài giảng',
                      style: defaultText20B.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Khối lớn: A. LÝ THUYẾT
                  _buildParentCategory(
                    title: 'A. LÝ THUYẾT',
                    children: [
                      _buildSubSection(
                        title: 'I. LÝ THUYẾT DINH DƯỠNG TRONG NẤU ĂN HEALTHY',
                        lessons: [
                          _LessonData(
                            name: '1. Cách tính chỉ số cơ thể (BMI, BMR, TDEE)',
                            time: '11:04',
                            isLocked: true,
                          ),
                          _LessonData(
                            name:
                                '2. Cách tính calo nạp vào cơ thể theo các mục tiêu (tăng cơ/ giảm mỡ/ giữ dáng)',
                            time: '8:00',
                            isLocked: true,
                          ),
                        ],
                      ),
                      _buildSubSection(
                        title:
                            'II. LÝ THUYẾT CÁCH TÍNH CHỈ SỐ CƠ THỂ VÀ LÊN MENU DINH DƯỠNG TRONG KHẨU PHẦN ĂN THEO MỤC TIÊU (TĂNG CƠ/ GIẢM MỠ/ GIỮ DÁNG) .',
                        lessons: [
                          _LessonData(
                            name: '1. Cách tính chỉ số cơ thể (BMI, BMR, TDEE)',
                            time: '11:04',
                            isLocked: true,
                          ),
                          _LessonData(
                            name:
                                '2. Cách tính calo nạp vào cơ thể theo các mục tiêu (tăng cơ/ giảm mỡ/ giữ dáng)',
                            time: '8:00',
                            isLocked: true,
                          ),
                        ],
                      ),
                      _buildSubSection(
                        title:
                            'III. TƯ VẤN MÔ HÌNH KINH DOANH THỰC PHẨM CHẾ BIẾN SẴN/ KINH DOANH SUẤT ĂN VỚI ENERGY BOWL).',
                        lessons: [],
                      ),
                    ],
                  ),

                  const Divider(height: 1, color: Color(0xFFEEEEEE)),

                  // Khối lớn: B. THỰC HÀNH
                  _buildParentCategory(title: 'B. THỰC HÀNH', children: []),
                ],
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Giao diện chính hiển thị danh sách bài học

// 1. Widget cho Danh mục Cha lớn (A. LÝ THUYẾT, B. THỰC HÀNH)
Widget _buildParentCategory({
  required String title,
  required List<Widget> children,
}) {
  return Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      initiallyExpanded: true,
      controlAffinity: ListTileControlAffinity.leading, // Đưa mũi tên ra trước
      iconColor: Colors.black54,
      collapsedIconColor: Colors.black54,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: children,
    ),
  );
}

// 2. Widget cho Mục con (I, II, III...)
Widget _buildSubSection({
  required String title,
  required List<_LessonData> lessons,
}) {
  return Column(
    children: [
      const Divider(height: 1, color: Color(0xFFEEEEEE)),
      Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false, // Tự mở nếu có bài học bên trong
          controlAffinity: ListTileControlAffinity.leading,
          iconColor: Colors.black54,
          collapsedIconColor: Colors.black54,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              height: 1.4,
            ),
          ),
          children: lessons.map((lesson) => _buildLessonItem(lesson)).toList(),
        ),
      ),
    ],
  );
}

// 3. Widget hiển thị từng dòng Bài Học chi tiết
Widget _buildLessonItem(_LessonData lesson) {
  return Column(
    children: [
      const Divider(height: 1, color: Color(0xFFF0F0F0)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Play hình tròn xanh lá
            const Icon(
              Icons.play_circle_fill,
              color: Color(0xFF467D43),
              size: 22,
            ),
            const SizedBox(width: 10),

            // Tiêu đề bài học (Tự động xuống dòng)
            Expanded(
              child: Text(
                lesson.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF424242),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Cột chứa thời gian & Icon ổ khóa ở góc phải
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lesson.time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF616161),
                  ),
                ),
                if (lesson.isLocked) ...[
                  const SizedBox(height: 4),
                  const Icon(Icons.lock, size: 18, color: Color(0xFF757575)),
                ],
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// Class chứa dữ liệu ảo phục vụ việc hiển thị UI bài học
class _LessonData {
  final String name;
  final String time;
  final bool isLocked;

  _LessonData({required this.name, required this.time, required this.isLocked});
}
