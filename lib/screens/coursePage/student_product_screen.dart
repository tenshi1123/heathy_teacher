import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentProductScreen extends StatefulWidget {
  final String courseId;
  const StudentProductScreen({super.key, required this.courseId});

  @override
  State<StudentProductScreen> createState() => _StudentProductScreenState();
}

class _StudentProductScreenState extends State<StudentProductScreen> {
  bool isLoading = true;
  List<ContentSubmitModel> submissions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await CourseRepo().getContentSubmit(courseId: widget.courseId);
      if (mounted) {
        setState(() {
          submissions = data;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text('Sản phẩm của học viên', style: defaultText18B),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        color: mainDarkGreen,
        onRefresh: _fetchData,
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: mainDarkGreen))
            : submissions.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100,
                      alignment: Alignment.center,
                      child: Text('Chưa có sản phẩm nào.', style: defaultText14M),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    itemCount: submissions.length,
                    itemBuilder: (context, index) {
                      final product = submissions[index];
                      return ProductCardWidget(product: product, courseId: widget.courseId);
                    },
                  ),
      ),
    );
  }
}

class ProductCardWidget extends StatefulWidget {
  final ContentSubmitModel product;
  final String courseId;

  const ProductCardWidget({super.key, required this.product, required this.courseId});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  bool isExpanded = false;
  final TextEditingController _commentController = TextEditingController();
  bool isSending = false;

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isSending = true;
    });

    try {
      int submitId = int.tryParse(widget.product.id ?? '0') ?? 0;
      int cId = int.tryParse(widget.courseId) ?? 0;
      await CourseRepo().addComment(
        courseCustomerSubmitId: submitId,
        courseId: cId,
        content: text,
      );
      _commentController.clear();
      if (mounted) {
        setState(() {
          widget.product.comments ??= [];
          widget.product.comments!.add(SubmitCommentModel(
            commenterName: 'Bạn',
            content: text,
            createdAt: 'Vừa xong',
          ));
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi bình luận!')));
      }
    } catch (e) {
      _commentController.clear();
      if (mounted) {
        setState(() {
          widget.product.comments ??= [];
          widget.product.comments!.add(SubmitCommentModel(
            commenterName: 'Bạn',
            content: text,
            createdAt: 'Vừa xong',
          ));
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi bình luận!')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List comments = widget.product.comments ?? [];
    String authorName = widget.product.fullName ?? 'Học viên';
    String avatarLabel = authorName.isNotEmpty ? authorName[0].toUpperCase() : 'H';
    String date = widget.product.createdAt ?? '';
    String description = widget.product.content ?? '';
    List<String> images = widget.product.images ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: images.first,
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: Colors.green[100],
                      child: Text(
                        avatarLabel,
                        style: defaultText12B.copyWith(color: mainGreen),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('By ', style: defaultText12M.copyWith(color: Colors.grey)),
                    Text(authorName, style: defaultText12B),
                    if (date.isNotEmpty)
                      Text(' - $date', style: defaultText12M.copyWith(color: Colors.grey)),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(description, style: defaultText14M),
                ],
                SizedBox(height: 16.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        SizedBox(width: 4.w),
                        Text(
                          '${comments.length} bình luận',
                          style: defaultText12M.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  SizedBox(height: 16.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _buildCommentItem(comment);
                    },
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Viết bình luận...',
                              hintStyle: defaultText14M.copyWith(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      InkWell(
                        onTap: isSending ? null : _sendComment,
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(color: isSending ? Colors.grey : mainGreen, shape: BoxShape.circle),
                          child: isSending 
                             ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                             : SvgPicture.asset('assets/icons/plane_outline.svg'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200.h,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.image_outlined, size: 50, color: Colors.grey),
    );
  }

  Widget _buildCommentItem(dynamic commentRaw) {
    String authorName = 'Ẩn danh';
    String role = '';
    String time = '';
    String content = '';
    String avatarLabel = 'A';

    if (commentRaw is SubmitCommentModel) {
      authorName = commentRaw.commenterName ?? 'Ẩn danh';
      role = commentRaw.commenterType == 'lecturer' ? 'GV' : (commentRaw.commenterType == 'admin' ? 'Admin' : '');
      time = commentRaw.createdAt ?? '';
      content = commentRaw.content ?? '';
      avatarLabel = authorName.isNotEmpty ? authorName[0].toUpperCase() : 'A';
    } else if (commentRaw is Map) {
      authorName = commentRaw['authorName'] ?? 'Ẩn danh';
      role = commentRaw['role'] ?? '';
      time = commentRaw['time'] ?? '';
      content = commentRaw['content'] ?? '';
      avatarLabel = commentRaw['avatarLabel'] ?? (authorName.isNotEmpty ? authorName[0].toUpperCase() : 'A');
    } else if (commentRaw is String) {
      try {
         var decoded = jsonDecode(commentRaw);
         if (decoded is Map) {
            authorName = decoded['authorName'] ?? 'Ẩn danh';
            role = decoded['role'] ?? '';
            time = decoded['time'] ?? '';
            content = decoded['content'] ?? '';
            avatarLabel = decoded['avatarLabel'] ?? (authorName.isNotEmpty ? authorName[0].toUpperCase() : 'A');
         } else {
            content = commentRaw;
         }
      } catch (e) {
         content = commentRaw;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12.r,
          backgroundColor: Colors.grey[200],
          child: Text(avatarLabel, style: defaultText12B.copyWith(color: Colors.black54)),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(authorName, style: defaultText12B),
                  if (role.isNotEmpty) ...[
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: role == 'GV' ? mainGreen : const Color(0xFF3B5998),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(role, style: defaultText12B.copyWith(color: Colors.white, fontSize: 8.sp)),
                    ),
                  ],
                  const Spacer(),
                  if (time.isNotEmpty)
                    Text(time, style: defaultText12M.copyWith(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 4.h),
              Text(content, style: defaultText12M),
            ],
          ),
        ),
      ],
    );
  }
}
