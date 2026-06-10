import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/authentication/login_screen.dart';
import 'package:heathy_teacher/services/fingerprint_service.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Các biến controller để lấy dữ liệu nhập vào
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  final Color inputBgColor = const Color(0xFFFDFBF0);

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
        bottom: false,
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      'Bạn cần một tài khoản mới !',
                      style: defaultText20B.copyWith(color: backGroundGreen),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      'Đăng ký tài khoản để có thể trải nghiệm những khóa học',
                      style: defaultText16M.copyWith(color: Colors.black87),
                    ),
                    SizedBox(height: 32.h),

                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Họ và tên',
                        hintStyle: defaultText16M.copyWith(
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
                    SizedBox(height: 16.h),
                    // Ô nhập Số điện thoại
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Số điện thoại',
                        hintStyle: defaultText16M.copyWith(
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
                    SizedBox(height: 16.h),

                    // Ô nhập Mật khẩu
                    TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        hintStyle: defaultText16M.copyWith(
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
                    SizedBox(height: 24.h),

                    // Nút ĐĂNG KÝ
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
                          // Xử lý logic đăng ký tại đây
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => (LoginScreen())),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backGroundGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ĐĂNG KÝ',
                          style: defaultText16B.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hàng Đăng ký tài khoản
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                            children: [
                              const TextSpan(text: 'Bạn đã có tài khoản? '),
                              TextSpan(
                                text: 'Đăng nhập',
                                style: TextStyle(
                                  color: backGroundGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                                // Muốn bấm được thì thêm recognizer vào đây nếu cần
                              ),
                            ],
                          ),
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
                color: backGroundGreen,
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
