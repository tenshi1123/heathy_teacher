import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeModel item;

  const RecipeDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Dummy related recipes
    final List<RecipeModel> relatedRecipes = [
      RecipeModel(
        title: "Công thức Ginger Shot cho 7 ngày",
        imageUrl: "assets/images/gift_formula2.jpg",
        date: "14/01/2026",
      ),
      RecipeModel(
        title: "Ức gà bọc trứng",
        imageUrl: "assets/images/gift_formula3.jpg",
        date: "14/01/2026",
      ),
      RecipeModel(
        title: "Tặng công thức cá hấp xì dầu cho bữa cơm nhà trở nên hấp dẫn",
        imageUrl: "assets/images/gift_formula4.png",
        date: "13/11/2025",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  DefaultAppBar(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Breadcrumbs
                        RichText(
                          text: TextSpan(
                            style: defaultText12M.copyWith(color: Colors.grey),
                            children: [
                              TextSpan(text: 'Trang chủ > Blog > '),
                              TextSpan(
                                text: item.title.toUpperCase(),
                                style: defaultText12M.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Title
                        Text(
                          item.title.toUpperCase(),
                          style: defaultText20B.copyWith(
                            color: mainDarkGreen,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Date
                        Text(
                          item.date ?? "14/01/2026",
                          style: defaultText12M.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 24.h),

                        // Dummy Content
                        Text(
                          "🍎 HỒ BIẾN ÁO MỚI CHO MÓN BÁNH BAO KINH DOANH TRUYỀN THỐNG TẠI TIỆM CỦA BẠN VỚI CÔNG THỨC BÁNH BAO KẸP ĐÀI LOAN NGUYÊN CÁM 🍔\n\n"
                          "Sáng nay trên đường đi làm, Linh bất chợt để ý thấy mấy hàng bánh bao dọc phố lúc nào cũng đông khách. Cũng đúng thôi, trong nhịp sống bận rộn ngày nay, không phải ai cũng có thời gian để nấu nướng cầu kỳ, hay ngồi lại thưởng thức một bữa ăn đầy đủ với các món phức tạp.\n\n"
                          "Nếu bạn là người kinh doanh đồ ăn Eat clean, chắc hẳn bạn công nhận ra rằng bữa sáng nhanh gọn, tiện lợi luôn được khách hàng ưu tiên và là ưu điểm lớn giúp gia tăng doanh thu. Vậy thì hôm nay Linh sẽ gợi ý cho mọi người thêm một ý tưởng đổi mới món bánh bao truyền thống, giúp thu hút khách hàng hơn, đồng thời vẫn giữ được tiêu chí ăn uống lành mạnh mà không tốn quá nhiều thời gian chế biến.\n\n"
                          "Thay vì những chiếc bánh bao truyền thống với nhân thịt và trứng, bánh bao kẹp Đài Loan nguyên cám là một lựa chọn hoàn hảo để mang đến sự mới mẻ và khác biệt cho thực đơn của bạn.\n"
                          "🫶 Bánh bao mọi người có thể làm sẵn, cấp đông. Khi sử dụng chỉ cần hâm lại vài phút rồi chế biến là được.\n"
                          "🫶 Vỏ bánh Linh làm là bột nguyên cám đi cùng nhân thịt ức gà tươi ngon, không hóa chất, không phụ gia, rất tốt cho sức khoẻ.\n"
                          "🫶 Với nhu cầu ăn uống lành mạnh đang ngày càng tăng, sản phẩm này rất dễ thu hút khách hàng, đặc biệt là dân văn phòng hay những người ăn kiêng, hoặc là những bà mẹ giống như Linh, mong muốn tìm kiếm bữa sáng nhanh tiện cho cả gia đình.\n\n"
                          "Inbox cho Linh nếu bạn quan tâm tới mô hình này nhé ❤️\n"
                          "#BanhBaoKepDaiLoan\n"
                          "#LinhPhan_Cô_giáo_healthy",
                          style: defaultText14M.copyWith(
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Related posts
                        Center(
                          child: Text(
                            'CÁC BÀI VIẾT LIÊN QUAN',
                            style: defaultText20B.copyWith(
                              color: mainDarkGreen,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Related Posts Grid
                        RecipeGridWidget(recipes: relatedRecipes, type: 1),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),

                  // Footer
                  _buildFooter(context),
                ],
              ),
            ),
          ),
          BottomCustom(),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        color: mainDarkGreen,
        border: Border.all(color: mainDarkGreen, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://cogiaohealthy.vn/wp-content/uploads/2025/07/logo_footer.png',
            height: 60.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: defaultText14M.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Hà Nội:',
                        style: defaultText14B.copyWith(color: Colors.white),
                      ),
                      TextSpan(text: ' 214 Lạc Long Quân, quận Tây Hồ, Hà Nội'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: defaultText14M.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'HCM:',
                        style: defaultText14B.copyWith(color: Colors.white),
                      ),
                      TextSpan(
                        text:
                            ' SkyVilla P2406, Celadon City, số 02 Tân Thanh, phường Tân Sơn Nhì, thành phố Hồ Chí Minh',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.phone_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: defaultText14M.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Hotline: ',
                        style: defaultText14B.copyWith(color: Colors.white),
                      ),
                      TextSpan(text: '(+84)96 691 2016'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'CÔNG TY TNHH CÔ GIÁO HEALTHY',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            'MST: 0109187074 \nĐăng ký lần đầu ngày 19 tháng 05 năm 2020 \nĐăng ký thay đổi lần thứ 4, ngày 20 tháng 06 năm 2024 \nNơi cấp: Sở kế hoạch và đầu tư thành phố Hà Nội - Phòng đăng ký kinh doanh \nĐịa chỉ trụ sở chính: Tầng 7, Tòa nhà Luxury Ofice, số 214 Lạc Long Quân, Phường Tây Hồ, Thành phố Hà Nội, Việt Nam',
            style: defaultText14M.copyWith(color: Colors.white, height: 1.5),
          ),
          SizedBox(height: 24.h),
          Text(
            'Thông tin',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            'Giới thiệu chung',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text('Khóa học', style: defaultText14M.copyWith(color: Colors.white)),
          SizedBox(height: 8.h),
          Text('Sản phẩm', style: defaultText14M.copyWith(color: Colors.white)),
          SizedBox(height: 8.h),
          Text(
            'Chính sách bảo mật - học tập',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: mainGreen,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theo dõi Cô Giáo Healthy',
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Nhận thông tin mới nhất về khoá học, kiến thức nấu ăn!',
                  style: defaultText14M.copyWith(color: Colors.white),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSocialIcon('assets/images/facebook.png'),
                    _buildSocialIcon('assets/images/youtube.png'),
                    _buildSocialIcon('assets/images/tiktok.png'),
                    _buildSocialIcon('assets/images/zalo.png'),
                    _buildSocialIcon('assets/images/ins.png', size: 20),
                    _buildSocialIcon('assets/images/threads.png'),
                    _buildSocialIcon('assets/images/lemon8.png'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            '© 2025 Cô Giáo Healthy | All Rights Reserved.',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String path, {double size = 28}) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(path, width: size, height: size, fit: BoxFit.contain),
    );
  }
}
