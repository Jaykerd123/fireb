import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  late final RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController();
    _requestMicPermission();
  }

  Future<void> _requestMicPermission() async {
    await Permission.microphone.request();
  }

  void _toggleRecording() async {
    if (_recorderController.isRecording) {
      await _recorderController.stop();
    } else {
      await _recorderController.record();
    }
    setState(() {});
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
            AudioWaveforms(
              size: const Size(double.infinity, 200.0),
              recorderController: _recorderController,
              waveStyle: const WaveStyle(
                waveColor: Colors.blue,
                showDurationLabel: true,
                spacing: 8.0,
                showBottom: false,
                extendWaveform: true,
                showMiddleLine: false,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _toggleRecording,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red,
                child: Icon(
                  _recorderController.isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorderController.dispose();
    super.dispose();
  }
}
