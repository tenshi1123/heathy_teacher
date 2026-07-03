import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class DetailVideo extends StatefulWidget {
  const DetailVideo({
    super.key,

    required this.name,
    required this.streamingUrl,
  });

  final String streamingUrl;
  final String name;
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
    String watermarkText = "Bản quyền thuộc về CGH";

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
        src="${widget.streamingUrl}" 
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
          
          // Bước C: Chèn watermark giới hạn TRONG KHUNG VIDEO
          if (!document.getElementById("flutter-watermark")) {
          var wm = document.createElement("div");
          wm.id = "flutter-watermark";
          wm.innerHTML = "$watermarkText";
          wm.style.position = "absolute"; // Đổi thành absolute
          wm.style.color = "rgba(255, 165, 0, 0.8)";
          wm.style.fontSize = "14px";
          wm.style.fontWeight = "bold";
          wm.style.zIndex = "999999"; 
          wm.style.pointerEvents = "none";
          wm.style.textShadow = "1px 1px 2px rgba(0, 0, 0, 0.8)"; 
          wm.style.transition = "all 0.3s ease"; // Cho phép mượt mà khi đổi góc
          // Tìm thẻ chứa video (Thường BunnyCDN dùng Plyr player)
          var videoElement = document.querySelector('video');
          var videoContainer = videoElement ? videoElement.parentElement : document.body;
          // Đảm bảo container chứa video có position relative để watermark neo theo
          if (getComputedStyle(videoContainer).position === "static") {
          videoContainer.style.position = "relative";
          }
          videoContainer.appendChild(wm);
          var currentIndex = 0;
          function updatePosition() {
            var video = document.querySelector('video');
            var wm = document.getElementById("flutter-watermark");
            if (!video || !wm) return;

            var rect = video.getBoundingClientRect();
            var vw = video.videoWidth;
            var vh = video.videoHeight;

            // Đợi đến khi video tải xong metadata mới có kích thước thực
            if (!vw || !vh) return;

            var videoRatio = vw / vh;
            var containerRatio = rect.width / rect.height;

            var actualWidth = rect.width;
            var actualHeight = rect.height;
            var startX = rect.left;
            var startY = rect.top;

            // BƯỚC QUAN TRỌNG: Loại bỏ khoảng viền đen (Black bars)
            if (containerRatio > videoRatio) {
              // Viền đen ở 2 bên trái/phải (Ví dụ: Video dọc xem trên màn hình ngang)
              actualWidth = rect.height * videoRatio;
              startX = rect.left + (rect.width - actualWidth) / 2;
            } else {
              // Viền đen ở trên/dưới (Ví dụ: Video ngang xem trên màn hình đứng)
              actualHeight = rect.width / videoRatio;
              startY = rect.top + (rect.height - actualHeight) / 2;
            }

            var padding = 15;
            var bottomOffset = 50; // Tránh thanh điều khiển video
            var wmWidth = wm.offsetWidth || 150; 
            var wmHeight = wm.offsetHeight || 20;

            // Reset toàn bộ CSS vị trí
            wm.style.top = "auto"; 
            wm.style.bottom = "auto"; 
            wm.style.left = "auto"; 
            wm.style.right = "auto";

            // Gắn tọa độ theo góc của VÙNG HÌNH ẢNH THỰC TẾ
            if (currentIndex === 0) { // Góc trên trái
              wm.style.top = (startY + padding) + "px";
              wm.style.left = (startX + padding) + "px";
            } else if (currentIndex === 1) { // Góc trên phải
              wm.style.top = (startY + padding) + "px";
              wm.style.left = (startX + actualWidth - wmWidth - padding) + "px";
            } else if (currentIndex === 2) { // Góc dưới phải
              wm.style.top = (startY + actualHeight - wmHeight - bottomOffset) + "px";
              wm.style.left = (startX + actualWidth - wmWidth - padding) + "px";
            } else if (currentIndex === 3) { // Góc dưới trái
              wm.style.top = (startY + actualHeight - wmHeight - bottomOffset) + "px";
              wm.style.left = (startX + padding) + "px";
            }
          }

          updatePosition();

          setInterval(function() {
            currentIndex = (currentIndex + 1) % 4;
            updatePosition();
          }, 3000); 

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
          body: WebViewWidget(controller: _controller),
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
}
