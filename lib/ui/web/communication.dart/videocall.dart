// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:io';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../services/getchatcall.dart';
import '../../../services/getclassinfo.dart';
import '../../../services/getsubject.dart';
import '../../../utils/themes.dart';
import 'package:http/http.dart' as http;

const String _kDefaultAppGroup = 'io.agora';

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
  final String classId;
  const VideoCall(
      {Key? key,
      required this.uID,
      required this.chatID,
      required this.classId})
      : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  String channelId = channel;
  bool isJoined = false, screenSharing = false;
  List<int> remoteUid = [];
  List<int> videostopUid = [];
  bool _isRecording = false;
  late RtcEngine _engine;
  bool _isScreenSharing = false;
  final int _speakerUid = 0;
  bool isRecording = false;
  bool isPreview = true;
  bool cameraInUse = false;
  bool isFullScreen = false;
  bool isMute = false;
  bool viewChat = true;
  bool isVirtualBackGroundEnabled = false;
  bool _isEnabledVirtualBackgroundImage = false;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageContent = TextEditingController();
  List<Offset> _points = [];
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    js.context.callMethod('removeEventListener', ['keydown', handleKeyDown]);
    _engine.destroy();

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
    html.document.documentElement!.requestFullscreen();
    setState(() {
      isFullScreen = true;
    });
    }

  void exitFullscreen() {
    html.document.exitFullscreen();
    setState(() {
      isFullScreen = false;
    });
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

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    // _joinChannel();
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    _joinChannel();
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        debugPrint('warning $warningCode');
      },
      error: (errorCode) {
        debugPrint('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined  $uid $elapsed');
        if (uid == 10) {
          return;
        }
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline  $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        debugPrint('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
      remoteVideoStateChanged: (uid, state, reason, elapsed) {
        if (state == VideoRemoteState.Stopped) {
          setState(() {
            videostopUid.add(uid);
          });
        } else if (state == VideoRemoteState.Starting) {
          setState(() {
            videostopUid.removeWhere((element) => element == uid);
          });
        }
      },
    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannel(token, 'test', null, 02);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  _startScreenShare() async {
    final helper = await _engine.getScreenShareHelper(
        appGroup: kIsWeb || Platform.isWindows ? null : _kDefaultAppGroup);
    helper.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        debugPrint('ScreenSharing joinChannelSuccess $channel $uid $elapsed');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('ScreenSharing joinChannelSuccess $channel $uid $elapsed'),
        ));
      },
      localVideoStateChanged:
          (LocalVideoStreamState localVideoState, LocalVideoStreamError error) {
        debugPrint(
            'ScreenSharing localVideoStateChanged $localVideoState $error');
        if (error == LocalVideoStreamError.ScreenCaptureWindowClosed) {
          _stopScreenShare();
        }
      },
    ));

    await helper.disableAudio();
    await helper.enableVideo();
    await helper.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await helper.setClientRole(ClientRole.Broadcaster);
    var windowId = 0;
    var random = Random();
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isAndroid)) {
      final windows = _engine.enumerateWindows();
      if (windows.isNotEmpty) {
        final index = random.nextInt(windows.length - 1);
        debugPrint('ScreenSharing window with index $index');
        windowId = windows[index].id;
      }
    }
    await helper.startScreenCaptureByWindowId(windowId);
    setState(() {
      screenSharing = true;
    });
    await helper.joinChannel(token, channelId, null, 10);
  }

  _stopScreenShare() async {
    final helper = await _engine.getScreenShareHelper();
    await helper.destroy().then((value) {
      setState(() {
        screenSharing = false;
      });
    }).catchError((err) {
      debugPrint('_stopScreenShare $err');
    });
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

  void uploadfiledata(String uid) async {
    // // Get the download URL of the uploaded file from Firebase Storage.
    dynamic url = await uploadFile();
    String downloadUrl =
        await FirebaseStorage.instance.ref(url.toString()).getDownloadURL();
    setState(() {
      debugPrint(url.toString());
    });

    if (downloadUrl.isEmpty) {
    } else {
      FirebaseFirestore.instance.collection('files').add({
        'name': DateTime.now(),
        'chatId': uid,
        'downloadUrl': downloadUrl,
        'type': "image",
      });
    }
    // FirebaseFirestore.instance
    //     .collection('files')
    //     .add({'name': '1', 'downloadUrl': 1});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final classInfoNotifier =
          Provider.of<ClassInfoNotifier>(context, listen: false);
      classInfoNotifier.getClassInfo(widget.classId);
    });
    // initAgora();
    _initEngine();
    // _startTimer();
    // Add an event listener to detect fullscreen change
    js.context.callMethod('addEventListener', ['keydown', handleKeyDown]);

    // Add an event listener to detect visibility change
    // html.document.onVisibilityChange.listen(handleVisibilityChange);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final notifier = Provider.of<CallChatNotifier>(context, listen: false);
    //   notifier.getChats('0CDVn2OwJv3eQW6ajZFU');
    // });
  }

  // void handleVisibilityChange(dynamic event) {
  //   if (html.document.visibilityState == 'visible') {
  //     setState(() {
  //       isFullScreen = html.document.fullscreenElement != null;
  //     });
  //   }
  // }

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
    // ignore: use_build_context_synchronously
    GoRouter.of(context).go('/');
  }

  void _toggleScreenSharing() async {
    // if (_isScreenSharing) {
    // Stop local video
    // setState(() {
    //   _isScreenSharing = !_isScreenSharing;
    // });
    // await _engine.stopPreview();
    // await _engine.disableVideo();
    await _engine.startScreenCaptureByDisplayId(10);
    // } else {
    //   await _engine.stopScreenCapture();
    //   setState(() {
    //     _engine.enableVideo();
    //     _engine.startPreview();
    //     _isScreenSharing = !_isScreenSharing;
    //   });
    // }
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
      final stream = await html.window.navigator.mediaDevices!.getUserMedia({
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

  // Future<void> initAgora() async {
  //   // retrieve permissions
  //   // startMediaStream();
  //   bool response = false;
  //   try {
  //     await window.navigator.mediaDevices?.getUserMedia({
  //       'video': true,
  //       'audio': true,
  //     });
  //     response = true;
  //     // Media devices started successfully
  //   } catch (error) {
  //     if (error == 'NotAllowedError' || error == 'NotReadableError') {
  //       // The camera is in use by another application
  //       response = false;
  //       cameraInUse = true;
  //       print(
  //           'Could not start video source. Another application may be using the camera.');
  //       // You can display a user-friendly message or take appropriate action
  //     } else {
  //       // Handle other errors
  //       response = false;
  //       cameraInUse = true;
  //       print(error);
  //     }
  //   }

  //   // await window.navigator.mediaDevices!.getUserMedia({
  //   //   'video': true,
  //   //   'audio': true,
  //   // });
  //   //create the engine
  //   _engine = await RtcEngine.create(appId);
  //   if (response == false) {
  //     await _engine.disableVideo();
  //   } else {
  //     await _engine.enableVideo();
  //     await _engine.startPreview();
  //   }

  //   await _engine.setChannelProfile(ChannelProfile.Communication);
  //   // await _engine.setClientRole(ClientRole.Broadcaster);
  //   _engine.setEventHandler(
  //     RtcEngineEventHandler(
  //       joinChannelSuccess: (String channel, int uid, int elapsed) {
  //         print("local user $uid joined");
  //         setState(() {
  //           _localUserJoined = true;
  //         });
  //       },
  //       userJoined: (int uid, int elapsed) {
  //         print("remote user $uid joined");
  //         setState(() {
  //           _remoteUid = uid;
  //           _remoteUserJoined = true;
  //         });
  //       },
  //       userOffline: (int uid, UserOfflineReason reason) {
  //         print("remote user $uid left channel");
  //         setState(() {
  //           _remoteUid = null;
  //           _remoteUserJoined = false;
  //         });
  //       },
  //       virtualBackgroundSourceEnabled:
  //           (bool enabled, VirtualBackgroundSourceStateReason reason) {
  //         print("Virtual user $enabled left channel");
  //       },
  //       activeSpeaker: (int uid) {
  //         print("speaker user $uid left channel");
  //         setState(() {
  //           _speakerUid = uid;
  //         });
  //       },
  //     ),
  //   );

  //   await _engine.joinChannel(token, channel, null, _localUid);
  // }

  void _onWhiteboardPaint(DrawUpdate update) {
    setState(() {
      _points = List.of(_points)..add(update.offset);
    });
  }

  void cameraView() async {
    if (isPreview) {
      await html.window.navigator.mediaDevices!.getUserMedia({
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
      await html.window.navigator.mediaDevices!.getUserMedia({
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
            source: "C:UsersmelviDownloads"));
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
    // final messagedata = Provider.of<List<MessageContent>>(context);
    // if (messagedata.isNotEmpty) {
    //   setState(() {
    //     messagedata.sort((a, b) => a.dateSent.compareTo(b.dateSent));
    //   });
    // }
    Provider.of<CallChatNotifier>(context, listen: false)
        .getChats(widget.classId);
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kColorLight, kColorSecondary],
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
                            // Container(
                            //   padding:
                            //       const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //   width: 50,
                            //   child: Image.asset(
                            //     "assets/images/videologo.png",
                            //     alignment: Alignment.topCenter,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            // const Text(
                            //   'Work4uTutor',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 30,
                            //       color: Colors.white),
                            // ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            Expanded(
                              flex: 15,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 0),
                                child: Card(
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                  child: Container(
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(20),
                                      //   color:
                                      //       const Color.fromARGB(95, 155, 176, 194),
                                      // ),
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(10),
                                      child: Consumer<ClassInfoNotifier>(
                                          builder: (context, classinfo, _) {
                                        if (classinfo.classinfo.isEmpty) {
                                          return Container();
                                        }
                                        Provider.of<SubjectInfoNotifier>(
                                                context,
                                                listen: false)
                                            .getClassInfo(classinfo
                                                .classinfo['subjectID']);
                                        return Consumer<SubjectInfoNotifier>(
                                            builder: (context, subjectinfo, _) {
                                          if (subjectinfo
                                                  .subjectinfo.subjectName ==
                                              '') {
                                            return Container();
                                          }
                                          return Row(
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${subjectinfo.subjectinfo.subjectName} Class',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                    const Text(
                                                      '50 minutes per class session',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                          color: Colors.white),
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
                                          );
                                        });
                                      })),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // _renderVideo(),
                      Stack(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height: isFullScreen
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                55
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                120,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: screenSharing
                                                  ? kIsWeb
                                                      ? const rtc_local_view
                                                          .SurfaceView.screenShare()
                                                      : const rtc_local_view
                                                          .TextureView.screenShare()
                                                  : _remoteVideo(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: isFullScreen
                                        ? MediaQuery.of(context).size.height -
                                            55
                                        : MediaQuery.of(context).size.height -
                                            120,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: SizedBox(
                                          height: 55,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Tooltip(
                                                  message: 'Screen share',
                                                  preferBelow: false,
                                                  child: FloatingActionButton(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    onPressed: screenSharing
                                                        ? _stopScreenShare
                                                        : _startScreenShare,
                                                    child: Icon(screenSharing
                                                        ? Icons
                                                            .stop_screen_share
                                                        : Icons.screen_share),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Switch Mic',
                                                  preferBelow: false,
                                                  child: FloatingActionButton(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    onPressed: () {
                                                      switchMicrophone();
                                                    },
                                                    child: isMute
                                                        ? Icon(
                                                            Icons.mic,
                                                            color: Colors
                                                                .red.shade200,
                                                          )
                                                        : const Icon(Icons.mic),
                                                  ),
                                                ),
                                                // FloatingActionButton(
                                                //   backgroundColor: kColorPrimary,
                                                //   onPressed: () =>
                                                //       {_enableVirtualBackground()},
                                                //   child: const Icon(Icons.image),
                                                // ),
                                                Tooltip(
                                                  message: 'Camera',
                                                  preferBelow: false,
                                                  child: FloatingActionButton(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    onPressed: () {
                                                      cameraView();
                                                    },
                                                    child: isPreview
                                                        ? const Icon(
                                                            Icons.camera)
                                                        : Icon(
                                                            Icons.camera,
                                                            color: Colors
                                                                .red.shade200,
                                                          ),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'End Call',
                                                  preferBelow: false,
                                                  child: FloatingActionButton(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    onPressed:
                                                        _onEndCallButtonPressed,
                                                    child: const Icon(
                                                      Icons.call_end,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                // FloatingActionButton(
                                                //   backgroundColor:
                                                //       Colors.grey.shade300,
                                                //   onPressed: () {
                                                //     showWhiteboard(context);
                                                //   },
                                                //   child: const Icon(Icons.edit),
                                                // ),
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
                                                Tooltip(
                                                  message: 'Chat',
                                                  preferBelow: false,
                                                  child: FloatingActionButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        viewChat = !viewChat;
                                                      });
                                                    },
                                                    backgroundColor: viewChat
                                                        ? Colors.grey.shade300
                                                        : kColorPrimary,
                                                    child: const Icon(
                                                      Icons.message_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Tooltip(
                                                  preferBelow: false,
                                                  message: 'Full Screen',
                                                  child: FloatingActionButton(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    onPressed: goFullscreen,
                                                    child: const Icon(
                                                        Icons.fullscreen),
                                                  ),
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
                            ],
                          ),
                          Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: Align(
                              //     alignment: Alignment.topRight,
                              //     child: Card(
                              //       elevation: 4,
                              //       child: SizedBox(
                              //         width: 160,
                              //         height: 160,
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(5.0),
                              //           child: Center(
                              //             child: _localuserVideo(),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Card(
                                        elevation: 4,
                                        child: SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                              child: _localuserVideo(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (screenSharing || remoteUid.contains(10))
                                      Column(
                                        children: List.of(remoteUid.map(
                                          (e) {
                                            if (e == 10) {
                                              return const SizedBox.shrink();
                                            } else {
                                              return Align(
                                                alignment: Alignment.topRight,
                                                child: Card(
                                                  elevation: 4,
                                                  child: SizedBox(
                                                    width: 160,
                                                    height: 160,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: kIsWeb
                                                          ? AspectRatio(
                                                              aspectRatio:
                                                                  16 / 9,
                                                              child: rtc_remote_view
                                                                  .SurfaceView(
                                                                uid: e,
                                                                channelId:
                                                                    channelId,
                                                              ),
                                                            )
                                                          : rtc_remote_view
                                                              .TextureView(
                                                              uid: e,
                                                              channelId:
                                                                  channelId,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        )),
                                      )
                                  ],
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
                visible: viewChat,
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
                                    'Meeting chat',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: kColorPrimary),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chat_outlined,
                                      color: kColorLight,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  Consumer<CallChatNotifier>(
                                    builder:
                                        (context, cardDetailsNotifier, child) {
                                      if (cardDetailsNotifier.chats.isEmpty) {
                                        return const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.message_outlined,
                                                    color: kColorPrimary,
                                                  ),
                                                  Text(
                                                    'No message found.',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        dynamic message =
                                            cardDetailsNotifier.chats;

                                        message.sort((a, b) {
                                          Timestamp aTimestamp = a['name'];
                                          Timestamp bTimestamp = b['name'];
                                          return aTimestamp.compareTo(
                                              bTimestamp); // Compare b to a for descending order
                                        });
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
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
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black12,
                                                            child: Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.grey,
                                                              size: 15,
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
                                                            BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      20)),
                                                          border: Border.all(
                                                              width: 2,
                                                              color:
                                                                  kColorPrimary),
                                                          // color: (messagedata[index]
                                                          //             .userID ==
                                                          //         widget.userID
                                                          //     ? Colors.white
                                                          //     : Colors.grey.shade200),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: SelectableText(
                                                          messagedata[
                                                              'downloadUrl'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  kColorGrey),
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
                                                                size: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            await openInNewTab(
                                                                messagedata[
                                                                    'downloadUrl']);
                                                          },
                                                          child: SizedBox(
                                                            width: 250,
                                                            height: 250,
                                                            child: Image.network(
                                                                messagedata[
                                                                    'downloadUrl']),
                                                          ),
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
                                                                size: 15,
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
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topRight:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20)),
                                                            border: Border.all(
                                                                width: 2,
                                                                color:
                                                                    kColorPrimary),
                                                            // color: (messagedata[index]
                                                            //             .userID ==
                                                            //         widget.userID
                                                            //     ? Colors.white
                                                            //     : Colors.grey.shade200),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: SelectableText(
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
                                        );
                                      }
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
                                                  uploadfiledata(
                                                      widget.classId);
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
                                                        .collection(
                                                            'files') // Set the document ID to classID
                                                        .add({
                                                      'chatId': widget.classId,

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
                                                    'chatId': widget.classId,
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
    if (remoteUid.isNotEmpty && _speakerUid != remoteUid) {
      return kIsWeb
          ? remoteUid.contains(10)
              ? const Expanded(
                  flex: 1,
                  child: kIsWeb
                      ? rtc_remote_view.SurfaceView(
                          zOrderMediaOverlay: true,
                          zOrderOnTop: true,
                          uid: 10,
                          channelId: channel,
                        )
                      : rtc_remote_view.TextureView(
                          uid: 10,
                          channelId: channel,
                        ))
              : videostopUid.contains(remoteUid.first)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_2_rounded,
                          size: 80,
                          color: kColorPrimary,
                        ),
                        Text(remoteUid.first.toString()),
                      ],
                    )
                  : rtc_remote_view.SurfaceView(
                      zOrderMediaOverlay: true,
                      zOrderOnTop: true,
                      uid: remoteUid.first,
                      channelId: channel,
                    )
          : remoteUid.contains(10)
              ? const Expanded(
                  flex: 1,
                  child: kIsWeb
                      ? rtc_remote_view.SurfaceView(
                          zOrderMediaOverlay: true,
                          zOrderOnTop: true,
                          uid: 10,
                          channelId: channel,
                        )
                      : rtc_remote_view.TextureView(
                          uid: 10,
                          channelId: channel,
                        ))
              : videostopUid.contains(remoteUid.first)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_2_rounded,
                          size: 80,
                          color: kColorPrimary,
                        ),
                        Text(remoteUid.first.toString()),
                      ],
                    )
                  : rtc_remote_view.TextureView(
                      uid: remoteUid.first,
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

  _renderVideo() {
    return Expanded(
        child: Stack(
      children: [
        Row(
          children: [
            const Expanded(
                flex: 1,
                child: kIsWeb
                    ? rtc_local_view.SurfaceView()
                    : rtc_local_view.TextureView()),
            if (screenSharing)
              const Expanded(
                  flex: 1,
                  child: kIsWeb
                      ? rtc_local_view.SurfaceView.screenShare()
                      : rtc_local_view.TextureView.screenShare()),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.of(remoteUid.map(
                (e) => SizedBox(
                  width: 120,
                  height: 120,
                  child: kIsWeb
                      ? rtc_remote_view.SurfaceView(
                          uid: e,
                          channelId: channelId,
                        )
                      : rtc_remote_view.TextureView(
                          uid: e,
                          channelId: channelId,
                        ),
                ),
              )),
            ),
          ),
        )
      ],
    ));
  }

  Widget _localuserVideo() {
    if (isJoined && isPreview) {
      return const Expanded(
        flex: 1,
        child: kIsWeb
            ? rtc_local_view.SurfaceView(
                channelId: channel,
                zOrderMediaOverlay: true,
                zOrderOnTop: true,
              )
            : rtc_local_view.TextureView(
                channelId: channel,
              ),
      );
    } else if (isJoined && isPreview == false) {
      return const Icon(
        Icons.person_2_rounded,
        size: 60,
        color: kColorPrimary,
      );
    } else if (isJoined && isPreview == false) {
      return const Icon(
        Icons.person_2_rounded,
        size: 60,
        color: kColorPrimary,
      );
    } else if (isJoined && cameraInUse) {
      return const Text('Camera in Use by other media');
    } else {
      return const CircularProgressIndicator();
    }
  }

  // This method builds the container for displaying the speaker video.
  // Widget _buildSpeakerVideo() {
  //   if (_speakerUid == _localUid) {
  //     return const rtc_local_view.SurfaceView();
  //   } else if (_speakerUid == _remoteUid) {
  //     return rtc_remote_view.SurfaceView(
  //       uid: _remoteUid!,
  //       channelId: channel,
  //     );
  //   } else if (_isScreenSharing) {
  //     return const rtc_local_view.SurfaceView();
  //   } else {
  //     return Container();
  //   }
  // }
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

Future<void> openInNewTab(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      webOnlyWindowName: '_blank',
    );
  } else {
    throw 'Could not launch $url';
  }
}

void openInNewTabHtml(String url) {
  html.window.open(url, '_blank');
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

                return SizedBox(
                  height: height,
                  width: width - 400,
                  child:  Container(),
                );
              },
            ),
          ));
}
