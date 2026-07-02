import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';

import 'package:heathy_teacher/utils/constants/styles.dart';

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
                          "Học viên",
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
                          "Tich điểm",
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
        selectedTab == 0
            ? Expanded(child: OnlinePolicyScreen())
            : Expanded(child: RewardPolicyScreen()),
      ],
    );
  }
}

class RewardPolicyScreen extends StatelessWidget {
  const RewardPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= PHẦN I (CŨ) =================
          Text(
            'CHÍNH SÁCH TÍCH ĐIỂM & NÂNG HẠNG THÀNH VIÊN',
            style: defaultText20B.copyWith(fontSize: 22),
          ),
          SizedBox(height: 24),

          Text(
            'Áp dụng cho toàn bộ học viên của Cô Giáo Healthy',
            style: defaultText16B,
          ),
          SizedBox(height: 24),

          RichText(
            text: TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(
                  text:
                      'Nhằm tri ân sự đồng hành cũng như khích lệ nỗ lực học tập của học viên, Cô Giáo Healthy chính thức triển khai ',
                ),
                TextSpan(
                  text: 'chính sách tích điểm và nâng hạng thành viên',
                  style: defaultText16B,
                ),
                TextSpan(
                  text:
                      ', giúp học viên nhận được nhiều ưu đãi thiết thực trong quá trình học tập và mua sắm.',
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          Text('I. CHÍNH SÁCH TÍCH ĐIỂM', style: defaultText20B),
          SizedBox(height: 24),

          Text('Quy ước điểm:', style: defaultText18B),
          SizedBox(height: 12),

          _buildBulletItem(
            TextSpan(text: '1.000 điểm = 1.000 VNĐ', style: defaultText16B),
          ),
          SizedBox(height: 24),

          Text(
            'Tỷ lệ tích điểm (áp dụng cho tất cả hạng thẻ):',
            style: defaultText18B,
          ),
          SizedBox(height: 12),

          _buildBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: '2% ', style: defaultText16B),
                TextSpan(text: 'trên '),
                TextSpan(text: 'học phí khóa học'.sanitizeForApple, style: defaultText16B),
              ],
            ),
          ),
          SizedBox(height: 8),
          _buildBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: '0,5% ', style: defaultText16B),
                TextSpan(text: 'trên '),
                TextSpan(
                  text: 'đơn hàng mua nguyên liệu/dụng cụ',
                  style: defaultText16B,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // ================= PHẦN II =================
          Text('II. PHÂN HẠNG THÀNH VIÊN', style: defaultText20B),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Học viên sẽ được '),
                TextSpan(text: 'tự động phân hạng', style: defaultText16B),
                TextSpan(text: ' dựa trên '),
                TextSpan(text: 'tổng chi tiêu', style: defaultText16B),
                TextSpan(text: ' thanh toán học phí (cộng dồn):'),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Hạng Bạc
          Text('1. HẠNG BẠC', style: defaultText18B),
          SizedBox(height: 12),
          _buildBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Tổng chi tiêu: '),
                TextSpan(text: 'Dưới 15.000.000đ', style: defaultText16B),
              ],
            ),
          ),
          SizedBox(height: 8),
          _buildBulletItem(TextSpan(text: 'Quyền lợi:', style: defaultText16M)),
          _buildNestedBulletItem(
            TextSpan(
              text: 'Không áp dụng ưu đãi giảm học phí',
              style: defaultText16M,
            ),
          ),
          _buildNestedBulletItem(
            TextSpan(
              text: 'Vẫn được tích điểm theo quy định chung',
              style: defaultText16M,
            ),
          ),
          SizedBox(height: 24),

          // Hạng Vàng
          Text('2. HẠNG VÀNG', style: defaultText18B),
          SizedBox(height: 12),
          _buildBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Tổng chi tiêu: '),
                TextSpan(
                  text: 'Từ 15.000.000đ – dưới 30.000.000đ',
                  style: defaultText16B,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          _buildBulletItem(
            TextSpan(text: 'Ưu đãi học phí:', style: defaultText16M),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Giảm 15% ', style: defaultText16B),
                TextSpan(text: 'học phí khóa học online'.sanitizeForApple),
              ],
            ),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Giảm 5% ', style: defaultText16B),
                TextSpan(text: 'học phí khóa học trực tiếp'.sanitizeForApple),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Hạng Kim Cương
          Text('3. HẠNG KIM CƯƠNG', style: defaultText18B),
          SizedBox(height: 12),
          _buildBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Tổng chi tiêu: '),
                TextSpan(text: 'Từ 30.000.000đ trở lên', style: defaultText16B),
              ],
            ),
          ),
          SizedBox(height: 8),
          _buildBulletItem(
            TextSpan(text: 'Ưu đãi học phí:', style: defaultText16M),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Giảm 20% ', style: defaultText16B),
                TextSpan(text: 'học phí khóa học online'.sanitizeForApple),
              ],
            ),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Giảm 10% ', style: defaultText16B),
                TextSpan(text: 'học phí khóa học trực tiếp'.sanitizeForApple),
              ],
            ),
          ),
          SizedBox(height: 32),

          // ================= PHẦN III =================
          Text('III. THƯỞNG ĐIỂM & MÃ GIỚI THIỆU', style: defaultText20B),
          SizedBox(height: 16),

          _buildBulletItem(
            TextSpan(text: 'Thưởng trả bài:', style: defaultText16M),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(
                  text:
                      'Đối với mỗi khoá học, khi bạn đã hoàn thành trên 50% khoá học, ở khoá học đó sẽ có thêm mục '.sanitizeForApple,
                ),
                TextSpan(text: '"Trả bài tích điểm"', style: defaultText16B),
                TextSpan(
                  text: '. Với mỗi trả bài tích điểm được duyệt bạn sẽ được ',
                ),
                TextSpan(text: 'thưởng 10.000 điểm', style: defaultText16B),
                TextSpan(text: ' vào điểm tích luỹ.'),
              ],
            ),
          ),
          SizedBox(height: 8),

          _buildBulletItem(
            TextSpan(text: 'Mã giới thiệu học viên:', style: defaultText16B),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(
                  text:
                      'Khi học viên mới đăng ký khoá học và nhập mã giới thiệu của học viên cũ thì cả người giới thiệu và người được giới thiệu đều '.sanitizeForApple,
                ),
                TextSpan(
                  text: 'nhận 30.000 điểm thưởng.',
                  style: defaultText16B,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Lưu ý
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: RichText(
              text: TextSpan(
                style: defaultText16M,
                children: [
                  TextSpan(text: 'Lưu ý: ', style: defaultText16B),
                  TextSpan(
                    text:
                        'Mã giới thiệu chính là số điện thoại đăng ký tài khoản học, bạn có thể xem mã giới thiệu ở hồ sơ tài khoản của mình (vui lòng cập nhật SĐT vào hồ sơ học viên để hệ thống ghi nhận)',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),

          // ================= PHẦN IV =================
          Text('IV. CÁCH SỬ DỤNG ĐIỂM', style: defaultText20B),
          SizedBox(height: 16),
          _buildBulletItem(
            TextSpan(
              text: 'Điểm tích lũy được dùng để:',
              style: defaultText16M,
            ),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Thanh toán '),
                TextSpan(text: 'khóa học'.sanitizeForApple, style: defaultText16B),
              ],
            ),
          ),
          _buildNestedBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Mua '),
                TextSpan(
                  text: 'nguyên liệu, dụng cụ, máy móc',
                  style: defaultText16B,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Điểm tích luỹ '),
                TextSpan(
                  text: 'không quy đổi sang tiền mặt',
                  style: defaultText16B,
                ),
                TextSpan(text: ' và '),
                TextSpan(text: 'không chuyển nhượng', style: defaultText16B),
                TextSpan(text: ' cho người khác'),
              ],
            ),
          ),
          SizedBox(height: 32),

          // ================= PHẦN V =================
          Text('V. HẠN SỬ DỤNG ĐIỂM', style: defaultText20B),
          SizedBox(height: 16),
          _buildBulletItem(
            TextSpan(
              style: defaultText16M,
              children: [
                TextSpan(text: 'Điểm tích lũy có '),
                TextSpan(
                  text: 'thời hạn sử dụng 03 tháng',
                  style: defaultText16B,
                ),
                TextSpan(text: ' kể từ ngày phát sinh.'),
              ],
            ),
          ),
          SizedBox(height: 40), // Khoảng trống cuối màn hình
        ],
      ),
    );
  }

  // Widget hỗ trợ tạo gạch đầu dòng cấp 1 (dấu chấm tròn đậm)
  Widget _buildBulletItem(InlineSpan textSpan) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: defaultText18B),
          Expanded(child: RichText(text: textSpan)),
        ],
      ),
    );
  }

  // Widget hỗ trợ tạo gạch đầu dòng cấp 2 (thụt lề sâu hơn, dấu chấm nhỏ hơn hoặc gạch ngang)
  Widget _buildNestedBulletItem(InlineSpan textSpan) {
    return Padding(
      padding: EdgeInsets.only(left: 44.0, bottom: 4.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: defaultText16M,
          ), // Dùng chấm tròn nhỏ hoặc có thể đổi thành '- '
          Expanded(child: RichText(text: textSpan)),
        ],
      ),
    );
  }
}

