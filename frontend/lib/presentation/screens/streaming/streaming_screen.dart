import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class StreamingScreen extends StatefulWidget {
  final String streamId;
  final bool isHost;

  const StreamingScreen({
    super.key,
    required this.streamId,
    this.isHost = false,
  });

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  bool _isMicMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _initializeWebRTC();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _initializeWebRTC() async {
    if (widget.isHost) {
      await _initLocalStream();
    }
    // Add WebRTC connection setup logic here
  }

  Future<void> _initLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print('Error accessing media devices: $e');
    }
  }

  void _toggleMicrophone() {
    if (_localStream != null) {
      final audioTracks = _localStream!.getAudioTracks();
      for (var track in audioTracks) {
        track.enabled = !track.enabled;
      }
      setState(() {
        _isMicMuted = !_isMicMuted;
      });
    }
  }

  void _toggleCamera() {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      for (var track in videoTracks) {
        track.enabled = !track.enabled;
      }
      setState(() {
        _isCameraOff = !_isCameraOff;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHost ? 'Broadcasting' : 'Watching Stream'),
        actions: [
          if (widget.isHost)
            IconButton(
              icon: Icon(_isMicMuted ? Icons.mic_off : Icons.mic),
              onPressed: _toggleMicrophone,
              tooltip: 'Toggle Microphone',
            ),
          if (widget.isHost)
            IconButton(
              icon: Icon(_isCameraOff ? Icons.videocam_off : Icons.videocam),
              onPressed: _toggleCamera,
              tooltip: 'Toggle Camera',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: widget.isHost
                  ? RTCVideoView(_localRenderer, mirror: true)
                  : RTCVideoView(_remoteRenderer),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stream: ${widget.streamId}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isHost
                        ? 'You are broadcasting to your audience'
                        : 'You are watching this stream',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.close();
    super.dispose();
  }
}
