import 'package:flutter/material.dart';
import 'page_manager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'ProfileDetails.dart' as profile;
import "PodcastView.dart";

class podcastplayer extends StatefulWidget {
  final id;
  final pos;

  const podcastplayer({Key? key, required this.id, required this.pos})
      : super(key: key);

  @override
  State<podcastplayer> createState() => _podcastplayerState();
}

class _podcastplayerState extends State<podcastplayer> {
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(podId: widget.id);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<ProgressBarState>(
          valueListenable: _pageManager.progressNotifier,
          builder: (_, value, __) {
            return ProgressBar(
              progress: value.current,
              buffered: value.buffered,
              total: value.total,
              onSeek: _pageManager.seek,
              progressBarColor: Colors.white,
              baseBarColor: Colors.white.withOpacity(0.24),
              bufferedBarColor: Colors.white.withOpacity(0.24),
              thumbColor: Colors.white,
              timeLabelTextStyle: const TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.fast_rewind),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {
                if (widget.pos <= 0) {
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return podcastview(
                        podcast: profile.allPodcasts[widget.pos - 1]);
                  }));
                }
              },
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 100.0,
                      color: Colors.white,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 100.0,
                      color: Colors.white,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.fast_forward),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {
                if (widget.pos >= (profile.allPodcasts.length - 1)) {
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return podcastview(
                        podcast: profile.allPodcasts[widget.pos + 1]);
                  }));
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