class OnlinePolicyScreen extends StatelessWidget {
  const OnlinePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Text(
            'CHÍNH SÁCH HỌC ONLINE DÀNH CHO HỌC VIÊN CỦA CÔ GIÁO HEALTHY'.sanitizeForApple,
            style: defaultText20B.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 24),

          // Các đoạn nội dung
          _buildParagraph(
            '- Mỗi học viên khi đăng kí bất kì khóa học nào chỉ được SỬ DỤNG 1 TÀI KHOẢN học viên được kích hoạt khi đăng ký khoá học để tham gia vào nhóm học kín, và đăng nhập trên TỐI ĐA 2 THIẾT BỊ và truy cập xem video trên DUY NHẤT 1 THIẾT BỊ TRONG MỘT THỜI ĐIỂM.'.sanitizeForApple,
          ),

          _buildParagraph(
            '- Trường hợp học viên được add Facebook khác vào nhóm khi & chỉ khi bị mất nick, hack nick,... sẽ được XÁC NHẬN & KIỂM TRA từ 1-2 tuần sau đó sẽ add lại 1 tài khoản mới của học viên đó vào nhóm học, với điều kiện đúng là học viên đã đăng ký học. Mọi lý do khác sẽ KHÔNG được chấp nhận vì khóa học là tài sản trí tuệ trực thuộc Công ty TNHH CÔ GIÁO HEALTHY và có tính bảo mật cao.'.sanitizeForApple,
          ),

