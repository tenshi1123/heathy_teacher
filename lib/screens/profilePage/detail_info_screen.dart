import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:image_picker/image_picker.dart';

class DetailInfoScreen extends StatefulWidget {
  const DetailInfoScreen({super.key, required this.model});
  final UserModel? model;
  @override
  State<DetailInfoScreen> createState() => _DetailInfoScreenState();
}

class _DetailInfoScreenState extends State<DetailInfoScreen> {
  bool isFilled = false;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  TextEditingController birthdayController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.model?.fullName);
    emailController = TextEditingController(text: widget.model?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 375.w,
              height: 200.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image(
                      width: 375.w,
                      height: 200.h,
                      image: const AssetImage(
                        'assets/images/person_background.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 40.h,
                    child: SizedBox(
                      width: 375.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 16.w),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Thông tin tài khoản',
                                style: defaultText16B.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              SizedBox(width: 16.w),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 375.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 138.w,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.model!.img!.contains('https://')
                              ? '${widget.model!.img}'
                              : 'https://lms.cogiaohealthy.vn/${widget.model!.img}',
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                          // Hiển thị Icon mặc định khi lỗi tải ảnh
                          errorBuilder:
                              (
                                BuildContext context,
                                Object exception,
                                StackTrace? stackTrace,
                              ) {
                                return Container(
                                  width: 80.w,
                                  height: 80.h,
                                  color: Colors
                                      .grey[200], // Màu nền của icon mặc định
                                  child: Icon(
                                    Icons
                                        .person, // Hoặc Icons.error_outline tuỳ ý bạn
                                    size: 40.w,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                          // (Tuỳ chọn) Hiển thị vòng xoay loading trong lúc đang tải ảnh
                          loadingBuilder:
                              (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child; // Đã tải xong
                                }
                                return Container(
                                  width: 80.w,
                                  height: 80.h,
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                        ),
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 50.r,
                    //   backgroundImage: AssetImage(avatars[selectedIndex]["img"]!),
                    // ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 210.w,
                    child: GestureDetector(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: Container(
                              height: 166.h,
                              width: 343.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Nút Tải ảnh lên
                                    buildUploadOption(
                                      icon: Icons.image_outlined,
                                      text: "Tải ảnh lên",
                                      onTap: () {
                                        // Xử lý tải ảnh lên
                                        pickImageFromGallery1(context);
                                      },
                                    ),
                                    SizedBox(width: 56.w),
                                    // Nút Chụp ảnh
                                    buildUploadOption(
                                      icon: Icons.camera_alt_outlined,
                                      text: "Chụp ảnh",
                                      onTap: () {
                                        pickImageFromCamera1(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            MyTextFormField(
              labelText: 'Họ và tên',
              controller: fullNameController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  isFilled = true;
                });
              },
              hasIcon: true,
            ),
            MyTextFormField(
              labelText: 'Số điện thoại',
              controller: TextEditingController(
                text: widget.model?.phone ?? '',
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {},
              hasIcon: false,
            ),
            MyTextFormField(
              labelText: 'Email',
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  isFilled = true;
                });
              },
              hasIcon: true,
            ),
            buildLabeledField(
              label: 'Sinh nhật',
              controller: birthdayController,
              context: context,
              isDateField: true,
            ),
            SizedBox(height: 200.h),
            GestureDetector(
              onTap: isFilled
                  ? () async {
                      String message = await HomeRepo().changeInfo(
                        name: fullNameController.text,
                        email: emailController.text,
                        dob: '',
                        phone: '',
                      );
                      if (!context.mounted) return;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(message, style: defaultText16B),
                            actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              child: Container(
                height: 52.h,
                width: 343.w,
                decoration: BoxDecoration(
                  color: isFilled
                      ? mainGreen
                      : const Color(0xff292929).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                ),
                child: Center(
                  child: Text(
                    'Cập nhật',
                    style: defaultText16B.copyWith(
                      color: isFilled
                          ? Colors.white
                          : const Color(0xff292929).withValues(alpha: 0.48),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextFormField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool hasIcon;

  const MyTextFormField({
    super.key,
    required this.labelText,
    this.initialValue = '',
    this.controller,
    this.keyboardType,
    this.onChanged,
    required this.hasIcon,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      //height: 66.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        border: Border.all(
          color: (_focusNode.hasFocus && widget.hasIcon)
              ? mainOrange
              : const Color(0xff292929).withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText, style: defaultText16Re),
          SizedBox(
            height: 30.h,
            width: 300.w,
            child: TextFormField(
              readOnly: !widget.hasIcon,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              style: defaultText16M,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 1),
                suffixIcon: widget.hasIcon
                    ? !_focusNode.hasFocus
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: SvgPicture.asset(
                                'assets/icons/pencil.svg',
                                height: 10.h,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: SvgPicture.asset(
                                  'assets/icons/unfocus.svg',
                                  height: 10.h,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )
                    : const SizedBox(),
              ),
            ),
          ),
          // SizedBox(
          //   height: 8.h,
          // ),
        ],
      ),
    );
  }
}

Widget buildUploadOption({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          radius: 26.r,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 52.h,
            width: 52.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightBlue,
              // gradient: LinearGradient(
              //   colors: [
              //     Color(0xff25AAE1),
              //     Color(0xff004071),
              //   ],
              // ),
            ),
            child: Icon(icon, size: 26.r, color: Colors.white),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87)),
    ],
  );
}

Future pickImageFromGallery1(BuildContext context) async {
  final returnedImage = await ImagePicker().pickMultiImage();

  if (!context.mounted) return;
  if (returnedImage.isNotEmpty) {
    List<File> photos = List<File>.from(returnedImage.map((e) => File(e.path)));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text('Avatar', style: defaultText14M),
                          const Spacer(),
                          const CloseButton(color: Colors.black),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                      ...photos.asMap().entries.map((entry) {
                        File photo = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  photo,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Positioned(
                              //   top: 8,
                              //   right: 8,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       setStateDialog(() {
                              //         photos.removeAt(index);
                              //       });
                              //     },
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         color: Colors.black54,
                              //         borderRadius: BorderRadius.circular(8),
                              //       ),
                              //       padding: const EdgeInsets.all(4),
                              //       child: const Icon(
                              //         Icons.remove,
                              //         color: Colors.white,
                              //         size: 20,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }),
                      InkWell(
                        onTap: () async {
                          //CustomerRepo().changeAvatar(photos.last);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đổi ảnh đại diện thành công!'),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 16.w,
                            bottom: 26.h,
                            top: 16.h,
                            right: 16.w,
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 16.w,
                            vertical: 12.w,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF25AAE1), Color(0xFF004071)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Center(
                            child: Text(
                              'Xác nhận đổi ảnh đại diện',
                              style: defaultText14B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> pickImageFromCamera1(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  List<File> photos = [];

  final pickedImage = await picker.pickImage(source: ImageSource.camera);
  if (!context.mounted) return;
  if (pickedImage != null) {
    photos.add(File(pickedImage.path));

    showDialog(
      context: context, // ← giờ đã được truyền vào
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8),
                          Text('Ảnh đại diện', style: defaultText16B),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...photos.asMap().entries.map((entry) {
                        File photo = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  photo,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          //await CustomerRepo().changeAvatar(photos.last);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đổi ảnh đại diện thành công!'),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 16.w,
                            bottom: 26.h,
                            top: 16.h,
                            right: 16.w,
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 16.w,
                            vertical: 12.w,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF25AAE1), Color(0xFF004071)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Center(
                            child: Text(
                              'Xác nhận gửi yêu cầu',
                              style: defaultText14B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildLabeledField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  bool isDateField = false,
  void Function(DateTime)? onDateSelected,
}) {
  return Container(
    width: 343.w,
    //height: 66.h,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      color: Colors.white,
      border: Border.all(color: Color(0xff292929).withAlpha(50), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: defaultText16Re),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isDateField
              ? () async {
                  FocusScope.of(context).unfocus();
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (!context.mounted) return;
                  if (selectedDate != null) {
                    controller.text =
                        '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}';
                    if (onDateSelected != null) onDateSelected(selectedDate);
                  }
                }
              : null,
          child: AbsorbPointer(
            absorbing: isDateField,
            child: TextField(
              controller: controller,
              style: defaultText14M.copyWith(color: colorText),
              decoration: const InputDecoration.collapsed(hintText: ''),
            ),
          ),
        ),
      ],
    ),
  );
}
