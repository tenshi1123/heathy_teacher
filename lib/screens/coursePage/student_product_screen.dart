import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class StudentProductScreen extends StatefulWidget {
  const StudentProductScreen({super.key});

  @override
  State<StudentProductScreen> createState() => _StudentProductScreenState();
}

class _StudentProductScreenState extends State<StudentProductScreen> {
  // Mock data based on the provided image
  final List<Map<String, dynamic>> mockProducts = [
    {
      'images': [
        'assets/images/default_image.png', // We'll use a placeholder or network image if available. Let's use network images for demo.
      ],
      'authorName': 'HVG TEST',
      'date': '15/07/2026',
      'avatarLabel': 'H',
      'description': '',
      'comments': [
        {
          'authorName': 'HVG DTLOAN SALE',
          'role': 'GV',
          'time': '17:01 15/07/2026',
          'content': 'chị giỏi quá, cứ thế phát huy ạ',
          'avatarLabel': 'G',
        },
        {
          'authorName': 'HVG DTLOAN SALE',
          'role': 'GV',
          'time': '17:38 15/07/2026',
          'content': 'oke oke',
          'avatarLabel': 'G',
        },
        {
          'authorName': 'HVG ADMIN 123',
          'role': 'Admin',
          'time': '09:23 16/07/2026',
          'content': 'xxxx',
          'avatarLabel': 'A',
        },
        {
          'authorName': 'HVG TEST',
          'role': '',
          'time': '09:47 16/07/2026',
          'content': 'mình cảm ơn ạ',
          'avatarLabel': 'H',
        },
      ],
    },
    {
      'images': ['assets/images/default_image.png'],
      'authorName': 'Đỗ Loan',
      'date': '15/07/2026',
      'avatarLabel': 'D',
      'description':
          'Em đã làm theo công thức của cô và cho ra thành phẩm rất sánh mịn, cả nhà ai cũng khen ngon, xin cảm ơn cô giáo ạ, đây là thành phẩm sữa hạt bí đỏ',
      'comments': [
        {
          'authorName': 'HVG TEST',
          'role': '',
          'time': '13:42 15/07/2026',
          'content':
              'Bạn giỏi quá, mình làm phải đến lần thứ 3 mới được ạ, may có cô giáo hỗ trợ ạ',
          'avatarLabel': 'H',
        },
        {
          'authorName': 'HVG ADMIN 123',
          'role': 'Admin',
          'time': '17:39 15/07/2026',
          'content': 'quá tuyệt vời',
          'avatarLabel': 'A',
        },
      ],
    },
    {
      'images': ['assets/images/default_image.png'],
      'authorName': 'HVG TEST',
      'date': '14/07/2026',
      'avatarLabel': 'H',
      'description': 'em nộp bài nhé ạ',
      'comments': [
        {
          'authorName': 'HVG ADMIN 123',
          'role': 'Admin',
          'time': '09:59 15/07/2026',
          'content': 'giỏi quá a !!!',
          'avatarLabel': 'A',
        },
        {
          'authorName': 'HVG DTLOAN SALE',
          'role': 'GV',
          'time': '12:58 15/07/2026',
          'content': 'sản phẩm trông ngon quá, chị tiếp tục phát huy nhé !!!',
          'avatarLabel': 'G',
        },
        {
          'authorName': 'HVG TEST',
          'role': '',
          'time': '09:48 16/07/2026',
          'content': 'dạ vâng ạ',
          'avatarLabel': 'H',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F6FA,
      ), // Light background like in the image
      appBar: AppBar(
        title: Text('Sản phẩm của học viên', style: defaultText18B),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: mockProducts.length,
        itemBuilder: (context, index) {
          final product = mockProducts[index];
          return ProductCardWidget(product: product);
        },
      ),
    );
  }
}

class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCardWidget({super.key, required this.product});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List comments = widget.product['comments'];
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder - Using a colored container to simulate the image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image,
                size: 50,
                color: Colors.grey,
              ), // Replace with real image in production
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: Colors.green[100],
                      child: Text(
                        widget.product['avatarLabel'],
                        style: defaultText12B.copyWith(color: mainGreen),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'By ',
                      style: defaultText12M.copyWith(color: Colors.grey),
                    ),
                    Text(widget.product['authorName'], style: defaultText12B),
                    Text(
                      ' - ${widget.product['date']}',
                      style: defaultText12M.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                if (widget.product['description'] != '') ...[
                  SizedBox(height: 12.h),
                  Text(widget.product['description'], style: defaultText14M),
                ],
                SizedBox(height: 16.h),
                // Comment count - Tappable
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
                        Icon(
                          Icons.comment_outlined,
                          size: 16.w,
                          color: Colors.grey,
                        ),
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
                  // Comments list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _buildCommentItem(comment);
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Comment input box
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Text(
                            'Viết bình luận...',
                            style: defaultText14M.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: mainGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 16.w,
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

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12.r,
          backgroundColor: Colors.grey[200],
          child: Text(
            comment['avatarLabel'],
            style: defaultText12B.copyWith(color: Colors.black54),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment['authorName'], style: defaultText12B),
                  if (comment['role'] != '') ...[
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: comment['role'] == 'GV'
                            ? mainGreen
                            : const Color(0xFF3B5998),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        comment['role'],
                        style: defaultText12B.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    comment['time'],
                    style: defaultText12M.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(comment['content'], style: defaultText12M),
            ],
          ),
        ),
      ],
    );
  }
}