          _buildParagraph(
            '** LƯU Ý QUAN TRỌNG: Sau khi vào nhóm học, học viên sẽ KHÔNG được đổi ngang sang khóa học khác vì bất kì lý do gì và cũng KHÔNG được hoàn lại học phí.'.sanitizeForApple,
          ),

          _buildParagraph(
            '- Đối với học viên đã đăng kí học ONLINE muốn update lên học TRỰC TIẾP. Học phí chênh lệch sẽ được tính = học phí trực tiếp hiện tại - % học phí khi đăng kí online (mức cụ thể sẽ báo khi học viên muốn update lên lớp trực tiếp). Và LƯU Ý KHÔNG HOÀN HỌC PHÍ DƯỚI MỌI HÌNH THỨC hay bất kể lý do gì sau khi đã vào nhóm học.'.sanitizeForApple,
          ),

          _buildParagraph(
            '- Học viên KHÔNG ĐƯỢC chia sẻ tài liệu, video, công thức lên trang cá nhân, các hội nhóm, các trang mạng xã hội dưới bất kể hình thức nào. Nếu vi phạm sẽ bị XÓA TƯ CÁCH THÀNH VIÊN, và không được hỗ trợ mà không cần thông báo trước để đảm bảo quyền lợi chính đáng của nhóm (lớp học) và các học viên khác.',
          ),

