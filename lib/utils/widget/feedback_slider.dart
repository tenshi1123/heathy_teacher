import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedbackSlider extends StatefulWidget {
  const FeedbackSlider({super.key});

  @override
  State<FeedbackSlider> createState() => _FeedbackSliderState();
}

class _FeedbackSliderState extends State<FeedbackSlider> {
  // Domain gốc dùng để ghép link ảnh từ JSON
  final String baseImageUrl = "https://lms.cogiaohealthy.vn";

  // Data JSON gốc từ bạn cung cấp
  final String jsonData = """
  {
    "value": [
      {
        "img": "/images/feed_back/sp20.jpg",
        "img_main": "/images/feed_back/sp20.jpg",
        "content": "Em học và thực hành hơn 2 tuần nay em nổ đơn to cô ạ. Vừa làm vừa lo nhưng có cô hỗ trợ trộm vía khách khen ngon nên vui lắm em gửi trả bài cô giáo hihi",
        "user_name": "Chị Ánh",
        "course_name": "KHÓA HỌC MÔ HÌNH KINH DOANH SUẤT ĂN SIÊU NĂNG LƯỢNG (ENERGY BOWL) VÀ CHẾ BIẾN THỰC PHẨM ĐÓNG GÓI SẴN"
      },
      {
        "img": "/images/feed_back/sp1.jpg",
        "img_main": "/images/feed_back/sp1.jpg",
        "content": "Hôm nay em làm thử công thức của cô chuẩn healthy, cả nhà ăn đều khen ngon cô ạ. Làm lần đầu thành công luôn, vui quá cô ơi <3 ",
        "user_name": "Chị Nguyễn Kim Loan",
        "course_name": "KHÓA HỌC BÁNH NGŨ CỐC YẾN MẠCH SỮA CHUA TRÁI CÂY"
      },
      {
        "img": "/images/feed_back/sp3.jpg",
        "img_main": "/images/feed_back/sp3.jpg",
        "content": "Dạ cảm ơn cô đã hỗ trợ nhiệt tình, kẹo ngon khách khen lắm cô ạ. Em mở bán 2 hôm mà cũng nhận đơn được hơn 15kg rồi ạ <3",
        "user_name": "Chị Phương Huỳnh",
        "course_name": "KHOÁ HỌC KẸO DẺO TRÁI CÂY VÀ THẢO MỘC ĐÀI LOAN HEALTHY"
      },
      {
        "img": "/images/feed_back/sp2.jpg",
        "img_main": "/images/feed_back/sp2.jpg",
        "content": "Em bám sát các nội dung trên lớp và thay đổi menu liên tục, nay em bắt đầu nhận đơn, khách nhận ăn khen sốt ướp thịt và sốt chấm rất ngon, em phấn khởi quá cô ạ",
        "user_name": "Chị Ngọc Dung",
        "course_name": "KHÓA HỌC MÔ HÌNH KINH DOANH SUẤT ĂN SIÊU NĂNG LƯỢNG (ENERGY BOWL) VÀ CHẾ BIẾN THỰC PHẨM ĐÓNG GÓI SẴN"
      }
    ]
  }
  """;

  List<dynamic> feedbackList = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Parse dữ liệu JSON thành List
    final Map<String, dynamic> parsedJson = jsonDecode(jsonData);
    feedbackList = parsedJson['value'];

    // Tìm vị trí của Chị Phương Huỳnh để hiển thị mặc định giống ảnh mẫu của bạn (index = 2)
    _currentIndex = feedbackList.indexWhere(
      (item) => item['user_name'] == "Chị Phương Huỳnh",
    );
    if (_currentIndex == -1) _currentIndex = 0;

    // Khởi tạo PageController ở vị trí mong muốn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (feedbackList.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Tiêu đề chính
          const Text(
            'FEEDBACK CỦA HỌC VIÊN',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF3B7E45), // Màu xanh lá chủ đạo
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 24.h),

          // 2. Vùng hiển thị nội dung slide (PageView) + Nút điều hướng
          SizedBox(
            height: 540.h, // Đủ không gian cho ảnh và card text đè lên
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: feedbackList.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = feedbackList[index];
                    final fullImageUrl = "$baseImageUrl${item['img_main']}";

                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // Main White Card with Image
                        Container(
                          margin: EdgeInsets.only(
                            left: 45.w,
                            right: 45.w,
                            top: 10.h,
                            bottom: 140.h, // Nhường chỗ cho text card
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(memCacheWidth: 800, 
  imageUrl: fullImageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Text Card (Overlapping)
                        Positioned(
                          bottom: 10.h,
                          left: 65.w,
                          right: 65.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 24.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['course_name']
                                          ?.toString()
                                          .toUpperCase() ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF3B7E45),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  item['content'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF4A5568),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  item['user_name']?.toString().toUpperCase() ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFE67E22), // Màu cam
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Nút Left
                Positioned(
                  left: 8.w,
                  child: _buildNavButton(
                    icon: Icons.arrow_back,
                    isActive: _currentIndex > 0,
                    onTap: () {
                      if (_currentIndex > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),

                // Nút Right
                Positioned(
                  right: 8.w,
                  child: _buildNavButton(
                    icon: Icons.arrow_forward,
                    isActive: _currentIndex < feedbackList.length - 1,
                    onTap: () {
                      if (_currentIndex < feedbackList.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
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

  // Hàm tạo nút điều hướng
  Widget _buildNavButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isActive ? onTap : null,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: isActive ? const Color(0xFF3B7E45) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF76BA43), size: 20),
      ),
    );
  }
}
