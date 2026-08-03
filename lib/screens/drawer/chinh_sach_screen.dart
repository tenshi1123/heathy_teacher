import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';

import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';

class ChinhSachScreen extends StatefulWidget {
  const ChinhSachScreen({super.key});

  @override
  State<ChinhSachScreen> createState() => _ChinhSachScreenState();
}

class _ChinhSachScreenState extends State<ChinhSachScreen> {
  @override
  void initState() {
    super.initState();
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
          'Chính sách',
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: Column(children: [Expanded(child: ListChinhSach())]),
      ),
    );
  }
}

class ListChinhSach extends StatefulWidget {
  const ListChinhSach({super.key});

  @override
  State<ListChinhSach> createState() => _ListChinhSachState();
}

class _ListChinhSachState extends State<ListChinhSach> {
  int selectedTab = 0;
  bool isLoading = true;
  PolicyModel? policy;

  @override
  void initState() {
    super.initState();
    _fetchPolicy();
  }

  Future<void> _fetchPolicy() async {
    try {
      final fetchedPolicy = await HomeRepo().getPolicy();
      if (mounted) {
        setState(() {
          policy = fetchedPolicy;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Thanh chọn ---
        Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xffF2E8E8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedTab == 0
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chính sách học viên",
                          style: defaultText14B.copyWith(
                            color: selectedTab == 0
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedTab == 1
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chính sách tích điểm",
                          style: defaultText14B.copyWith(
                            color: selectedTab == 1
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading 
            ? Expanded(child: Center(child: CircularProgressIndicator()))
            : selectedTab == 0
                ? Expanded(child: OnlinePolicyScreen(content: policy?.policyCustomer?.content ?? ''))
                : Expanded(child: RewardPolicyScreen(content: policy?.policyPoint?.content ?? '')),
      ],
    );
  }

}

class RewardPolicyScreen extends StatelessWidget {
  final String content;
  const RewardPolicyScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: HtmlWidget(
        content,
        textStyle: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class OnlinePolicyScreen extends StatelessWidget {
  final String content;
  const OnlinePolicyScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: HtmlWidget(
        content,
        textStyle: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