          _buildParagraph(
            '- Học viên sẽ có những ĐẶC QUYỀN RIÊNG khi đăng kí khóa học như: mua nguyên liệu với giá tốt, nguồn gốc đảm bảo, tham gia các nhóm cộng đồng, được hỗ trợ & giao lưu với cô giáo và các bạn học viên khác,...'.sanitizeForApple,
          ),

          _buildParagraph(
            '** Tất cả các video học đều thuộc bản quyền công ty TNHH Cô Giáo Healthy, được bảo hộ độc quyền, mong các bạn học viên không sử dụng dưới mục đích chia sẻ hay kinh doanh. Các trường hợp vi phạm sẽ bị xử lý theo quy định của pháp luật**',
          ),

          const SizedBox(height: 24),
          Text(
            'CHÍNH SÁCH HỌC TRỰC TIẾP DÀNH CHO HỌC VIÊN CỦA CÔ GIÁO HEALTHY ',
            style: defaultText20B.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 24),

          // Các đoạn nội dung
          _buildParagraph(
            '- Mỗi học viên khi đăng kí bất kì khóa học nào chỉ được Sử DỤNG 1 TÀI KHOẢN học viên được kích hoạt khi đăng ký khoá học để tham gia vào nhóm học kín, và đăng nhập trên TỐI ĐA 2 THIẾT BỊ và truy cập xem video trên DUY NHẤT 1 THIẾT BỊ TRONG MỘT THỜI ĐIỂM.'.sanitizeForApple,
          ),
          _buildParagraph(
            '- Trường hợp học viên được add Facebook khác vào nhóm chỉ khi bị mất nick, hack nick,....sẽ được XÁC NHẬN & KIỂM TRA từ 1-2 tuần sau đó sẽ add lại 1 tài khoản mới của học viên đó vào nhóm học với điều kiện đúng là học viên đã đăng ký học. Mọi lý do khác sẽ KHÔNG được chấp nhận vì khóa học là tài sản trí tuệ trực thuộc Công ty TNHH CÔ GIÁO HEALTHY và có tính bảo mật cao.'.sanitizeForApple,
          ),
          _buildParagraph(
            '- Đối với học viên đăng kí học TRỰC TIẾP: Team cô giáo Healthy đã chuẩn bị đầy đủ tài liệu và tất cả nguyên vật liệu thực hành, đồ ăn trưa và sản phẩm mang về sau lớp học nên học viên không cần mang thêm gì ạ.',
          ),
          _buildParagraph(
            '** LƯU Ý QUAN TRỌNG: Sau khi vào nhóm học, học viên sẽ KHÔNG được đổi ngang sang khóa học khác vì bất kì lý do gì và cũng KHÔNG được hoàn lại học phí.'.sanitizeForApple,
          ),
          _buildParagraph(
            '** CHÍNH SÁCH QUY ĐỊNH LÙI LỊCH / BẢO LƯU LỚP HỌC TRỰC TIẾP:',
          ),
          _buildParagraph(
            'Để đảm bảo công tác tổ chức lớp học, chuẩn bị nguyên vật liệu và quyền lợi chung của các bên, Trung tâm ban hành quy định lùi lịch/bảo lưu lớp học trực tiếp như sau:',
          ),
          _buildParagraph('Điều 1. Điều kiện lùi lịch'),
          _buildParagraph(
            '1. Học viên phải thông báo lùi lịch ít nhất 03 ngày trước ngày khai giảng. \n   2. Mỗi học viên được hỗ trợ tối đa 02 lần lùi lịch trong vòng 6 tháng cho mỗi khóa học đã đăng ký, bao gồm: lịch học ban đầu, lùi lần 1 và lùi lần 2.'.sanitizeForApple,
          ),
          _buildParagraph('Điều 2. Trường hợp lùi lịch sát ngày học'),

