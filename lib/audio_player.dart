import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:provider/provider.dart';
import 'song_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration();
  Duration position = Duration();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<SongProvider>(context, listen: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setAudio(provider.currentSong.previewUrl); // 确保只在需要的时候调用setAudio
    });
  }

  @override
  void initState() {
    super.initState();
    setupAudioEvents();
  }

  void setupAudioEvents() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> setAudio([String? url]) async {
    if (url != null && url.isNotEmpty) {
      await audioPlayer.setSourceUrl(url);
      playAudio();
    }
  }

  void playAudio() async {
    await audioPlayer.resume();
  }

  void pauseAudio() async {
    await audioPlayer.pause();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvider>(context); // 监听Provider变化
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(provider.currentSong.trackName,
              style: TextStyle(fontSize: 20.0)),
          Slider(
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (double value) async {
              await audioPlayer.seek(Duration(seconds: value.toInt()));
              await audioPlayer.resume();
            },
          ),
          Text(
              '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 12.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10),
                iconSize: 40.0,
                onPressed: () async {
                  await audioPlayer
                      .seek(Duration(seconds: position.inSeconds - 10));
                },
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 64.0,
                onPressed: () {
                  if (!isPlaying &&
                      provider.currentSong.previewUrl.isNotEmpty) {
                    playAudio();
                  } else {
                    pauseAudio();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10),
                iconSize: 40.0,
                onPressed: () async {
                  await audioPlayer
                      .seek(Duration(seconds: position.inSeconds + 10));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
