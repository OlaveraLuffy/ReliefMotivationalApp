import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer _audioPlayer;
  bool isPlaying= false;
  String currentSong = 'Song Title';
  List<String> songs = ['Waves.mp3'];
  int currentSongIndex = 0;
  double volume = 0.5;

  bool showVolumeSlider = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.setVolume(volume);

    // Listen for changes in player state
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        // The song has finished playing, update the current song title or perform other actions
        _skip();
      }
    });

    if (songs.isNotEmpty) {
      currentSong = songs.first;
      _playPause(); // Auto play when Home is initialized
    }
  }

  Future<void> _playPause() async {
    String songPath = currentSong;
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_audioPlayer.state == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(AssetSource('audio/music/$songPath'));
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _skip() {
    if (songs.isNotEmpty) {
      // Move to the next song
      currentSongIndex = (currentSongIndex + 1) % songs.length;
      currentSong = songs[currentSongIndex];

      // Set isPlaying to false before calling _playPause
      // to ensure it starts playing the next song
      isPlaying = false;

      _playPause();
    }
  }

  void _changeVolume(double value) {
    _audioPlayer.setVolume(value);
    setState(() {
      volume = value;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF879d55),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                onPressed: () async {
                  await _playPause();
                },
              ),
              Container(
                height: 30,
                width: 2,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text('Now Playing: $currentSong',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 30,
                width: 2,
                color: Colors.white,
              ),
              IconButton(
                icon: showVolumeSlider ? const Icon(Icons.arrow_drop_down) : const Icon(Icons.arrow_drop_up),
                onPressed: () async {
                  setState(() {
                    showVolumeSlider = !showVolumeSlider;
                  });
                },
              ),
            ],
          ),
          if (showVolumeSlider)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Icon(Icons.volume_down),
                ),
                Expanded(
                  child: Slider(
                    value: volume,
                    onChanged: _changeVolume,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 13),
                  child: Icon(Icons.volume_up),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