          _buildParagraph(
            '1. Trường hợp học viên thông báo lùi lịch trong vòng 01 - 02 ngày trước ngày khai giảng, Trung tâm vẫn xem xét hỗ trợ lùi lịch / bảo lưu theo quy định.\n   2.Do Trung tâm đã hoàn tất việc chuẩn bị nguyên vật liệu và các khâu tổ chức cho suất học của học viên, học viên có trách nhiệm chi trả 30% chi phí nguyên liệu, tương đương 1.000.000 đồng. Khoản phí này sẽ được thanh toán khi học viên đến tham gia lớp trực tiếp tại trung tâm.\n   3.70% chi phí nguyên liệu còn lại sẽ do Trung tâm hỗ trợ.',
          ),
          _buildParagraph('Điều 3. Quy định sắp xếp lại lớp học'),
          _buildParagraph(
            '   1. Sau khi được chấp thuận lùi lịch, Trung tâm sẽ chủ động sắp xếp lớp học tiếp theo phù hợp với kế hoạch đào tạo thực tế và thông báo lại cho học viên. Học viên cũng có thể chủ động nhắn tin đăng ký tham gia theo lịch mở lớp của Trung tâm.\n   2. Thời gian lùi lịch / bảo lưu tối đa là 06 tháng kể từ ngày học viên đăng ký hoặc đặt cọc khóa học, đồng thời không vượt quá 02 lần lùi lịch theo quy định.\n   3. Hết thời hạn trên, hoặc trong trường hợp Trung tâm đã sắp xếp lớp học tiếp theo và thông báo tới học viên nhưng học viên vẫn không thể tham gia các lịch tiếp theo vì bất kỳ lý do nào, khóa học sẽ được xem là đã hoàn tất quyền tham gia và Trung tâm không có trách nhiệm tiếp tục sắp xếp bảo lưu.'.sanitizeForApple,
          ),
          _buildParagraph('Điều 4. Hiệu lực áp dụng'),
          _buildParagraph(
            '   1. Quy định này áp dụng đối với toàn bộ học viên đăng ký lớp học trực tiếp tại Trung tâm./n   2. Học viên đăng ký lớp đồng nghĩa với việc đã đọc, hiểu và đồng ý tuân thủ các quy định nêu trên.',
          ),
          _buildParagraph(
            '** Học viên nào đăng ký học thì người đó tới lớp học. Trung tâm không hỗ trợ cho các trường hợp tới học hộ & mua/bán lại các khóa học.'.sanitizeForApple,
          ),
          _buildParagraph(
            '** Học viên sẽ có những ĐẶC QUYỀN RIÊNG khi đăng kí khóa học như: mua nguyên liệu với giá tốt, nguồn gốc đảm bảo, tham gia các nhóm cộng đồng, được hỗ trợ & giao lưu với cô giáo và các bạn học viên khác,....'.sanitizeForApple,
          ),
          _buildParagraph(
            '** Học viên KHÔNG ĐƯỢC chia sẻ tài liệu, video, công thức lên trang cá nhân, các hội nhóm, các trang mạng xã hội dưới bất kể hình thức nào. Nếu vi phạm sẽ bị XÓA TƯ CÁCH THÀNH VIÊN, và không được hỗ trợ mà không cần thông báo trước để đảm bảo quyền lợi chính đáng của nhóm (lớp học) và các học viên khác.',
          ),
          _buildParagraph(
            '** Tất cả các video học đều thuộc bản quyền công ty TNHH Cô Giáo Healthy, được bảo hộ độc quyền, mong các bạn học viên không sử dụng dưới mục đích chia sẻ hay kinh doanh. Các trường hợp vi phạm sẽ bị xử lý theo quy định của pháp luật **',
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  // Hàm hỗ trợ render các đoạn văn bản với khoảng cách đều nhau
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ), // Tạo khoảng cách giữa các đoạn
      child: Text(text, style: defaultText16M),
    );
  }
}
