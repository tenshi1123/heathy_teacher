import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:heathy_teacher/screens/productPage/list_detail_product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/screens/coursePage/online_class_screen.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';

class DetailVideo extends StatefulWidget {
  const DetailVideo({
    super.key,
    required this.name,
    required this.streamingUrl,
    this.courses,
    this.percentLearning,
    this.isShow,
    this.description,
  });

  final String streamingUrl;
  final String name;
  final CourseDetailModel? courses;
  final double? percentLearning;
  final String? isShow;
  final String? description;
  @override
  State<DetailVideo> createState() => _DetailVideoState();
}

class _DetailVideoState extends State<DetailVideo> with WidgetsBindingObserver {
  bool _isRecording = false;
  final bool _isFullscreen = false;
  bool _isLandscape = false;
  StreamSubscription? _recordingSub;

  late final WebViewController _controller;
  Timer? _trackingTimer;
  String watermarkText = "Bản quyền thuộc về CGH";
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
    _initWebView();
    _startTrackingTime();
  }

  void _startTrackingTime() {
    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      //_sendTimeTrackingApi(_totalSecondsWatched);
    });
  }

  // Future<void> _sendTimeTrackingApi(int totalTime) async {
  //   try {
  //     VideoRepository().updateTime(
  //       customerTrackWithVideoId: _videoId ?? 0,
  //       time: totalTime,
  //     );
  //   } catch (e) {
  //     print('Lỗi khi gửi API tracking: $e');
  //   }
  // }

  /// 🔐 Security setup
  Future<void> _initSecurity() async {
    // Bật chặn chụp và quay màn hình cho CẢ Android và iOS
    await ScreenProtector.preventScreenshotOn();

    if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlur();

      bool isRecording = await ScreenProtector.isRecording();
      setState(() => _isRecording = isRecording);

      _recordingSub = Stream.periodic(const Duration(seconds: 1)).listen((
        _,
      ) async {
        bool recording = await ScreenProtector.isRecording();
        if (recording != _isRecording) {
          setState(() => _isRecording = recording);
        }
      });
    }
  }

  /// 🌐 WebView setup + detect fullscreen
  void _initWebView() {
    HomeRepo().getUserProfile().then((res) {
      setState(() {
        watermarkText = '${res.fullName ?? ""} - ${res.phone ?? ""}';
      });
      _controller.runJavaScript('''
        var wm = document.getElementById("flutter-watermark");
        if (wm) {
          wm.innerHTML = "$watermarkText";
        }
      ''');
    });

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // Khóa inline cho iOS
        mediaTypesRequiringUserAction:
            const <PlaybackMediaTypes>{}, // Bật tự động phát cho iOS
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    String extractIframeUrl(String input) {
      final RegExp regExp = RegExp(r'src="([^"]+)"');
      final match = regExp.firstMatch(input);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)!;
      }
      return input;
    }

    String videoUrl = extractIframeUrl(widget.streamingUrl);

    final String htmlContent =
        '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        body { margin: 0; padding: 0; background-color: black; overflow: hidden; }
        iframe { width: 100vw; height: 100vh; border: none; }
      </style>
    </head>
    <body>
      <iframe 
        src="$videoUrl" 
        allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;" 
        allowfullscreen="true">
      </iframe>
    </body>
    </html>
    ''';
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString(
        htmlContent,
        // QUAN TRỌNG NHẤT: Thay domain này bằng domain đã được allow trong cấu hình Bunny.net của bạn
        // Bước này giúp lừa server Bunny rằng request đang đến từ trang web hợp lệ, giúp thoát lỗi 403.
        baseUrl: 'https://lms.cogiaohealthy.vn/',
      )
      ..addJavaScriptChannel(
        'VideoChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'video_ended') {
            if (mounted) {
              Navigator.pop(context, true);
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // CHẶN PHÓNG TO VÀ CHÈN WATERMARK DI CHUYỂN
            await _controller.runJavaScript('''
          // Bước A: Ẩn nút Fullscreen bằng CSS
          var style = document.createElement('style');
          style.innerHTML = `
            video::-webkit-media-controls-fullscreen-button { display: none !important; }
            video::-internal-media-controls-fullscreen-button { display: none !important; }
            .fullscreen-button, .custom-fs-btn { display: none !important; }
          `;
          document.head.appendChild(style);

          // Bước B: Bẻ gãy tính năng Fullscreen của Javascript API
          Element.prototype.requestFullscreen = function() { return Promise.reject(); };
          Element.prototype.webkitRequestFullscreen = function() { return Promise.reject(); };
          Element.prototype.mozRequestFullScreen = function() { return Promise.reject(); };
          Element.prototype.msRequestFullscreen = function() { return Promise.reject(); };
          
          // Bước C: Chèn watermark trên khung hiển thị
          if (!document.getElementById("flutter-watermark")) {
            var wm = document.createElement("div");
            wm.id = "flutter-watermark";
            wm.innerHTML = "$watermarkText";
            wm.style.position = "absolute"; 
            wm.style.color = "rgba(255, 255, 255, 0.6)";
            wm.style.fontSize = "14px";
            wm.style.fontWeight = "bold";
            wm.style.zIndex = "999999"; 
            wm.style.pointerEvents = "none";
            wm.style.textShadow = "1px 1px 2px rgba(0, 0, 0, 0.8)"; 
            wm.style.transition = "all 0.5s ease"; // Cho phép mượt mà khi đổi góc
            
            document.body.appendChild(wm);
            
            var currentIndex = 0;
            function updatePosition() {
              var wm = document.getElementById("flutter-watermark");
              if (!wm) return;

              var padding = 20;
              var bottomOffset = 60; // Tránh thanh điều khiển video ở dưới
              var wmWidth = wm.offsetWidth || 150; 
              var wmHeight = wm.offsetHeight || 20;
              var w = window.innerWidth;
              var h = window.innerHeight;

              // Reset toàn bộ CSS vị trí
              wm.style.top = "auto"; 
              wm.style.bottom = "auto"; 
              wm.style.left = "auto"; 
              wm.style.right = "auto";

              // Gắn tọa độ theo 4 góc màn hình
              if (currentIndex === 0) { // Góc trên trái
                wm.style.top = padding + "px";
                wm.style.left = padding + "px";
              } else if (currentIndex === 1) { // Góc trên phải
                wm.style.top = padding + "px";
                wm.style.left = (w - wmWidth - padding) + "px";
              } else if (currentIndex === 2) { // Góc dưới phải
                wm.style.bottom = bottomOffset + "px";
                wm.style.left = (w - wmWidth - padding) + "px";
              } else if (currentIndex === 3) { // Góc dưới trái
                wm.style.bottom = bottomOffset + "px";
                wm.style.left = padding + "px";
              }
            }

            // Gọi thử liên tục trong thời gian đầu để chắc chắn kích thước đúng
            var initCount = 0;
            var initInterval = setInterval(function() {
              updatePosition();
              initCount++;
              if (initCount > 10) clearInterval(initInterval);
            }, 500);

            setInterval(function() {
              currentIndex = (currentIndex + 1) % 4;
              updatePosition();
            }, 3500);

          // Sử dụng Event Capturing để bắt sự kiện ended kể cả khi video được tạo động (ended không bubble)
          document.addEventListener('ended', function(e) {
            if (e.target && e.target.tagName && e.target.tagName.toLowerCase() === 'video') {
              try {
                if (typeof VideoChannel !== 'undefined') {
                  VideoChannel.postMessage('video_ended');
                } else if (window.VideoChannel) {
                  window.VideoChannel.postMessage('video_ended');
                }
              } catch(err) {
                console.error(err);
              }
            }
          }, true);
        }
        ''');
          },
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(
            false,
          ); // Bật tự động phát cho Android
    }

    //_controller.loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);
    _recordingSub?.cancel();
    ScreenProtector.preventScreenshotOff();
    _trackingTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: mainDarkGreen,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.name,
              style: defaultText16B.copyWith(color: Colors.white),
            ),
            leading: IconButton(
              onPressed: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isLandscape = !_isLandscape;
                  });
                  if (_isLandscape) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  }
                },
                icon: Icon(
                  _isLandscape
                      ? Icons.screen_lock_portrait
                      : Icons.screen_rotation,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: MediaQuery.of(context).orientation == Orientation.landscape
              ? WebViewWidget(controller: _controller)
              : Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: WebViewWidget(controller: _controller),
                    ),
                    Expanded(
                      child: SingleChildScrollView(child: _buildTextContent()),
                    ),
                  ],
                ),
        ),
        if (_isRecording) _buildBlockOverlay("Screen recording is not allowed"),
        if (_isFullscreen && Platform.isIOS)
          _buildBlockOverlay("Fullscreen is restricted"),
      ],
    );
  }

  Widget _buildBlockOverlay(String text) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildTextContent() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nội dung chi tiết', style: defaultText16B),
          Html(data: widget.description),
          if (widget.isShow == 'true' && widget.courses != null) ...[
            SizedBox(height: 28.h),
            Text('Nội dung khoá học'.sanitizeForApple, style: defaultText16B),
            if (widget.percentLearning != null)
              Row(
                children: [
                  Container(
                    height: 8.h,
                    width: 270.w,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Container(
                      height: 8.h,
                      width: 270.w * ((widget.percentLearning ?? 0) / 100),
                      decoration: BoxDecoration(
                        color: mainDarkGreen,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  Text(
                    '  ${widget.percentLearning}%',
                    style: defaultText16B.copyWith(color: mainDarkGreen),
                  ),
                ],
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.courses?.topicals?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return LessonItem(
                  index: index,
                  topicModel: widget.courses?.topicals![index],
                  courses: widget.courses,
                  percentLearning: widget.percentLearning,
                  isShow: widget.isShow,
                );
              },
            ),
            if (widget.courses?.loTrinh != null &&
                widget.courses!.loTrinh!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nguyên liệu liên quan',
                    style: defaultText18B.copyWith(
                      color: const Color(0xff00204A),
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  RichText(
                    text: TextSpan(
                      text: 'Xem đầy đủ tại ',
                      style: defaultText16M.copyWith(
                        color: const Color(0xff00204A),
                      ),
                      children: [
                        TextSpan(
                          text: 'Gian hàng nguyên liệu',
                          style: defaultText16B.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDetailProductScreen(
                            categorySlug:
                                widget.courses?.slugProductCateGory ?? '',
                            categoryName: '',
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://lms.cogiaohealthy.vn/images/${widget.courses?.loTrinh}',
                        width: 343.w,
                        fit: BoxFit.fitWidth,
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDetailProductScreen(
                            categorySlug:
                                widget.courses?.slugProductCateGory ?? '',
                            categoryName: '',
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListDetailProductScreen(
                                  categorySlug:
                                      widget.courses?.slugProductCateGory ?? '',
                                  categoryName: '',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Text(
                              'Mua ngay',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
