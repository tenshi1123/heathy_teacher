import 'package:flutter/material.dart';
import 'package:heathy_teacher/screens/drawer/chi_tiet_uu_dai_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:intl/intl.dart';

class UuDaiScreen extends StatefulWidget {
  const UuDaiScreen({super.key});

  @override
  State<UuDaiScreen> createState() => _UuDaiScreenState();
}

class _UuDaiScreenState extends State<UuDaiScreen> {
  bool _isLoading = true;
  List<InfoUuDaiModel> _infoList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await HomeRepo().getInfoUuDai();
      if (mounted) {
        setState(() {
          _infoList = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat("HH:mm:ss dd/MM/yyyy").format(dateTime);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      appBar: AppBar(
        backgroundColor: mainGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Thông tin ưu đãi',
          style: defaultText16B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: mainDarkGreen))
            : _infoList.isEmpty
            ? Center(
                child: Image.asset('assets/images/uudai.png', height: 200.h),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                itemCount: _infoList.length,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Divider(color: Colors.grey.shade300, height: 1),
                ),
                itemBuilder: (context, index) {
                  final item = _infoList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChiTietUuDaiScreen(initialModel: item),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent, // to make the whole row clickable
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("🎁", style: TextStyle(fontSize: 20.sp)),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  item.name ?? "",
                                  style: defaultText18B.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.subdirectory_arrow_right,
                                color: const Color(0xFF8692A6),
                                size: 18.sp,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  _formatDate(item.createdAt),
                                  style: defaultText14M.copyWith(
                                    color: const Color(0xFF8692A6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
