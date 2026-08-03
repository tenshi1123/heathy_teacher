import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String slug;
  final List<PostModel> relatedRecipes;
  const RecipeDetailScreen({
    super.key,
    required this.slug,
    required this.relatedRecipes,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isLoading = true;
  late PostModel item;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      item = await HomeRepo().getDetailPost(widget.slug);
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu người dùng: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: mainDarkGreen,
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    DefaultAppBar(),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
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
                                    style: defaultText12M.copyWith(
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      TextSpan(text: 'Trang chủ > Blog > '),
                                      TextSpan(
                                        text: item.title,
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
                                  item.title,
                                  style: defaultText20B.copyWith(
                                    color: mainDarkGreen,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                // Date
                                Text(
                                  item.date,
                                  style: defaultText12M.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 24.h),

                                // Dummy Content
                                HtmlWidget(
                                  item.content ?? '',
                                  customWidgetBuilder: (element) {
                                    // Kiểm tra nếu thẻ đang parse là iframe
                                    if (element.localName == 'iframe') {
                                      final src =
                                          element.attributes['src'] ?? '';

                                      // Nếu link là của YouTube
                                      if (src.contains('youtube.com') ||
                                          src.contains('youtu.be')) {
                                        // Tách ID video từ URL
                                        final videoId =
                                            YoutubePlayer.convertUrlToId(src);

                                        if (videoId != null) {
                                          final controller =
                                              YoutubePlayerController(
                                                initialVideoId: videoId,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                  enableCaption: false,
                                                ),
                                              );

                                          return YoutubePlayer(
                                            controller: controller,
                                            showVideoProgressIndicator: true,
                                            bottomActions: [
                                              const CurrentPosition(),
                                              const ProgressBar(
                                                isExpanded: true,
                                              ),
                                              const RemainingDuration(),
                                              const PlaybackSpeedButton(),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.fullscreen,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  controller.pause();
                                                  final position =
                                                      await Navigator.push<
                                                        Duration
                                                      >(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              _FullScreenVerticalYoutubePlayer(
                                                                videoId:
                                                                    videoId,
                                                                startAt:
                                                                    controller
                                                                        .value
                                                                        .position,
                                                              ),
                                                        ),
                                                      );
                                                  if (position != null) {
                                                    controller.seekTo(position);
                                                  }
                                                  controller.play();
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                    }
                                    // Trả về null để các thẻ khác (p, div, text) tiếp tục hiển thị bình thường
                                    return null;
                                  },
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
                                RecipeGridWidget(
                                  recipes: widget.relatedRecipes.length > 4
                                      ? widget.relatedRecipes.sublist(0, 4)
                                      : widget.relatedRecipes,
                                  type: 1,
                                ),
                                SizedBox(height: 40.h),
                              ],
                            ),
                          ),

                    // Footer
                    const CustomFooterInfo(),
                  ],
                ),
              ),
            ),
          ),
          BottomCustom(),
        ],
      ),
    );
  }
}

class _FullScreenVerticalYoutubePlayer extends StatefulWidget {
  final String videoId;
  final Duration startAt;

  const _FullScreenVerticalYoutubePlayer({
    required this.videoId,
    required this.startAt,
  });

  @override
  State<_FullScreenVerticalYoutubePlayer> createState() =>
      _FullScreenVerticalYoutubePlayerState();
}

class _FullScreenVerticalYoutubePlayerState
    extends State<_FullScreenVerticalYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        startAt: widget.startAt.inSeconds,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _controller.value.position);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio:
                  MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height,
              showVideoProgressIndicator: true,
              bottomActions: [
                const CurrentPosition(),
                const ProgressBar(isExpanded: true),
                const RemainingDuration(),
                const PlaybackSpeedButton(),
                IconButton(
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, _controller.value.position);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
