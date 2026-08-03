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
  bool _isLoading = true;
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
        var wms = document.getElementsByClassName("wm-item");
        for(var i = 0; i < wms.length; i++) {
          wms[i].innerHTML = "$watermarkText";
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
        .block-overlay { position: absolute; bottom: 0; right: 0; width: 60px; height: 50px; z-index: 9999; background: transparent; }
      </style>
    </head>
    <body>
      <div style="position: relative; width: 100vw; height: 100vh;">
        <iframe 
          src="$videoUrl" 
          style="position: absolute; top: 0; left: 0; width: 100vw; height: 100vh; border: none;"
          allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;">
        </iframe>
        <!-- Lớp phủ trong suốt chặn mọi thao tác nhấn vào nút fullscreen mặc định của player ở góc dưới phải -->
        <div class="block-overlay" onclick="if (window.VideoChannel) window.VideoChannel.postMessage('toggle_fullscreen');"></div>
      </div>
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
          if (message.message == 'toggle_fullscreen') {
            if (mounted) {
              bool isCurrentlyLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              setState(() {
                _isLandscape = !isCurrentlyLandscape;
              });
              if (!isCurrentlyLandscape) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              }
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            // CHẶN PHÓNG TO VÀ CHÈN WATERMARK DI CHUYỂN
            await _controller.runJavaScript('''
          // Ẩn nút Fullscreen bằng CSS (dành cho iOS native hoặc video player)
          var style = document.createElement('style');
          style.innerHTML = `
            video::-webkit-media-controls-fullscreen-button { display: none !important; }
            video::-internal-media-controls-fullscreen-button { display: none !important; }
            .fullscreen-button, .custom-fs-btn { display: none !important; }
          `;
          document.head.appendChild(style);

          // Ngăn chặn thao tác phóng to (pinch-to-zoom và double tap)
          document.addEventListener('touchmove', function(event) {
            if (event.scale !== 1) {
              event.preventDefault();
            }
          }, { passive: false });
          var lastTouchEnd = 0;
          document.addEventListener('touchend', function(event) {
            var now = (new Date()).getTime();
            if (now - lastTouchEnd <= 300) {
              event.preventDefault();
            }
            lastTouchEnd = now;
          }, false);
          
          // Bước C: Chèn watermark trên khung hiển thị
          if (!document.getElementById("flutter-watermark-container")) {
            var container = document.createElement("div");
            container.id = "flutter-watermark-container";
            container.style.position = "absolute";
            container.style.top = "0";
            container.style.left = "0";
            container.style.width = "100%";
            container.style.height = "100%";
            container.style.pointerEvents = "none";
            container.style.zIndex = "999999";
            container.style.overflow = "hidden";
            
            document.body.appendChild(container);

            var style = document.createElement('style');
            style.innerHTML = `
              @keyframes moveHorizontally1 {
                0% { transform: translateX(100vw); }
                100% { transform: translateX(-100%); }
              }
              @keyframes moveHorizontally2 {
                0% { transform: translateX(-100%); }
                100% { transform: translateX(100vw); }
              }
              .wm-item {
                position: absolute;
                color: rgba(255, 255, 255, 0.4);
                font-size: 14px;
                font-weight: bold;
                pointer-events: none;
                text-shadow: none;
                white-space: nowrap;
              }
            `;
            document.head.appendChild(style);

            var numWatermarks = 5;
            for (var i = 0; i < numWatermarks; i++) {
               var wm = document.createElement("div");
               wm.className = "wm-item";
               wm.innerHTML = "$watermarkText";
               
               // Random height between 10% and 85%
               var topPercent = 10 + Math.random() * 75;
               wm.style.top = topPercent + "%";
               
               // Random duration between 15s and 25s
               var duration = 15 + Math.random() * 10;
               
               // Random start delay
               var delay = -(Math.random() * 20);
               
               // Alternate direction
               var animName = (i % 2 === 0) ? "moveHorizontally1" : "moveHorizontally2";
               
               wm.style.animation = animName + " " + duration + "s linear " + delay + "s infinite";
               container.appendChild(wm);
            }

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
          appBar: MediaQuery.of(context).orientation == Orientation.landscape
              ? null
              : AppBar(
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
                        bool isCurrentlyLandscape =
                            MediaQuery.of(context).orientation ==
                            Orientation.landscape;
                        setState(() {
                          _isLandscape = !isCurrentlyLandscape;
                        });
                        if (!isCurrentlyLandscape) {
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
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? Icons.screen_lock_portrait
                            : Icons.screen_rotation,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
          body: MediaQuery.of(context).orientation == Orientation.landscape
              ? Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(color: mainDarkGreen),
                      ),
                    _buildCustomFullscreenButton(),
                  ],
                )
              : Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        children: [
                          WebViewWidget(controller: _controller),
                          if (_isLoading)
                            Center(
                              child: CircularProgressIndicator(
                                color: mainDarkGreen,
                              ),
                            ),
                          _buildCustomFullscreenButton(),
                        ],
                      ),
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
                    child: RichText(
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

  Widget _buildCustomFullscreenButton() {
    bool isCurrentlyLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Positioned(
      bottom: 8.h,
      right: 8.w,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLandscape = !isCurrentlyLandscape;
          });
          if (!isCurrentlyLandscape) {
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
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.8,
            ), // Đen đặc để che hoàn toàn nút bên dưới
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            isCurrentlyLandscape ? Icons.fullscreen_exit : Icons.fullscreen,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
