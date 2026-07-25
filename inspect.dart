import 'package:youtube_player_flutter/youtube_player_flutter.dart';
void main() {
  YoutubePlayerBuilder(
    onEnterFullScreen: () {},
    player: YoutubePlayer(controller: YoutubePlayerController(initialVideoId: '')),
    builder: (context, player) => player,
  );
}
