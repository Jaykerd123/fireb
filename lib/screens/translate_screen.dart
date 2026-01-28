import 'dart:convert';
import 'package:fireb/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  final TextEditingController _searchController = TextEditingController();
  late FlutterTts _flutterTts;
  late final RecorderController _recorderController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _loadDictionary();
    _recorderController = RecorderController();
    _requestMicPermission();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
  }

  Future<void> _loadDictionary() async {
    final String response = await rootBundle.loadString('assets/dictionary.json');
    final data = await json.decode(response) as List;
    setState(() {
      _words = data.map((word) => Word.fromJson(word)).toList();
      _words.sort((a, b) => a.higaonon.compareTo(b.higaonon));
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isSearching = true;
        _filteredWords = _words.where((word) {
          final query = _searchController.text.toLowerCase();
          return word.higaonon.toLowerCase().contains(query) ||
                 word.tagalog.toLowerCase().contains(query) ||
                 word.english.toLowerCase().contains(query);
        }).toList();
      });
    } else {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
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
  void dispose() {
    _searchController.dispose();
    _recorderController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search dictionary...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildTranslationBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          const SizedBox(height: 20),
          const Text(
            'Tap the microphone to start speaking',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _filteredWords.length,
      itemBuilder: (context, index) {
        final word = _filteredWords[index];
        return _buildWordCard(word);
      },
    );
  }

  Widget _buildWordCard(Word word) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    word.higaonon,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: theme.colorScheme.secondary, size: 30),
                  onPressed: () => _speak(word.higaonon),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${word.partOfSpeech} • ${word.tagalog}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: theme.textTheme.bodySmall?.color),
            ),
            const Divider(height: 24),
            _buildTranslationSection(
              language: 'English',
              definition: word.english,
              example: word.exampleEnglish,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTranslationSection(
              language: 'Higaonon Example',
              definition: word.exampleHigaonon,
              example: '',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationSection({
    required String language,
    required String definition,
    required String example,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          language,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            definition,
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
          ),
        ),
        if (example.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4),
            child: Text(
              '“$example”',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: theme.textTheme.bodySmall?.color),
            ),
          ),
      ],
    );
  }
}
