import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isVideoDisabled = false;
  List<int> _remoteUids = [];

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'YOUR_AGORA_APP_ID', // Replace with your Agora App ID
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            _remoteUids.add(remoteUid);
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUids.remove(remoteUid);
          });
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();
    await _joinChannel();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: null, // Add your token if using token authentication
      channelId: 'health_monitor', // Your channel name
      uid: 0, // User ID
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Widget _renderRemoteVideo() {
    if (_remoteUids.isEmpty) {
      return const Center(
        child: Text('Waiting for doctor to join...'),
      );
    }
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: _remoteUids[0]),
        connection: const RtcConnection(channelId: 'health_monitor'),
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (!_isJoined) {
      return const Center(
        child: Text('Initializing...'),
      );
    }
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _renderRemoteVideo(),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: _renderLocalPreview(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                    _engine.muteLocalAudioStream(_isMuted);
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isVideoDisabled ? Icons.videocam_off : Icons.videocam,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVideoDisabled = !_isVideoDisabled;
                    });
                    _engine.muteLocalVideoStream(_isVideoDisabled);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}