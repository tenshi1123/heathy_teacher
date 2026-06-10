import 'package:flutter/material.dart';
import 'package:heathy_teacher/repo/login_repo.dart';
import 'package:heathy_teacher/screens/authentication/sign_up_screen.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottomBarScreen.dart';
import 'package:heathy_teacher/services/fingerprint_service.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
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
                    const SizedBox(height: 10),
                    Text(
                      'Welcome!',
                      style: defaultText20B.copyWith(color: backGroundGreen),
                    ),
                    const SizedBox(height: 16),

                    // Lời chào
                    Text(
                      'Chào mừng bạn quay trở lại với Cô Giáo Healthy.',
                      style: defaultText16M,
                    ),
                    const SizedBox(height: 32),

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
                    const SizedBox(height: 16),

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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          final String fingerprint =
                              await FingerprintService.generateFingerprint(
                                context,
                              );

                          print('test5 $fingerprint');
                          // Xử lý logic đăng nhập tại đây

                          String message = await LoginRepo().login(
                            _phoneController.text,
                            _passwordController.text,
                            fingerprint,
                          );
                          if (message != 'Đăng nhập thành công') {
                            // Hiển thị thông báo lỗi nếu đăng nhập thất bại
                            // show dialog thay cho snackbar để người dùng dễ thấy hơn
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Lỗi đăng nhập'),
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => (BottomBarScreen())),
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
                          'ĐĂNG NHẬP',
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
                            builder: (context) => const SignUpScreen(),
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
                              const TextSpan(text: 'Bạn chưa có tài khoản? '),
                              TextSpan(
                                text: 'Đăng ký',
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
                color: backGroundGreen, // Nền xanh lá của banner
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
