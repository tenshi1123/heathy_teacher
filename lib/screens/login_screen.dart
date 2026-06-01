import 'package:flutter/material.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/services/fingerprint_service.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Các biến controller để lấy dữ liệu nhập vào
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  // Định nghĩa bảng màu theo thiết kế của bạn
  final Color mainGreen = const Color(0xFF76BA43); // Màu xanh lá chủ đạo
  final Color inputBgColor = const Color(
    0xFFFDFBF0,
  ); // Màu nền ngả vàng nhẹ của ô nhập

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, // Để banner màu xanh tràn xuống hết đáy màn hình
        child: Column(
          children: [
            // PHẦN FORM ĐĂNG NHẬP (Chiếm phần trên)
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Tiêu đề Welcome
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: mainGreen,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lời chào
                    const Text(
                      'Chào mừng bạn quay trở lại với Cô Giáo Healthy.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Ô nhập Số điện thoại
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Số điện thoại',
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                          fontStyle: FontStyle.italic,
                        ),
                        fillColor: inputBgColor,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ô nhập Mật khẩu
                    TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                          fontStyle: FontStyle.italic,
                        ),
                        fillColor: inputBgColor,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nút ĐĂNG NHẬP
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          final fingerprint =
                              await FingerprintService.generateFingerprint(
                                context,
                              );

                          print('test5 $fingerprint');
                          // Xử lý logic đăng nhập tại đây
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => (CoGiaoHealthyScreen(
                                type: 'home',
                                place: 'Hà Nội',
                              ))),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ĐĂNG NHẬP',
                          style: defaultText16B.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hàng Đăng ký tài khoản
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(text: 'Bạn chưa có tài khoản? '),
                            TextSpan(
                              text: 'Đăng ký',
                              style: TextStyle(
                                color: mainGreen,
                                fontWeight: FontWeight.bold,
                              ),
                              // Muốn bấm được thì thêm recognizer vào đây nếu cần
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BANNER HÌNH ẢNH (Chiếm phần dưới)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: mainGreen, // Nền xanh lá của banner
                child: Align(
                  alignment: Alignment.bottomCenter,
                  // Thay 'assets/teacher_image.png' bằng đường dẫn ảnh cô giáo của bạn
                  child: Image.asset(
                    'assets/images/login_image.png',
                    fit: BoxFit.contain,
                    // Thuộc tính này đảm bảo ảnh chạm đáy đúng chuẩn thiết kế
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) {
                      // Đoạn này dùng để hiển thị tạm thời khi bạn chưa thêm file ảnh thật vào dự án
                      return const Center(
                        child: Text(
                          '[ Thêm ảnh cô giáo vào assets ]',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
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
