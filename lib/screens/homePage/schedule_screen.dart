import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/utils.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late final ValueNotifier<List<ScheduleModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late List<ScheduleModel> _listLichHoc;
  final Map<DateTime, List<ScheduleModel>> _events = {};
  final Set<String> _loadedMonths = {};
  String? selectedHinhThuc;
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _listLichHoc = [];
    _selectedEvents = ValueNotifier(
      _getEventsForRange(
        DateTime(_focusedDay.year, _focusedDay.month, 1),
        DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
      ),
    );
    _fetchEventsForMonth(_focusedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _fetchEventsForMonth(DateTime date) async {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    if (_loadedMonths.contains(key)) return;

    // final fetchedEvents = await DiemdanhRepo().getScheduleList(
    //   DateFormat('dd-MM-yyyy').format(start),
    //   DateFormat('dd-MM-yyyy').format(end),
    // );
    // CustomerRepo().getListTkb(
    //     day1: DateFormat('dd-MM-yyyy').format(start),
    //     day2: DateFormat('dd-MM-yyyy').format(end));

    // if (fetchedEvents.isEmpty) return;
    // setState(() {
    //   for (final e in fetchedEvents) {
    //     final day = DateTime(
    //         e.createdDate.year, e.createdDate.month, e.createdDate.day);
    //     _events.putIfAbsent(day, () => []).add(e);
    //   }
    //   _loadedMonths.add(key);
    //   if (_selectedDay != null) {
    //     _selectedEvents.value = _events[_selectedDay!] ?? [];
    //   }
    // });
  }

  Future<void> getSchedule({
    required String dayStart,
    required String dayEnd,
  }) async {
    _listLichHoc = await CourseRepo().getListEventSchedule();
    _selectedEvents.value = _listLichHoc;
  }

  List<ScheduleModel> _getEventsForDay(DateTime day) {
    // Implementation example
    getSchedule(
      dayStart: DateFormat('yyyy-MM-dd').format(day),
      dayEnd: DateFormat('yyyy-MM-dd').format(day),
    );
    return _listLichHoc;
  }

  List<ScheduleModel> _getEventsForRange(DateTime start, DateTime end) {
    getSchedule(
      dayStart: DateFormat('yyyy-MM-dd').format(start),
      dayEnd: DateFormat('yyyy-MM-dd').format(end),
    );
    return _listLichHoc;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
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
          "Lịch học",
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
        decoration: BoxDecoration(
          color: mainDarkGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                child: HinhThucHocDropdown(
                  value: selectedHinhThuc,
                  onChanged: (value) {
                    setState(() {
                      selectedHinhThuc = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                //height: 403.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                width: 375.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(28.r)),
                ),
                child: TableCalendar<ScheduleModel>(
                  locale: 'vi_VI',
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  headerStyle: HeaderStyle(titleTextStyle: defaultText16M),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: defaultText14M,
                    weekendStyle: defaultText14M.copyWith(color: Colors.red),
                  ),
                  daysOfWeekHeight: 36.h,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: (day) {
                    final d = DateTime(day.year, day.month, day.day);
                    return _events[d] ?? [];
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      List<ScheduleModel> list1;
                      if (selectedHinhThuc == 'calendar') {
                        list1 = events
                            .where((item) => item.title != null)
                            .toList();
                      } else if (selectedHinhThuc ==
                          'customer_zoom_google_offline') {
                        list1 = events
                            .where((item) => item.title == null)
                            .toList();
                      } else if (selectedHinhThuc ==
                          'Lịch học phụ đạo - học bù') {
                        list1 = [];
                      } else {
                        list1 = events;
                      }

                      return list1.isNotEmpty
                          ? _buildEventsMarkerNum(list1)
                          : const SizedBox();
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: true,
                    defaultTextStyle: defaultText14M,
                    weekendTextStyle: defaultText14M.copyWith(
                      color: Colors.red,
                    ),
                    todayTextStyle: defaultText14M.copyWith(
                      color: Colors.white,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: mainDarkGreen,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    rangeStartDecoration: BoxDecoration(
                      color: mainDarkGreen,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: mainDarkGreen,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    rangeHighlightColor: mainDarkGreen.withValues(alpha: 0.1),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: mainDarkGreen.withValues(alpha: 0.3),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    _fetchEventsForMonth(focusedDay);
                    _selectedEvents.value = _getEventsForRange(
                      DateTime(_focusedDay.year, _focusedDay.month, 1),
                      DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  'Lịch học của bạn',
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.h),
              ValueListenableBuilder<List<ScheduleModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  List<ScheduleModel> list1;
                  if (selectedHinhThuc == 'calendar') {
                    list1 = value.where((item) => item.title != null).toList();
                  } else if (selectedHinhThuc ==
                      'customer_zoom_google_offline') {
                    list1 = value.where((item) => item.title == null).toList();
                  } else if (selectedHinhThuc == 'Lịch học phụ đạo - học bù') {
                    list1 = [];
                  } else {
                    list1 = value;
                  }
                  return list1.isEmpty
                      ? Center(
                          child: Text(
                            'Không có lịch học',
                            style: defaultText16B,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: list1.length,
                          itemBuilder: (context, index) {
                            return ItemTableCalender(model: list1[index]);
                          },
                        );
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEventsMarkerNum(List events) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [buildCalendarDayMarker(backColor: mainDarkGreen)],
  );
}

AnimatedContainer buildCalendarDayMarker({required Color backColor}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    decoration: BoxDecoration(shape: BoxShape.circle, color: backColor),
    width: 8.w,
    height: 8.h,
  );
}

class ItemTableCalender extends StatefulWidget {
  final ScheduleModel model;
  const ItemTableCalender({super.key, required this.model});

  @override
  State<ItemTableCalender> createState() => _ItemTableCalenderState();
}

class _ItemTableCalenderState extends State<ItemTableCalender> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: ((context) => DetailLessonScreen(
        //           typeLearn: widget.model.typeLearn,
        //           checkinOffId: widget.model.checkinOffId ?? '',
        //           meetingId: widget.model.meetingId ?? '',
        //         )),
        //   ),
        // );
      },
      child: _isLoading
          ? SizedBox(
              height: 136.h,
              width: 343.w,
              child: Center(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: const CircularProgressIndicator(),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.only(
                top: 16.h,
                bottom: 10.h,
                left: 16.w,
                right: 16.w,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              width: 343.w,
              //height: 136.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff273D8C).withValues(alpha: 0.12),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        ),
                        child: Text(
                          'Ngày ${widget.model.startTime?.day}, Tháng ${widget.model.startTime?.month}',
                          style: defaultText14B.copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SvgPicture.asset(
                        'assets/icons/class_icon.svg',
                        width: 16.w,
                        height: 16.h,
                        colorFilter: ColorFilter.mode(
                          Colors.blue,
                          BlendMode.srcIn,
                        ),
                      ),
                      if (widget.model.phongHocName != null)
                        Expanded(
                          child: Text(
                            '${widget.model.phongHocName} ${widget.model.cosoName}',
                            style: defaultText14SB,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(widget.model.name, style: defaultText16B),
                  if (widget.model.title != null)
                    Text('${widget.model.title}', style: defaultText16M),
                  if (widget.model.title == null)
                    Text(widget.model.address ?? '', style: defaultText16M),
                  Text(
                    '${widget.model.startTime?.hour}:${widget.model.startTime?.minute} - ${widget.model.endTime?.hour}:${widget.model.endTime?.minute}',
                    style: defaultText14M,
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
    );
  }
}

List<ScheduleModel> mockSchedules = [
  // Mẫu 1: Điền đầy đủ tất cả các thông tin
  ScheduleModel(
    id: 'SCH001',
    name: 'Lịch dạy Toán Cao Cấp',
    title: 'Đại số tuyến tính',
    className: 'KTPM-K60',
    nameLesson: 'Bài 1: Ma trận và Định thức',
    address:
        'Sảnh A5, Diamond Alnata Plus, 02 Đường N 1, Sơn Kỳ, Tân Phú, Thành phố Hồ Chí Minh',
    courseScheduleName: 'Học kỳ 1 - 2026',
    cosoName: 'Cơ sở chính',
    phongHocName: 'Phòng D3-501',
    gvStatus: 'Đã xác nhận',
    startTime: DateTime(2026, 6, 30, 8, 0), // 8:00 AM, 30/06/2026
    endTime: DateTime(2026, 6, 30, 10, 15), // 10:15 AM, 30/06/2026
  ),

  // Mẫu 2: Chỉ điền các trường bắt buộc và một vài trường cần thiết
  ScheduleModel(
    id: 'SCH002',
    name: 'Họp bộ môn',
    title: 'Họp đánh giá giữa kỳ',
    phongHocName: 'Phòng họp Tầng 3',
    startTime: DateTime(2026, 7, 1, 14, 0), // 2:00 PM, 01/07/2026
    endTime: DateTime(2026, 7, 1, 16, 0), // 4:00 PM, 01/07/2026
    // Các trường khác sẽ tự động là null
  ),

  // Mẫu 3: Dữ liệu môn học ngoại ngữ, có trạng thái giảng viên khác
  ScheduleModel(
    id: 'SCH003',
    name: 'Lịch dạy Tiếng Anh',
    title: 'Tiếng Anh giao tiếp cơ bản',
    className: 'TA1-01',
    nameLesson: 'Unit 5: Work and Play',
    courseScheduleName: 'Khóa hè 2026',
    cosoName: 'Cơ sở 2 - Cầu Giấy',
    phongHocName: 'Phòng A2-202',
    gvStatus: 'Chờ điểm danh',
    startTime: DateTime(2026, 7, 2, 18, 0), // 6:00 PM, 02/07/2026
    endTime: DateTime(2026, 7, 2, 20, 0), // 8:00 PM, 02/07/2026
  ),
];
