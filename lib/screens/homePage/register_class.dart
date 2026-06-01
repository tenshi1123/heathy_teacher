import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterClassOff extends StatefulWidget {
  const RegisterClassOff({super.key, required this.type});
  final String type;
  @override
  State<RegisterClassOff> createState() => _RegisterClassOffState();
}

class _RegisterClassOffState extends State<RegisterClassOff> {
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
          widget.type == 'off'
              ? 'Chi tiết lớp trực tiếp'
              : 'Chi tiết khoá online',
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
          child: Column(
            children: [
              SizedBox(
                width: 343.w,
                child: Text(
                  widget.type == 'off'
                      ? 'Lớp nấu ăn Eatclean cơ bản cho gia đình'
                      : 'Lớp bánh mì sandwich & pate, ăn kèm heakthy',
                  style: defaultText20B.copyWith(color: mainDarkGreen),
                ),
              ),
              Image.asset(
                widget.type == 'off'
                    ? 'assets/images/off_class_4.png'
                    : 'assets/images/online_class_1.png',
                width: 343.w,
                height: 280.h,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20.h),
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
                  if (widget.type == 'on')
                    Text(
                      '  Học online qua app',
                      style: defaultText14M.copyWith(color: mainDarkGreen),
                    )
                  else
                    Text(
                      '  Trực tiếp tại Hà Nội',
                      style: defaultText14M.copyWith(color: Colors.red),
                    ),
                ],
              ),
              if (widget.type == 'off')
                Row(
                  children: [
                    SizedBox(width: 16.w),
                    Icon(Icons.person_outline, color: mainDarkGreen, size: 16),
                    Text(
                      '  Giảng viên: Linh Phan',
                      style: defaultText14M.copyWith(color: mainDarkGreen),
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
                      cartItems.add(courses[0]);
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
              SizedBox(height: 28.h),

              Row(
                children: [
                  SizedBox(width: 16.w),
                  Text(
                    'Điểm nổi bật của khoá học:',
                    style: defaultText16B.copyWith(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _overviewItem(
                label:
                    'Học và thực hành trực tiếp tại trung tâm với Cô giáo và đội ngũ trợ giảng',
              ),
              _overviewItem(
                label:
                    'Hướng dẫn học viên tự pha và thực hành gần 20 lọại sauce Healthy và ứng dụng',
              ),
              _overviewItem(
                label: 'Hướng dẫn thực hành các món ăn Eatclean đa dạng',
              ),
              _overviewItem(
                label:
                    'Hướng dẫn lên món, phối kết hợp các nguyên liệu để thuận tiện trong việc chế biến bữa ăn gia đình hoặc lên Set menu kinh doanh Online',
              ),
              _overviewItem(
                label:
                    'Sau khóa học vẫn được hỗ trợ 1:1 và học lại nếu cần thiết',
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    Text('Nội dung khoá học:', style: defaultText16B),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Khóa học này chính là lựa chọn lý tưởng dành cho bạn! Với lộ trình bài bản, giảng viên giàu kinh nghiệm và môi trường học tập hiện đại, bạn sẽ được hướng dẫn từng bước – từ kỹ thuật cơ bản đến cách trình bày món ăn đẹp mắt.',
                  style: defaultText14M,
                ),
              ),
              widget.type == 'off'
                  ? Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          Text(
                            'Lịch khai giảng tháng 8',
                            style: defaultText16B,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              widget.type == 'off'
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Khóa học này chính là lựa chọn lý tưởng dành cho bạn! Với lộ trình bài bản, giảng viên giàu kinh nghiệm và môi trường học tập hiện đại, bạn sẽ được hướng dẫn từng bước – từ kỹ thuật cơ bản đến cách trình bày món ăn đẹp mắt.',
                        style: defaultText14M,
                      ),
                    )
                  : SizedBox(),

              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _overviewItem({required String label}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.asset(
        'assets/images/tick_2.png',
        width: 16.w,
        height: 16.h,
        fit: BoxFit.fill,
      ),
      SizedBox(width: 8.w),
      SizedBox(
        width: 310.w,
        child: Text(label, style: defaultText14SB),
      ),
    ],
  );
}
