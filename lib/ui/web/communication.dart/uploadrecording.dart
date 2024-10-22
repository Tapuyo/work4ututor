import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:work4ututor/utils/themes.dart';

class VideoUploadWidget extends StatefulWidget {
  final String videolink;
  const VideoUploadWidget({super.key, required this.videolink});

  @override
  // ignore: library_private_types_in_public_api
  _VideoUploadWidgetState createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends State<VideoUploadWidget> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

  VideoPlayerController? _videoPlayerController;
  double _sliderValue = 0.0;
  bool _isDraggingSlider = false;
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videolink))
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play();
          });

    _videoPlayerController!.addListener(() {
      if (!_isDraggingSlider) {
        setState(() {
          _sliderValue =
              _videoPlayerController!.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  void _pauseVideo() {
    if (_videoPlayerController!.value.isPlaying) {
      _videoPlayerController?.pause();
    } else {
      _videoPlayerController?.play();
    }
  }

  void _seekBackward() {
    final Duration currentPosition = _videoPlayerController!.value.position;
    final Duration seekTime = currentPosition - const Duration(seconds: 10);
    _videoPlayerController?.seekTo(seekTime);
  }

  void _seekForward() {
    final Duration currentPosition = _videoPlayerController!.value.position;
    final Duration seekTime = currentPosition + const Duration(seconds: 10);
    _videoPlayerController?.seekTo(seekTime);
  }

  void _seekTo(double seconds) {
    final Duration seekTime = Duration(seconds: seconds.round());
    _videoPlayerController?.seekTo(seekTime);
  }

  void _handleDragStart() {
    setState(() {
      _isDraggingSlider = true;
    });
    _videoPlayerController?.pause();
  }

  void _handleDragUpdate(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _handleDragEnd() {
    setState(() {
      _isDraggingSlider = false;
    });
    _seekTo(_sliderValue);
    _videoPlayerController?.play();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.1, 0),
              end: Alignment.centerRight,
              colors: secondaryHeadercolors, // Define this list of colors
            ),
          ),
        ),
        title: const Text(
          'Tutor Presentation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.videolink.isNotEmpty && _videoPlayerController != null)
            SizedBox(
              height: height - 104,
              width: width,
              child: GestureDetector(
                onTap: () {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                  }
                },
                onHorizontalDragStart: (_) => _handleDragStart(),
                onHorizontalDragUpdate: (details) =>
                    _handleDragUpdate(details.primaryDelta!),
                onHorizontalDragEnd: (_) => _handleDragEnd(),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoPlayerController!),
                      if (!_videoPlayerController!.value.isPlaying)
                        const Icon(
                          Icons.play_arrow,
                          size: 100.0,
                          color: Colors.white,
                        ),
                      if (widget.videolink.isNotEmpty)
                        Positioned(
                          bottom: 0, // Set the bottom position
                          left: 0, // Adjust left position if needed
                          right: 0,
                          child: Slider(
                            activeColor: kColorPrimary,
                            min: 0.0,
                            max: _videoPlayerController!
                                .value.duration.inSeconds
                                .toDouble(),
                            value: _sliderValue,
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                              });
                              _seekTo(value);
                            },
                            onChangeStart: (value) {
                              setState(() {
                                _isDraggingSlider = true;
                              });
                              _pauseVideo();
                            },
                            onChangeEnd: (value) {
                              setState(() {
                                _isDraggingSlider = false;
                              });
                              _seekTo(value);
                              _videoPlayerController!.play();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _seekBackward,
            icon: const Icon(Icons.replay_10),
          ),
          IconButton(
            onPressed: _pauseVideo,
            icon: Icon(
              _videoPlayerController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
          ),
          IconButton(
            onPressed: _seekForward,
            icon: const Icon(Icons.forward_10),
          ),
        ],
      ),
    );
  }
}
