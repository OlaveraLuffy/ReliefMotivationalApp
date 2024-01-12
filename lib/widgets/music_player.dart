import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  String currentSong = 'Song Title'; // Replace with your initial song title
  List<String> songs = ['Aloha.mp3', 'Symmetry.mp3', 'Waves.mp3'];
  int currentSongIndex = 0;
  double volume = 0.5;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.setVolume(volume);

    // Listen for changes in player state
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        // The song has finished playing, update the current song title or perform other actions
        setState(() {
          isPlaying = false;
          // Move to the next song
          currentSongIndex = (currentSongIndex + 1) % songs.length;
          currentSong = songs[currentSongIndex];
        });
      }
    });
  }

  Future<void> _playPause() async {
    if (currentSong != 'Song Title') {
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
  }

  void _skip() {
    // Stop the current song before moving to the next one
    _audioPlayer.stop();
    // Move to the next song
    setState(() {
      currentSongIndex = (currentSongIndex + 1) % songs.length;
      currentSong = songs[currentSongIndex];
    });
    // Start playing the next song
    _playPause();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                onPressed: () async {
                  await _playPause();
                },
              ),
              Text('Now Playing: $currentSong'),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _skip,
              ),
            ],
          ),
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
