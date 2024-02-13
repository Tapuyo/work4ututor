import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:html';
import 'dart:io';
import 'dart:js' as js;
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/agora_rtc_engine_web.dart' as RtcScreenView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:work4ututor/ui/web/communication.dart/whiteboard.dart';

import '../../../data_class/chatmessageclass.dart';
import '../../../services/getmessages.dart';
import '../../../utils/themes.dart';
import 'package:http/http.dart' as http;

const appId = "43ccea6aa40e4f7cb6e96de7ddf0f0b3";
const appCertificate = "72f8f49b581f41b4a4fefa998beb484a";
const token = "";
const channel = "test";

// void main() => runApp(const MaterialApp(
//         home: VideoCall(
//       chatID: '',
//       uID: '',
//     )));

class VideoCall extends StatefulWidget {
  final String uID;
  final String chatID;
  const VideoCall({Key? key, required this.uID, required this.chatID})
      : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamProvider<List<MessageContent>>.value(
      value: GetMessageConversation(chatID: widget.chatID, userID: widget.uID)
          .getmessage,
      catchError: (context, error) {
        print('Error occurred: $error');
        return [];
      },
      initialData: const [],
      child: const VideoCallBody(
          // userID: widget.uID,
          // chatID: widget.chatID,
          ),
    );
  }
}

class VideoCallBody extends StatefulWidget {
  const VideoCallBody({Key? key}) : super(key: key);

  @override
  State<VideoCallBody> createState() => _VideoCallBodyState();
}

