import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;
  final double? aspectRatio;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.autoPlay = true,
    this.aspectRatio,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _visibility = 0.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
      if (widget.autoPlay && _visibility > 0.5) {
        _controller.play();
        _controller.setLooping(true);
        setState(() => _isPlaying = true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final visibility = info.visibleFraction;
    setState(() => _visibility = visibility);

    if (widget.autoPlay) {
      if (visibility > 0.5 && !_isPlaying && _isInitialized) {
        _controller.play();
        _controller.setLooping(true);
        setState(() => _isPlaying = true);
      } else if (visibility <= 0.5 && _isPlaying) {
        _controller.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: _onVisibilityChanged,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio ?? 9 / 16,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isInitialized)
              VideoPlayer(_controller)
            else if (widget.thumbnailUrl != null)
              Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.black);
                },
              )
            else
              Container(color: Colors.black),
            if (!_isInitialized)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

