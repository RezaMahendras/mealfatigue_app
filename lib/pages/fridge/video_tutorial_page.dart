import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import package video player

class VideoTutorialPage extends StatefulWidget {
  final String videoAssetPath; // Path ke file video di assets
  final String recipeTitle;    // Judul resep untuk ditampilkan di AppBar

  const VideoTutorialPage({Key? key, required this.videoAssetPath, required this.recipeTitle}) : super(key: key);

  @override
  State<VideoTutorialPage> createState() => _VideoTutorialPageState();
}

class _VideoTutorialPageState extends State<VideoTutorialPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan aset video
    _controller = VideoPlayerController.asset(widget.videoAssetPath);
    // Inisialisasi video player, ini proses async
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Pastikan UI diperbarui setelah inisialisasi selesai
      setState(() {});
      // Otomatis play video setelah siap
      _controller.play();
    });
    // Loop video agar berulang terus
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller saat halaman ditutup untuk hemat memori
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam agar fokus ke video
      appBar: AppBar(
        title: Text(widget.recipeTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Jika video siap, tampilkan player dengan aspek rasio yang benar
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    // Tambahkan VideoProgressIndicator untuk kontrol
                    VideoProgressIndicator(_controller, allowScrubbing: true, colors: VideoProgressColors(playedColor: Color(0xFFE96440))),
                    // Tombol Play/Pause di tengah
                    Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        },
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: Colors.white.withOpacity(0.7),
                          size: 64,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Tampilkan loading saat video sedang disiapkan
              return const CircularProgressIndicator(color: Color(0xFFE96440));
            }
          },
        ),
      ),
    );
  }
}
