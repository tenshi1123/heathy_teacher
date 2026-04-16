import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';

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
              : 'Chi tiết khoá video',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => NotificationScreen())),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
              Image.asset(
                widget.type == 'off'
                    ? 'assets/images/off_class_4.png'
                    : 'assets/images/online_class_1.png',
                width: 343.w,
                height: 280.h,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  SizedBox(width: 16.w),
                  RatingStars(
                    rating: 4.6, // Hiển thị 4.5 sao
                    starSize: 16.r,
                  ),
                  Text(
                    '(4,6)',
                    style: defaultText14SB.copyWith(fontSize: 12.sp),
                  ),
                  Text(
                    ' • Giảng viên: HVG DTLOAN',
                    style: defaultText14SB.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: 343.w,
                child: Text(
                  widget.type == 'off'
                      ? 'Lớp nấu ăn Eatclean cơ bản cho gia đình'
                      : 'Lớp bánh mì sandwich & pate, ăn kèm heakthy',
                  style: defaultText18B,
                ),
              ),
              SizedBox(height: 28.h),
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
              InkWell(
                onTap: () {},
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
