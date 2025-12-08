import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/youtube_utils.dart' as custom_utils;

/// A reusable widget to play YouTube videos using [youtube_player_flutter].
class YoutubePlayerBuilderWidget extends StatefulWidget {
  /// The YouTube video URL (e.g., https://www.youtube.com/watch?v=abc123).
  final String videoUrl;

  const YoutubePlayerBuilderWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<YoutubePlayerBuilderWidget> createState() =>
      _YoutubePlayerBuilderWidgetState();
}

class _YoutubePlayerBuilderWidgetState
    extends State<YoutubePlayerBuilderWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Extract the videoId from the given URL
    final videoId = custom_utils.extractYoutubeVideoId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).primaryColor,
      ),
      builder: (context, player) {
        return SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: player,
          ),
        );
      },
    );
  }
}
