import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  bool _isRecording = false;
  Stream<List<int>>? _micStream;
  StreamSubscription<List<int>>? _micStreamSubscription;
  List<double> _waveformData = [];

  @override
  void initState() {
    super.initState();
    _requestMicPermission();
  }

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      // Permission granted
    } else if (status.isDenied) {
      // Permission denied
    }
  }

  void _toggleRecording() async {
    if (_isRecording) {
      _micStreamSubscription?.cancel();
      setState(() {
        _isRecording = false;
        _waveformData = [];
      });
    } else {
      _micStream = await MicStream.microphone(sampleRate: 16000);
      _micStreamSubscription = _micStream?.listen((data) {
        setState(() {
          _waveformData = data.map((e) => e.toDouble() / 150).toList();
        });
      });
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter text or start speaking',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CustomPaint(
                painter: WaveformPainter(waveformData: _waveformData),
                child: Container(),
              ),
            ),
            const SizedBox(height: 20),
            AvatarGlow(
              animate: _isRecording,
              glowColor: Colors.red,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              child: GestureDetector(
                onTap: _toggleRecording,
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;

  WaveformPainter({required this.waveformData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    if (waveformData.isEmpty) return;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (var i = 0; i < waveformData.length; i++) {
      final x = size.width * i / waveformData.length;
      final y = size.height / 2 + waveformData[i] * (size.height / 2);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
