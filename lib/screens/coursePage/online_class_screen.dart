import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class OnlineClassScreen extends StatefulWidget {
  const OnlineClassScreen({super.key});

  @override
  State<OnlineClassScreen> createState() => _OnlineClassScreenState();
}

class _OnlineClassScreenState extends State<OnlineClassScreen> {
  late int currentPage = 1;
  int? expandedIndex;

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
          'Học online với video',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          SvgPicture.asset(
            'assets/icons/bell.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/online_course.png',
                width: 343.w,
                height: 200.h,
                fit: BoxFit.fill,
              ),

              SizedBox(height: 12.h),
              SizedBox(
                width: 343.w,
                child: Text(
                  'Lớp Combo chuyên đề Eatclean nâng cao',
                  style: defaultText18B,
                ),
              ),
              Text('Học online với video', style: defaultText14Re),
              Row(
                children: [
                  Container(
                    height: 8.h,
                    width: 303.w,
                    padding: EdgeInsets.only(right: 223.w),
                    decoration: BoxDecoration(
                      color: Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Container(
                      height: 8.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                        color: mainDarkGreen,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  Text(
                    ' 26%',
                    style: defaultText16B.copyWith(color: mainDarkGreen),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 44.h,
                    width: 162.w,
                    decoration: BoxDecoration(
                      color: Color(0xffEEF5EC),
                      border: Border.all(
                        color: mainDarkGreen.withValues(alpha: 0.28),
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/chat.svg',
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            mainDarkGreen,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text('Chat hỗ trợ', style: defaultText14SB),
                      ],
                    ),
                  ),
                  Container(
                    height: 44.h,
                    width: 162.w,
                    decoration: BoxDecoration(
                      color: Color(0xffEEF5EC),
                      border: Border.all(
                        color: mainDarkGreen.withValues(alpha: 0.28),
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/tra_bai.svg',
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            mainDarkGreen,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text('Trả bài', style: defaultText14SB),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                width: 343.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: mainGreen,
                  border: Border.all(
                    color: mainDarkGreen.withValues(alpha: 0.08),
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/bling.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                    Text(
                      ' Sản phẩm tiêu biểu',
                      style: defaultText14SB.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              Text('Nội dung khoá học', style: defaultText16B),

              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   padding: EdgeInsets.zero,
              //   itemCount: demoSections.length,
              //   itemBuilder: (context, index) {
              //     final question = demoSections[index];
              //     return SectionCard(section: question);
              //   },
              // ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: demoSections.length,
                itemBuilder: (BuildContext context, int index) {
                  return LessonItem(
                    index: index,
                    topicModel: demoSections[index],
                  );
                },
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonItem extends StatefulWidget {
  const LessonItem({super.key, required this.index, required this.topicModel});
  final int index;
  final Section topicModel;
  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  bool isExpanded = false;
  List<Lesson> listLessonVideoModels = demoSections.first.lessons;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 16.h),
        InkWell(
          onTap: () async {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            //height: 62.h,
            width: 338.w,
            margin: EdgeInsets.only(left: 2.w, right: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 16.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 28.h,
                  width: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: mainDarkGreen,
                  ),
                  child: Center(
                    child: Text(
                      '0${widget.index + 1}',
                      style: defaultText14SB.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 226.w,
                      child: Text(
                        widget.topicModel.title,
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                    ),
                    Text('3 bài giảng / 2 tài liệu', style: defaultText12M),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right_outlined),
                SizedBox(width: 16.w),
              ],
            ),
          ),
        ),

        if (isExpanded)
          Column(
            children: listLessonVideoModels
                .map(
                  (e) => GestureDetector(
                    onTap: () async {},
                    child: DetailItem(title: e.title, type: e.subtitle),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({super.key, required this.title, required this.type});
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.check_circle, size: 12.r, color: mainGreen),
            Container(
              height: 32.h,
              width: 1.w,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: const BoxDecoration(color: Colors.green),
            ),
          ],
        ),

        Column(
          children: [
            SizedBox(height: 12.h),
            SvgPicture.asset(
              'assets/icons/video.svg',
              width: 22.w,
              height: 22.h,
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            SizedBox(
              width: 280.w,
              child: Text(title, style: defaultText14M),
            ),
            SizedBox(
              width: 280.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type,
                    style: defaultText12M.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3C3C3C).withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '10 Phút',
                    style: defaultText12M.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3C3C3C).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.h,
              width: 267.w,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: const BoxDecoration(color: Color(0xffEDEDED)),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Demo data classes ---
class Section {
  final int index;
  final String title;
  final String subtitle;
  final List<Lesson> lessons;

  Section({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.lessons,
  });
}

class Lesson {
  final String title;
  final String subtitle;
  final String duration;
  final bool completed;

  Lesson({
    required this.title,
    required this.subtitle,
    required this.duration,
    this.completed = false,
  });
}

final List<Section> demoSections = [
  Section(
    index: 1,
    title: 'Lorem Ipsum is simply',
    subtitle: 'Bài giảng hướng dẫn',
    lessons: [
      Lesson(
        title: 'Duis aute irure dolor in reprehenderit',
        subtitle: 'Bài giảng',
        duration: '10 Phút',
        completed: true,
      ),
      Lesson(
        title: 'It is a long established fact that a reader',
        subtitle: 'Bài giảng hướng dẫn',
        duration: '10 Phút',
        completed: true,
      ),
      Lesson(
        title: 'It is a long established fact that a reader',
        subtitle: 'Bài giảng hướng dẫn',
        duration: '10 Phút',
        completed: true,
      ),
      Lesson(
        title: 'It is a long established fact that a reader',
        subtitle: 'Bài giảng hướng dẫn',
        duration: '15 phút',
        completed: false,
      ),
      Lesson(
        title: 'It is a long established fact that a reader',
        subtitle: 'Bài giảng hướng dẫn',
        duration: '',
        completed: false,
      ),
    ],
  ),
  Section(
    index: 2,
    title: 'There are many variations',
    subtitle: '5 bài giảng / 6 bài tập',
    lessons: [],
  ),
  Section(
    index: 3,
    title: 'There are many variations',
    subtitle: '3 bài giảng / 2 tài liệu',
    lessons: [],
  ),
  Section(
    index: 4,
    title: 'There are many variations',
    subtitle: '5 bài giảng / 6 bài tập',
    lessons: [],
  ),
];
