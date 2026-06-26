import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/chat_models.dart';
import 'package:heathy_teacher/repo/chat_repo.dart';
import 'package:heathy_teacher/screens/chatPage/chat_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  List<LecturerModel> listLecturers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await ChatRepo().getListLecture();
      setState(() {
        listLecturers = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        listLecturers = [];
        isLoading = false;
      });
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
          'Chat',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {
              _makePhoneCall('19008978');
            },
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
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : listLecturers.isEmpty
            ? Center(child: Text('Không có dữ liệu', style: defaultText14M))
            : ListView.builder(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: 80.w,
                  top: 10.h, // Added top padding replacing SizedBox
                ),
                physics: const ClampingScrollPhysics(),
                itemCount: listLecturers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: ConversationItem(model: listLecturers[index]),
                  );
                },
              ),
      ),
    );
  }
}

class ConversationItem extends StatelessWidget {
  const ConversationItem({super.key, required this.model});
  final LecturerModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(model: model)),
        );
      },
      child: Container(
        height: 73.h,
        width: 350.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: Image.network(
                model.avatar ?? '',
                height: 42.r,
                width: 42.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 42.r,
                    width: 42.r,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.person, color: Colors.grey.shade600, size: 24.r),
                  );
                },
              ),
            ),
            SizedBox(
              width: 220.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.fullName ?? 'không có dữ liệu',
                    style: defaultText14B,
                  ),
                  //Text('Tôi có thể giúp gì cho bạn', style: defaultText12M),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
