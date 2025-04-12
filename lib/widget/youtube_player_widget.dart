import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class YoutubePlayerBuilderWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerBuilderWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _YoutubePlayerBuilderWidgetState createState() =>
      _YoutubePlayerBuilderWidgetState();
}

class _YoutubePlayerBuilderWidgetState
    extends State<YoutubePlayerBuilderWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = extractYoutubeVideoId(widget.videoUrl);
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
        return Container(
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
