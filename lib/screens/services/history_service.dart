import 'package:flutter/foundation.dart';
import 'package:fireb/models/word.dart';

class HistoryService with ChangeNotifier {
  final List<Word> _history = [];

  List<Word> get history => _history;

  void addWordToHistory(Word word) {
    // Remove the word if it already exists to avoid duplicates and move it to the top.
    _history.removeWhere((w) => w.higaonon == word.higaonon);
    _history.insert(0, word);

    // To keep the list from getting too long, you can limit its size.
    if (_history.length > 20) {
      _history.removeLast();
    }

    notifyListeners();
  }
}
