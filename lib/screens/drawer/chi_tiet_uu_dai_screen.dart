import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:intl/intl.dart';

class ChiTietUuDaiScreen extends StatefulWidget {
  final InfoUuDaiModel initialModel;

  const ChiTietUuDaiScreen({super.key, required this.initialModel});

  @override
  State<ChiTietUuDaiScreen> createState() => _ChiTietUuDaiScreenState();
}

class _ChiTietUuDaiScreenState extends State<ChiTietUuDaiScreen> {
  bool _isLoading = true;
  InfoUuDaiModel? _detailModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.initialModel.id == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
    
    try {
      final data = await HomeRepo().getDetailInfo(widget.initialModel.id!);
      if (mounted) {
        setState(() {
          _detailModel = data;
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
    final modelToDisplay = _detailModel ?? widget.initialModel;
    
    return Scaffold(
      backgroundColor: mainGreen,
      appBar: AppBar(
        backgroundColor: mainGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          modelToDisplay.name ?? 'Chi tiết ưu đãi',
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
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: mainDarkGreen))
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (modelToDisplay.content != null && modelToDisplay.content!.isNotEmpty)
                      HtmlWidget(modelToDisplay.content!)
                    else
                      Center(
                        child: Text(
                          'Chưa có nội dung',
                          style: defaultText14M,
                        ),
                      ),
                    SizedBox(height: 24.h),
                    if (modelToDisplay.createdAt != null && modelToDisplay.createdAt!.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatDate(modelToDisplay.createdAt),
                          style: defaultText14Re.copyWith(
                            color: const Color(0xFF8692A6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
