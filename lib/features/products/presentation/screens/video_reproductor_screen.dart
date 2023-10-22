import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoReproductorScreen extends StatefulWidget {
  final String video;
  const VideoReproductorScreen({super.key, required this.video});

  @override
  State<VideoReproductorScreen> createState() => _VideoReproductorScreenState();
}

class _VideoReproductorScreenState extends State<VideoReproductorScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video))
      ..initialize().then((_) {
        // Asegúrate de que el controlador esté inicializado antes de mostrar el video.
        setState(() {});
        _controller.play();
        //_controller.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
