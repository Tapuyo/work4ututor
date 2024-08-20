import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:work4ututor/utils/themes.dart';

import '../../../shared_components/header_text.dart';

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

  // Future<String> uploadFile(html.File file) async {
  //   final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

  //   try {
  //     final Reference videoRef = storageRef.child('videos/$fileName');

  //     final reader = html.FileReader();
  //     reader.readAsArrayBuffer(file);
  //     await reader.onLoad.first;
  //     final Uint8List fileBytes = reader.result as Uint8List;

  //     final UploadTask uploadTask = videoRef.putData(fileBytes);

  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       setState(() {
  //         _progress = snapshot.bytesTransferred / snapshot.totalBytes;
  //       });
  //     });

  //     final TaskSnapshot uploadSnapshot =
  //         await uploadTask.whenComplete(() => null);
  //     final String downloadUrl = await uploadSnapshot.ref.getDownloadURL();

  //     return downloadUrl;
  //   } catch (e) {
  //     print(e.toString());
  //     throw Exception('Error uploading video');
  //   }
  // }

  // void _handleFileUpload(html.File file) {
  //   uploadFile(file).then((String downloadUrl) {
  //     setState(() {
  //       _downloadUrl = downloadUrl;
  //     });
  //     // Handle successful upload
  //     print('Video uploaded successfully. Download URL: $downloadUrl');
  //     _initializeVideoPlayer();
  //   }).catchError((e) {
  //     // Handle upload failure
  //     print('Error uploading video: $e');
  //   });
  // }

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

  // void _openFilePicker() {
  //   final uploadInput = html.FileUploadInputElement();
  //   uploadInput.multiple = false;
  //   uploadInput.accept = 'video/*';
  //   uploadInput.click();

  //   uploadInput.onChange.listen((e) {
  //     final html.File file = (uploadInput.files! as List<html.File>)[0];
  //     _handleFileUpload(file);
  //   });
  // }

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
        title: const HeaderText('Tutor Presentation'),
      ),
      body: Container(
        height: height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: _openFilePicker,
            //   child: const Text('Upload Video'),
            // ),
            // const SizedBox(height: 16.0),
            // LinearProgressIndicator(
            //   value: _progress,
            // ),
            // const SizedBox(height: 16.0),
            if (widget.videolink.isNotEmpty && _videoPlayerController != null)
              GestureDetector(
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
            if (widget.videolink.isNotEmpty)
              Card(
                child: Row(
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
              ),
          ],
        )),
      ),
    );
  }
}
