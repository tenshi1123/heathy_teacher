import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/chat_models.dart';
import 'package:heathy_teacher/repo/chat_repo.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:heathy_teacher/utils/widget/custom_video_player.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.model,
    this.initialMessages,
    this.courseTypeId,
    this.courseScheduleId,
  });
  final LecturerModel model;
  final String? courseTypeId;
  final String? courseScheduleId;
  final List<MessageModel>? initialMessages;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<File> photos = <File>[];
  String id = '';
  final ImagePicker _picker = ImagePicker();
  Future<void> _showCameraOptions() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt, color: mainDarkGreen),
                title: const Text('Chụp ảnh'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 90,
                  );
                  if (file != null) {
                    setState(() {
                      photos.add(File(file.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: mainDarkGreen),
                title: const Text('Quay video'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? file = await _picker.pickVideo(
                    source: ImageSource.camera,
                  );
                  if (file != null) {
                    setState(() {
                      photos.add(File(file.path));
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final returnedMedia = await ImagePicker().pickMultipleMedia();
    if (!mounted) return;
    photos.addAll(List<File>.from((returnedMedia).map((e) => File(e.path))));
    setState(() {});
  }

  bool _isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.mkv');
  }

  Future<void> _getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id_user') ?? '';
    setState(() {
      // Cập nhật trạng thái để hiển thị dữ liệu mới
    });
  }

  bool isLoading = true;
  List<MessageModel> listMessage = [];
  Future<void> fetchData() async {
    if (widget.initialMessages != null) {
      setState(() {
        listMessage = List.from(widget.initialMessages!.reversed);
        isLoading = false;
      });
      return;
    }

    try {
      final response = await ChatRepo().getListMessage(
        lectureId: widget.model.userId ?? '',
      );
      setState(() {
        listMessage = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    //listMessage = widget.model.messages;
    _getIdUser();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.model.avatar ?? '',
                height: 42.r,
                width: 42.r,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    height: 42.r,
                    width: 42.r,
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade600,
                      size: 24.r,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              width: 230.w,
              child: Text(
                widget.model.fullName ?? 'Không xác định',
                style: defaultText18B.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        toolbarHeight: 60.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: [backGroundGreen.withValues(alpha: 0.8), backGroundGreen],
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.phone,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       _makePhoneCall('19008978');
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: listMessage.length,
              itemBuilder: (context, index) {
                final current = listMessage[index];
                final previous = index > 0 ? listMessage[index - 1] : null;

                bool showTimeLabel = false;
                String timeLabel = '';

                if (previous == null) {
                  showTimeLabel = true;
                  timeLabel = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(current.createdAt);
                } else {
                  final difference = current.createdAt.difference(
                    previous.createdAt,
                  );
                  if (current.createdAt.day != previous.createdAt.day) {
                    showTimeLabel = true;
                    timeLabel = DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(current.createdAt);
                  } else if (difference.inHours >= 1) {
                    showTimeLabel = true;
                    timeLabel = DateFormat('HH:mm').format(current.createdAt);
                  }
                }

                return Column(
                  children: [
                    // 🕓 Thời gian giữa tin nhắn — fade-in nhẹ
                    if (showTimeLabel)
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            timeLabel,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    // 💬 Tin nhắn
                    Align(
                      alignment: (current.type == "0" || current.type == '1')
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 6.h),
                        constraints: BoxConstraints(maxWidth: 300.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: (current.type == "0" || current.type == '1')
                              ? backGroundGreen
                              : Colors.grey.shade200,
                        ),
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (current.content.isNotEmpty)
                              Text(
                                current.content,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color:
                                      (current.type == "0" ||
                                          current.type == '1')
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            if (current.image.isNotEmpty)
                              ...current.image.map((url) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: current.content.isNotEmpty ? 8.h : 0,
                                  ),
                                  constraints: BoxConstraints(maxHeight: 200.h),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: _isVideo(url)
                                        ? GestureDetector(
                                            onTap: () async {
                                              if (url.startsWith('http')) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomVideoPlayer(
                                                      url: url,
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomVideoPlayer(
                                                      url: url,
                                                      isLocal: true,
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 150.h,
                                              width: 200.w,
                                              color: Colors.black12,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.videocam,
                                                    size: 50.r,
                                                    color: mainDarkGreen,
                                                  ),
                                                  if (url.startsWith('http'))
                                                    Positioned(
                                                      bottom: 10.h,
                                                      child: Text(
                                                        'Nhấn để xem',
                                                        style: defaultText12M
                                                            .copyWith(
                                                              color:
                                                                  mainDarkGreen,
                                                            ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : (url.startsWith('http')
                                              ? CachedNetworkImage(
                                                  imageUrl: url,
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) {
                                                        return Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey,
                                                        );
                                                      },
                                                )
                                              : Image.file(
                                                  File(url),
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey,
                                                        );
                                                      },
                                                )),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.w, bottom: 20.h, top: 10.h),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _showCameraOptions();
                      },
                      child: SvgPicture.asset('assets/icons/camera_icon.svg'),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: SvgPicture.asset('assets/icons/picture_icon.svg'),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: state1,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Nhập tin nhắn...",
                            hintStyle: TextStyle(
                              color: Colors.black.withValues(alpha: 0.95),
                            ),
                            border: InputBorder.none,
                          ),
                          style: defaultText14M,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: () async {
                        ChatRepo().sendChatLecturers(
                          widget.courseScheduleId ?? '',
                          messageController.text,
                          widget.courseTypeId ?? '',
                          photo: photos.isNotEmpty ? photos.first : null,
                        );
                        setState(() {
                          listMessage.insert(
                            listMessage.length,
                            MessageModel(
                              content: messageController.text,
                              image: photos.map((e) => e.path).toList(),
                              createdAt: DateTime.now(),
                              id: '',
                              chatMessageId: '',
                              customerId: '',
                              lectureId: '',
                              type: "0",
                            ),
                          );
                          photos.clear();
                        });
                        messageController.clear();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Tin nhắn đã được gửi'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text(
                                    'ok',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: mainOrange,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop((_) => false);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset('assets/icons/plane_outline.svg'),
                    ),
                    SizedBox(width: 16.w),
                  ],
                ),
                if (photos.isNotEmpty)
                  Container(
                    height: 90.h,
                    margin: EdgeInsets.only(top: 10.h),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 15.w, top: 10.h),
                              height: 70.h,
                              width: 70.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: _isVideo(photos[index].path)
                                    ? null
                                    : DecorationImage(
                                        image: FileImage(photos[index]),
                                        fit: BoxFit.cover,
                                      ),
                                color: _isVideo(photos[index].path)
                                    ? Colors.black12
                                    : null,
                              ),
                              child: _isVideo(photos[index].path)
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomVideoPlayer(
                                              url: photos[index].path,
                                              isLocal: true,
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.videocam,
                                        color: mainDarkGreen,
                                        size: 30.r,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 5.w,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    photos.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
