import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/screens/search/search_result_screen.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  // Màu xanh lá logo
  static const Color secondaryGreen = Color(0xFF7CB342);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50), // Khoảng cách cho status bar

                  DefaultAppBar(),

                  CustomSearchBar(
                    iconColor: secondaryGreen,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultScreen(
                              query: value.trim(),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 32.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Image.asset(
                      'assets/images/introduce_image.png',
                      width: double.infinity,
                      fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                    ),
                  ),
                  Container(
                    width: double.infinity,

                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: backGroundGreen,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GIỚI THIỆU VỀ NGƯỜI SÁNG LẬP',
                          style: defaultText18B.copyWith(color: Colors.white),
                        ),
                        Text(
                          'CÔ GIÁO HEALTHY LINH PHAN',
                          style: defaultText20B.copyWith(
                            color: mainYellow,
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          'Linh Phan – người tiên phong chuyên nghiệp hóa lĩnh vực đào tạo Eatclean tại Việt Nam.',
                          style: defaultText16M.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Với hơn 10 năm kinh nghiệm trong ngành thực phẩm và giáo dục sức khỏe, chị là người đầu tiên tại Việt Nam xây dựng trung tâm đào tạo trực tiếp chuyên sâu về Eatclean tại cả Hà Nội và TP. Hồ Chí Minh. Không chỉ dừng lại ở vai trò giảng viên, Linh xác lập cho mình một sứ mệnh lớn hơn: kiến tạo nền tảng đào tạo Eatclean bài bản, thực tiễn và có trách nhiệm với cộng đồng.',
                          style: defaultText16M.copyWith(color: Colors.white),
                        ),
                        RotatedBox(
                          quarterTurns: 2, // Xoay 2 góc vuông (180 độ)
                          child: Icon(
                            Icons.format_quote,
                            size: 60,
                            color: Color(0xFFFEFDF0), // Màu trắng kem
                          ),
                        ),
                        Text(
                          'Tôi tin rằng, Eatclean không chỉ là chế độ ăn, mà là một phong cách sống – và có thể trở thành một nghề nghiệp tử tế nếu được đào tạo đúng cách.',
                          style: defaultText16M.copyWith(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Linh Phan, sáng lập Cô Giáo Healthy',
                          style: defaultText16B.copyWith(color: mainYellow),
                        ),
                      ],
                    ),
                  ),
                  _buildStudentGroups(),
                  Container(
                    width: double.infinity,
                    //height: 375.w * 4 / 3,
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    child: Image.asset(
                      'assets/images/introduce_image2.png',
                      width: double.infinity,
                      fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                    ),
                  ),
                  _buildMissions(),
                  _buildCommitments(),
                  Container(
                    width: double.infinity,
                    //height: 375.w * 4 / 3,
                    margin: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),

                    child: CachedNetworkImage(
                      imageUrl:
                          'https://cogiaohealthy.vn/wp-content/uploads/2025/08/174-90.png',
                      height: 200.h,
                      //width: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    //height: 375.w * 4 / 3,
                    margin: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),

                    child: CachedNetworkImage(
                      imageUrl:
                          'https://cogiaohealthy.vn/wp-content/uploads/2025/08/intro-img-2.png',
                      height: 200.h,
                      //width: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Trong tương lai, Cô Giáo Healthy hướng đến:',
                      style: defaultText18B.copyWith(
                        color: mainDarkGreen,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildBulletPoint(
                      'Mở rộng hoạt động đào tạo, nâng cao chuẩn giảng dạy và tư duy làm nghề.',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildBulletPoint(
                      'Xây dựng cộng đồng Eatclean lành mạnh, có trách nhiệm và tạo ra giá trị thực sự cho xã hội.',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Nếu bạn đang tìm một nơi để học Eatclean đúng cách, hoặc khởi nghiệp tử tế trong ngành Eatclean & Healthy hãy để Cô Giáo Healthy là người đồng hành đầu tiên trong sự nghiệp của bạn.',
                      style: defaultText16M.copyWith(
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const CustomFooterInfo(),
                  // Khoảng cách cuối trang
                ],
              ),
            ),
          ),
          BottomCustom(),
        ],
      ),
    );
  }

  Widget _buildStudentGroups() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VỀ CÔ GIÁO HEALTHY',
            style: defaultText20B.copyWith(
              color: mainDarkGreen,
              fontSize: 30.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Một doanh nghiệp giáo dục mang sứ mệnh phụng sự',
            style: defaultText16M.copyWith(color: mainDarkGreen),
          ),
          SizedBox(height: 12.h),
          Text(
            'Khác với mô hình dạy nấu ăn đơn lẻ, Cô Giáo Healthy được thành lập như một tổ chức giáo dục chuyên biệt, với tầm nhìn dài hạn: trở thành nơi đào tạo – định hướng – đồng hành cùng những người xây dựng mô hình Eatclean tử tế và bền vững.',
            style: defaultText16M.copyWith(color: Colors.black87),
          ),
          SizedBox(height: 24.h),
          Text(
            'Chúng tôi phục vụ 3 nhóm học viên chính:',
            style: defaultText18B.copyWith(color: mainDarkGreen),
          ),
          SizedBox(height: 16.h),
          _buildInfoCard(
            icon: Icons.insights,
            title: 'Người kinh doanh Eatclean',
            subtitle: 'Cần kiến thức bài bản và hệ sinh thái hỗ trợ dài hạn.',
          ),
          _buildInfoCard(
            icon: Icons.family_restroom,
            title: 'Người làm cha mẹ',
            subtitle: 'Muốn chăm sóc sức khỏe gia đình đúng cách',
          ),
          _buildInfoCard(
            icon: Icons.person_search_outlined,
            title: 'Người trẻ hoặc người đang khởi nghiệp',
            subtitle: 'Tìm kiếm công việc có ý nghĩa',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 48.sp, color: secondaryGreen),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: defaultText16B.copyWith(color: mainDarkGreen),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: defaultText14M.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        children: [
          Text(
            'SỨ MỆNH VÀ CAM KẾT CỦA CHÚNG TÔI',
            textAlign: TextAlign.center,
            style: defaultText20B.copyWith(
              color: mainDarkGreen,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: defaultText16M.copyWith(color: Colors.black87),
              children: [
                TextSpan(text: 'Cô Giáo Healthy không dừng lại ở việc '),
                TextSpan(
                  text: '“Dạy một khóa học”.',
                  style: defaultText16B.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _buildMissionCard(
            title: 'Thay đổi tư duy dinh dưỡng',
            subtitle:
                'Truyền cảm hứng sống lành mạnh, ăn uống khoa học và bền vững',
          ),
          _buildMissionCard(
            title: 'Thay đổi tư duy dinh dưỡng',
            subtitle:
                'Truyền cảm hứng sống lành mạnh, ăn uống khoa học và bền vững',
          ),
          _buildMissionCard(
            title: 'Thay đổi tư duy dinh dưỡng',
            subtitle:
                'Truyền cảm hứng sống lành mạnh, ăn uống khoa học và bền vững',
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard({required String title, required String subtitle}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF00E676),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.eco, size: 40.sp, color: const Color(0xFF2E7D32)),
            SizedBox(height: 16.h),
            Text(title, style: defaultText18B.copyWith(color: mainDarkGreen)),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: defaultText14M.copyWith(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitments() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAM KẾT TRONG HIỆN TẠI\n& TƯƠNG LAI',
            style: defaultText20B.copyWith(
              color: mainDarkGreen,
              fontSize: 26.sp,
              height: 1.3,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Trong suốt 10 năm hoạt động, chúng tôi đã:',
            style: defaultText18B.copyWith(
              color: mainDarkGreen,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 16.h),
          _buildBulletPoint(
            'Đồng hành cùng hàng ngàn học viên khởi sự kinh doanh Eatclean đúng hướng.',
          ),
          _buildBulletPoint(
            'Xây dựng mô hình lớp học Eatclean chuyên sâu đầu tiên tại Việt Nam.',
          ),
          _buildBulletPoint(
            'Cung cấp hệ thống công cụ học tập – nguyên liệu – cố vấn kinh doanh cho từng học viên.',
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h, right: 12.w),
            child: CircleAvatar(radius: 4.r, backgroundColor: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: defaultText16M.copyWith(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildImage(String iconPath, {double size = 28}) {
  return Container(
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Image.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    ),
  );
}