class _VideoCallBodyState extends State<VideoCallBody> {
  int? _remoteUid;
  int _localUid = 0;
  bool _localUserJoined = false;
  bool _remoteUserJoined = false;
  bool _isRecording = false;
  late RtcEngine _engine;
  bool _isScreenSharing = false;
  int _speakerUid = 0;
  bool isRecording = false;
  bool isPreview = true;
  bool cameraInUse = false;
  bool isFullScreen = false;
  bool isMute = false;
  bool viewChat = true;
  bool isVirtualBackGroundEnabled = false;
  bool _isEnabledVirtualBackgroundImage = false;
  // ignore: prefer_final_fields
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController messageContent = TextEditingController();
  List<Offset> _points = [];
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    js.context.callMethod('removeEventListener', ['keydown', handleKeyDown]);
    super.dispose();
  }

  void toggleFullscreen() {
    if (isFullScreen) {
      exitFullscreen();
    } else {
      goFullscreen();
    }
  }

  void goFullscreen() {
    if (html.document.documentElement!.requestFullscreen != null) {
      html.document.documentElement!.requestFullscreen();
      setState(() {
        isFullScreen = true;
      });
    }
  }

  void exitFullscreen() {
    if (html.document.exitFullscreen != null) {
      html.document.exitFullscreen();
      setState(() {
        isFullScreen = false;
      });
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  Future<String?> uploadFile() async {
    // Open a file picker dialog to select a file.
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? file = result.files.first.bytes;
      String filename = result.files.first.name;

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child("files/$filename")
          .putData(file!);

      // Wait for the upload to complete.
      TaskSnapshot snapshot = await task.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        return "files/$filename";
      } else {
        print("Error uploading file");
        return null; // or throw an exception
      }
    } else {
      print("Canceled");
      return null;
    }
  }

  void uploadfiledata() async {
    // // Get the download URL of the uploaded file from Firebase Storage.
    dynamic url = await uploadFile();
    String downloadUrl =
        await FirebaseStorage.instance.ref(url.toString()).getDownloadURL();
    setState(() {
      debugPrint(url.toString());
    });

    if (downloadUrl.isEmpty) {
      setState(() {
        print(downloadUrl);
      });
    } else {
      FirebaseFirestore.instance.collection('files').add({
        'name': DateTime.now(),
        'downloadUrl': downloadUrl,
        'type': "image",
        // Other information related to the file.
      });
      setState(() {
        print(downloadUrl);
      });
    }
    // FirebaseFirestore.instance
    //     .collection('files')
    //     .add({'name': '1', 'downloadUrl': 1});
  }

  @override
  void initState() {
    super.initState();
    initAgora();
    // _startTimer();
    // Add an event listener to detect fullscreen change
    js.context.callMethod('addEventListener', ['keydown', handleKeyDown]);

    // Add an event listener to detect visibility change
    html.document.onVisibilityChange.listen(handleVisibilityChange);
  }

  void handleVisibilityChange(dynamic event) {
    if (html.document.visibilityState == 'visible') {
      setState(() {
        isFullScreen = html.document.fullscreenElement != null;
      });
    }
  }

  void handleKeyDown(dynamic event) {
    if (event is js.JsObject && event['keyCode'] == 27) {
      setState(() {
        isFullScreen = false;
      });
    }
  }

  void _onEndCallButtonPressed() async {
    _engine = await RtcEngine.create(appId);
    _engine.leaveChannel();
  }

  void _toggleScreenSharing() async {
    if (_isScreenSharing) {
      // Stop local video
      setState(() {
        _engine.stopPreview();
        _engine.disableVideo();
        _isScreenSharing = !_isScreenSharing;
      });
      await _engine.startScreenCaptureByDisplayId(0);
    } else {
      await _engine.stopScreenCapture();
      setState(() {
        _engine.enableVideo();
        _engine.startPreview();
        _isScreenSharing = !_isScreenSharing;
      });
    }
  }

  void muteAudio() {
    _engine.muteLocalAudioStream(true); // Mute local audio
  }

  void unmuteAudio() {
    _engine.muteLocalAudioStream(false); // Unmute local audio
  }

  switchMicrophone() async {
    // await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.muteLocalAudioStream(!isMute);
    setState(() {
      isMute = !isMute;
    });
  }

  Future<String> generateRecordingKey() async {
    const url = 'https://api.agora.io/v1/apps/<APP_ID>/cloud_recording/acquire';
    const appId = 'YOUR_APP_ID'; // Replace with your Agora app ID
    const appCertificate =
        'YOUR_APP_CERTIFICATE'; // Replace with your Agora app certificate
    const channelName =
        'YOUR_CHANNEL_NAME'; // Replace with the desired channel name
    const uid = 0; // Set the UID value for recording
    const expirationTimeInSeconds =
        3600; // Set the expiration time for the key in seconds

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'cname': channelName,
        'uid': uid.toString(),
        'clientRequest': {
          'resourceExpiredHour': expirationTimeInSeconds,
        },
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final recordingKey = responseBody['resourceId'];
      return recordingKey;
    } else {
      throw Exception(
          'Failed to generate recording key. Error code: ${response.statusCode}');
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      startRecording();
    } else {
      stopRecording();
    }
  }

  Future<void> startRecording() async {
    final recordingKey = await generateRecordingKey();
  }

  void stopRecording() {
    // Stop recording implementation...
  }

  void startMediaStream() async {
    try {
      final stream = await window.navigator.mediaDevices!.getUserMedia({
        'video': true, // Set to true if you want video as well
        'audio': true, // Set to true to enable audio
      });

      // Do something with the media stream, e.g., display video and/or audio
      // For example, displaying video in a video element:
      // final videoElement = VideoElement()..srcObject = stream;
      // videoElement.style.width = '100%';
      // videoElement.style.height = 'auto';
      // videoElement.autoplay = true;
      // videoElement.controls = true;

      // document.body!.append(videoElement);
    } catch (e) {
      print("Error accessing media stream: $e");
    }
  }

  Future<void> initAgora() async {
    // retrieve permissions
    // startMediaStream();
    bool response = false;
    try {
      await window.navigator.mediaDevices?.getUserMedia({
        'video': true,
        'audio': true,
      });
      response = true;
      // Media devices started successfully
    } catch (error) {
      if (error == 'NotAllowedError' || error == 'NotReadableError') {
        // The camera is in use by another application
        response = false;
        cameraInUse = true;
        print(
            'Could not start video source. Another application may be using the camera.');
        // You can display a user-friendly message or take appropriate action
      } else {
        // Handle other errors
        response = false;
        cameraInUse = true;
        print(error);
      }
    }

    // await window.navigator.mediaDevices!.getUserMedia({
    //   'video': true,
    //   'audio': true,
    // });
    //create the engine
    _engine = await RtcEngine.create(appId);
    if (response == false) {
      await _engine.disableVideo();
    } else {
      await _engine.enableVideo();
      await _engine.startPreview();
    }

    await _engine.setChannelProfile(ChannelProfile.Communication);
    // await _engine.setClientRole(ClientRole.Broadcaster);
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
            _remoteUserJoined = true;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
            _remoteUserJoined = false;
          });
        },
        virtualBackgroundSourceEnabled:
            (bool enabled, VirtualBackgroundSourceStateReason reason) {
          print("Virtual user $enabled left channel");
        },
        activeSpeaker: (int uid) {
          print("speaker user $uid left channel");
          setState(() {
            _speakerUid = uid;
          });
        },
      ),
    );

    await _engine.joinChannel(token, channel, null, _localUid);
  }

  void _onWhiteboardPaint(DrawUpdate update) {
    setState(() {
      _points = List.of(_points)..add(update.offset);
    });
  }

  void cameraView() async {
    if (isPreview) {
      await window.navigator.mediaDevices!.getUserMedia({
        'video': false,
        'audio': true,
      });
      setState(() {
        isPreview = !isPreview;
      });

      await _engine.stopPreview();
      await _engine.disableVideo();
    }
    // if (cameraInUse == false) {
    //   await window.navigator.mediaDevices!.getUserMedia({
    //     'video': true,
    //     'audio': true,
    //   });
    //   setState(() {
    //     isPreview = !isPreview;
    //   });

    //   await _engine.stopPreview();
    //   await _engine.disableVideo();
    // }
    else {
      await window.navigator.mediaDevices!.getUserMedia({
        'video': true,
        'audio': true,
      });
      setState(() {
        isPreview = !isPreview;
      });
      await _engine.enableVideo();
      await _engine.startPreview();
    }
  }

  void _onClearButtonPressed() {
    setState(() {
      _points = [];
    });
  }

  void startScreenSharing() async {
    // Stop local video
    await _engine.enableLocalVideo(false);

    // Start screen sharing
    await _engine.startScreenCapture(0);
    setState(() {
      _isScreenSharing = true;
    });
  }

  void stopScreenSharing() async {
    // Stop screen sharing
    await _engine.stopScreenCapture();
    setState(() {
      _isScreenSharing = false;
    });

    // Start local video
    await _engine.enableLocalVideo(true);
  }

  void setVirtualBackground() async {
    // setState(() {
    //   isVirtualBackGroundEnabled = !isVirtualBackGroundEnabled;
    // });
    // counter++;
    // if (counter > 3) {
    //     counter = 0;
    //     isVirtualBackGroundEnabled = false;
    //     showMessage("Virtual background turned off");
    // } else {
    //     isVirtualBackGroundEnabled = true;
    // }

    VirtualBackgroundSource virtualBackgroundSource;

    // Set the type of virtual background
    // if (counter == 1) {
    virtualBackgroundSource = VirtualBackgroundSource(
        backgroundSourceType: VirtualBackgroundSourceType.Blur,
        blurDegree: VirtualBackgroundBlurDegree.High);
    //     showMessage("Setting blur background");
    // } else if (counter == 2) {
    //     // Set a solid background color
    // virtualBackgroundSource = VirtualBackgroundSource(
    //     backgroundSourceType: VirtualBackgroundSourceType.Color,
    //     color: 0x0000FF);
    // } else {
    //     // Set a background image
    //     virtualBackgroundSource = const VirtualBackgroundSource(
    //         backgroundSourceType: BackgroundSourceType.backgroundImg,
    //         source: "<path to an image file>");
    //     showMessage("Setting image background");
    // }

    // // Set processing properties for background
    // SegmentationProperty segmentationProperty = const SegmentationProperty(
    //         modelType: SegModelType.segModelAi, // Use segModelGreen if you have a green background
    //         greenCapacity: 0.5 // Accuracy for identifying green colors (range 0-1)
    //     );

    // Enable or disable virtual background
    await _engine.enableVirtualBackground(
        true,
        virtualBackgroundSource = VirtualBackgroundSource(
            backgroundSourceType: VirtualBackgroundSourceType.Img,
            source: "C:\Users\melvi\Downloads"));
  }

  Future<void> _enableVirtualBackground() async {
    // ByteData data = await rootBundle.load("assets/images/5836.png");
    // List<int> bytes =
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String p = path.join(appDocDir.path, '5836.png');
    // final file = File(p);
    // if (!(await file.exists())) {
    //   await file.create();
    //   await file.writeAsBytes(bytes);
    // }

    await _engine.enableVirtualBackground(
        !_isEnabledVirtualBackgroundImage,
        VirtualBackgroundSource(
            backgroundSourceType: VirtualBackgroundSourceType.Blur,
            blurDegree: VirtualBackgroundBlurDegree.High));
    setState(() {
      _isEnabledVirtualBackgroundImage = !_isEnabledVirtualBackgroundImage;
    });
  }

  // _startScreenShare() async {
  //   final helper = await _engine.getScreenShareHelper(
  //       appGroup: kIsWeb || Platform.isWindows ? null : _kDefaultAppGroup);
  //   helper.setEventHandler(RtcEngineEventHandler(
  //     joinChannelSuccess: (String channel, int uid, int elapsed) {
  //       print('ScreenSharing joinChannelSuccess $channel $uid $elapsed');
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content:
  //             Text('ScreenSharing joinChannelSuccess $channel $uid $elapsed'),
  //       ));
  //     },
  //     localVideoStateChanged:
  //         (LocalVideoStreamState localVideoState, LocalVideoStreamError error) {
  //       print(
  //           'ScreenSharing localVideoStateChanged $localVideoState $error');
  //       if (error == LocalVideoStreamError.ScreenCaptureWindowClosed) {
  //         _stopScreenShare();
  //       }
  //     },
  //   ));

  //   await helper.disableAudio();
  //   await helper.enableVideo();
  //   await helper.setChannelProfile(ChannelProfile.LiveBroadcasting);
  //   await helper.setClientRole(ClientRole.Broadcaster);
  //   var windowId = 0;
  //   var random = Random();
  //   if (!kIsWeb &&
  //       (Platform.isWindows || Platform.isMacOS || Platform.isAndroid)) {
  //     final windows = _engine.enumerateWindows();
  //     if (windows.isNotEmpty) {
  //       final index = random.nextInt(windows.length - 1);
  //       print('ScreenSharing window with index $index');
  //       windowId = windows[index].id;
  //     }
  //   }
  //   await helper.startScreenCaptureByWindowId(windowId);
  //   setState(() {
  //     screenSharing = true;
  //   });
  //   await helper.joinChannel(
  //       config.token, channelId, null, config.screenSharingUid);
  // }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    final messagedata = Provider.of<List<MessageContent>>(context);
    if (messagedata.isNotEmpty) {
      setState(() {
        messagedata.sort((a, b) => a.dateSent.compareTo(b.dateSent));
      });
    }
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.physicalKey == PhysicalKeyboardKey.escape) {
          setState(() {
            isFullScreen = false;
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kColorSecondary, kColorPrimary, kColorLight],
            ),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isFullScreen ? false : true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              width: 50,
                              child: Image.asset(
                                "assets/images/videologo.png",
                                alignment: Alignment.topCenter,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Text(
                              'Work4uTutor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 15,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 4,
                                  child: Container(
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(20),
                                      //   color:
                                      //       const Color.fromARGB(95, 155, 176, 194),
                                      // ),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Chemistry Class (First Session)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20,
                                                      color: kColorPrimary),
                                                ),
                                                Text(
                                                  '50 minutes per class session',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                      color: kColorPrimaryDark),
                                                ),
                                              ]),
                                          const Spacer(),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       left: 10.0),
                                          //   child: Text(
                                          //     _formatTime(_seconds),
                                          //     style: const TextStyle(
                                          //         fontSize: 30.0,
                                          //         fontWeight: FontWeight.bold,
                                          //         color: kColorPrimaryDark),
                                          //   ),
                                          // ),
                                        ],
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                    // decoration: const BoxDecoration(
                                    //   gradient: LinearGradient(
                                    //     begin: Alignment.topLeft,
                                    //     end: Alignment.bottomRight,
                                    //     colors: [kColorPrimary, kColorLight],
                                    //   ),
                                    // ),
                                    height: isFullScreen
                                        ? MediaQuery.of(context).size.height -
                                            130
                                        : MediaQuery.of(context).size.height -
                                            190,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /2,
                                        child: Center(
                                          child: _remoteVideo(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FloatingActionButton(
                                              backgroundColor: kColorPrimary,
                                              onPressed: () {
                                                _toggleScreenSharing();
                                              },
                                              child: Icon(_isScreenSharing
                                                  ? Icons.stop_screen_share
                                                  : Icons.screen_share),
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: kColorPrimary,
                                              onPressed: () {
                                                switchMicrophone();
                                              },
                                              child: isMute
                                                  ? Icon(
                                                      Icons.mic,
                                                      color:
                                                          Colors.red.shade200,
                                                    )
                                                  : const Icon(Icons.mic),
                                            ),
                                            // FloatingActionButton(
                                            //   backgroundColor: kColorPrimary,
                                            //   onPressed: () =>
                                            //       {_enableVirtualBackground()},
                                            //   child: const Icon(Icons.image),
                                            // ),
                                            FloatingActionButton(
                                              backgroundColor: kColorPrimary,
                                              onPressed: () {
                                                cameraView();
                                              },
                                              child: isPreview
                                                  ? const Icon(Icons.camera)
                                                  : Icon(
                                                      Icons.camera,
                                                      color:
                                                          Colors.red.shade200,
                                                    ),
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: kColorPrimary,
                                              onPressed:
                                                  _onEndCallButtonPressed,
                                              child: const Icon(
                                                Icons.call_end,
                                                color: Colors.red,
                                                size: 40,
                                              ),
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: kColorPrimary,
                                              onPressed: () {
                                                showWhiteboard(context);
                                              },
                                              child: const Icon(Icons.edit),
                                            ),
                                            // FloatingActionButton(
                                            //   onPressed: () {
                                            //     setState(() {
                                            //       if (isRecording) {
                                            //         stopRecording();
                                            //       } else {
                                            //         startRecording();
                                            //       }
                                            //       isRecording = !isRecording;
                                            //     });
                                            //   },
                                            //   backgroundColor: isRecording
                                            //       ? Colors.red
                                            //       : kColorPrimary,
                                            //   child: Icon(
                                            //     isRecording
                                            //         ? Icons.stop
                                            //         : Icons.fiber_manual_record,
                                            //     color: Colors.white,
                                            //   ),
                                            // ),
                                            FloatingActionButton(
                                              onPressed: () {
                                                setState(() {
                                                  viewChat = !viewChat;
                                                });
                                              },
                                              backgroundColor: viewChat
                                                  ? kColorPrimary
                                                  : kColorSecondary,
                                              child: const Icon(
                                                Icons.message_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: kColorPrimary,
                                              onPressed: goFullscreen,
                                              child:
                                                  const Icon(Icons.fullscreen),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Card(
                                    elevation: 4,
                                    child: SizedBox(
                                      width: 160,
                                      height: 160,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: _localuserVideo(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Visibility(
                visible: false,
                child: Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Chat with user:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const InteractiveWhiteboard(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('files')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      if (snapshot.data!.docs.isEmpty) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      final message = snapshot.data!.docs;

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Card(
                                          elevation: 4,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            itemCount: message.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 70),
                                            itemBuilder: (context, index) {
                                              final messagedata =
                                                  message[index];
                                              if (messagedata['type'] ==
                                                  'text') {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 2,
                                                          right: 10),
                                                  child: Row(
                                                    children: [
                                                      const Center(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black12,
                                                            child: Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        constraints:
                                                            const BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: 260),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: kColorLight,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          messagedata[
                                                              'downloadUrl'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else if (messagedata['type'] ==
                                                  'image') {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 2,
                                                          right: 10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        const Center(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black12,
                                                              child: Icon(
                                                                Icons.person,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          width: 250,
                                                          height: 250,
                                                          child: Image.network(
                                                              messagedata[
                                                                  'downloadUrl']),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else if (messagedata['type'] ==
                                                  'link') {
                                                return InkWell(
                                                  onTap: () => html.window.open(
                                                      messagedata[
                                                          'downloadUrl'],
                                                      '_blank'),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            bottom: 2,
                                                            right: 10),
                                                    child: Row(
                                                      children: [
                                                        const Center(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black12,
                                                              child: Icon(
                                                                Icons.person,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth:
                                                                      260),
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                            color: kColorLight,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: Text(
                                                            messagedata[
                                                                'downloadUrl'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10, top: 10),
                                          height: 60,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              FloatingActionButton(
                                                onPressed: () {
                                                  uploadfiledata();
                                                },
                                                backgroundColor: kColorPrimary,
                                                elevation: 0,
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: TextField(
                                                  controller: messageContent,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Write message...",
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                          border:
                                                              InputBorder.none),
                                                  onSubmitted: (value) {
                                                    FirebaseFirestore.instance
                                                        .collection('files')
                                                        .add({
                                                      'name': DateTime.now(),
                                                      'downloadUrl':
                                                          messageContent.text,
                                                      'type': "text",
                                                      // Other information related to the file.
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              FloatingActionButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('files')
                                                      .add({
                                                    'name': DateTime.now(),
                                                    'downloadUrl':
                                                        messageContent.text,
                                                    'type': "text",
                                                    // Other information related to the file.
                                                  });
                                                },
                                                backgroundColor: kColorPrimary,
                                                elevation: 0,
                                                child: const Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Function to launch URLs using url_launcher package
  _launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null && _speakerUid != _remoteUid) {
      return RtcRemoteView.SurfaceView(
        zOrderMediaOverlay: true,
        zOrderOnTop: true,
        uid: _remoteUid!,
        channelId: channel,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/new_hd.png',
            width: 400.0,
            height: 200.0,
            fit: BoxFit.contain,
          ),
          const Text('Waiting for parties to join..'),
        ],
      );
    }
  }

  Widget _localuserVideo() {
    if (_localUserJoined && isPreview) {
      return const RtcLocalView.SurfaceView(
        channelId: channel,
        zOrderMediaOverlay: true,
        zOrderOnTop: true,
      );
    } else if (_localUserJoined && _isScreenSharing || isPreview == false) {
      return const Icon(
        Icons.person_2_rounded,
        size: 60,
        color: kColorPrimary,
      );
    } else if (_localUserJoined && cameraInUse) {
      return const Text('Camera in Use by other media');
    } else {
      return const CircularProgressIndicator();
    }
  }

  // This method builds the container for displaying the speaker video.
  Widget _buildSpeakerVideo() {
    if (_speakerUid == _localUid) {
      return const RtcLocalView.SurfaceView();
    } else if (_speakerUid == _remoteUid) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: channel,
      );
    } else if (_isScreenSharing) {
      return const RtcLocalView.SurfaceView();
    } else {
      return Container();
    }
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<Offset> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawUpdate {
  final Offset offset;
  final Paint paint;
  final String? text;

  DrawUpdate({required this.offset, required this.paint, this.text});
}

void showWhiteboard(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;

                return Container(
                  height: height,
                  width: width - 400,
                  child: const InteractiveWhiteboard(),
                );
              },
            ),
          ));
}
