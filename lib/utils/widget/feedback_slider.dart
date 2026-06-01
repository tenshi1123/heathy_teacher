import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Tiêu đề chính
          const Text(
            'FEEDBACK CỦA HỌC VIÊN',
            style: TextStyle(
              color: Color(0xFF3B7E45), // Màu xanh lá chủ đạo
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),

          // 2. Vùng hiển thị nội dung slide (PageView)
          SizedBox(
            height: 580.h, // Chiều cao cố định bao phủ text và ảnh dưới
            child: PageView.builder(
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nội dung feedback (Có dấu nháy kép mở đầu)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '“ ',
                          style: TextStyle(
                            color: Color(0xFF4A5568),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item['content'],
                            style: const TextStyle(
                              color: Color(0xFF4A5568),
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Thông tin User (Avatar + Tên + Khóa học)
                    Row(
                      children: [
                        // Avatar hình tròn (Lấy tạm chính ảnh feedback bo tròn)
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(fullImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tên & tên khóa học
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['user_name'],
                                style: const TextStyle(
                                  color: Color(0xFF3B7E45),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['course_name'],
                                style: const TextStyle(
                                  color: Color(0xFF718096),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNavButton(
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
                        const SizedBox(width: 16),
                        _buildNavButton(
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
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 3. Hình ảnh feedback lớn bên dưới (Lấy từ data JSON)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          fullImageUrl,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
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
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Hàm tạo nút điều hướng tròn xanh/trắng tròn
  Widget _buildNavButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? const Color(0xFF76BA43) : Colors.white,
          border: Border.all(color: const Color(0xFF76BA43), width: 1.5),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : const Color(0xFF76BA43),
          size: 20,
        ),
      ),
    );
  }
}
