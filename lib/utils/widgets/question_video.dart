import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuestionVideo extends StatefulWidget {
  final String questionLink;
  const QuestionVideo({super.key, required this.questionLink});

  @override
  State<QuestionVideo> createState() => _QuestionVideoState();
}

class _QuestionVideoState extends State<QuestionVideo> {
  late VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void didChangeDependencies() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(
          Uri.parse(widget.questionLink),
        );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data ?? false) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
              );
            } else if(snapshot.hasError){
              // print(snapshot.error);
              return const Text("Something went wrong...");
            }
            else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}


class QuestionYoutubeVideoPlayer extends StatefulWidget {
  final String id;
  const QuestionYoutubeVideoPlayer({super.key, required this.id});

  @override
  State<QuestionYoutubeVideoPlayer> createState() => _QuestionYoutubeVideoPlayerState();
}

class _QuestionYoutubeVideoPlayerState extends State<QuestionYoutubeVideoPlayer> {
  YoutubePlayerController? _controller;
  @override
  void didChangeDependencies() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return _controller != null ? YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Colors.orange,
        handleColor: Colors.orangeAccent,
      ),
      bottomActions: const [
        SizedBox(width: 14.0),
        CurrentPosition(),
        SizedBox(width: 8.0),
        ProgressBar(colors: ProgressBarColors(handleColor: Colors.orangeAccent,backgroundColor: Colors.orange),isExpanded: true,),
        // RemainingDuration(),
        // PlaybackSpeedButton(),
      ],
      aspectRatio: 16/9,
      width: MediaQuery.sizeOf(context).width,
      liveUIColor: Colors.orange,
    ) : const SizedBox();
  }
}
