import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

final class SelfieProvider extends ChangeNotifier {
  static const int _maxSelfies = 6;
  int get maxSelfieCount => _maxSelfies;

  final List<XFile?> _capturedSelfies = List.filled(_maxSelfies, null);
  List<XFile?> get capturedSelfies => _capturedSelfies;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool get isComplete => !_capturedSelfies.contains(null);

  void captureSelfie(XFile file) {
    _capturedSelfies[_currentIndex] = file;

    if (_currentIndex < _maxSelfies - 1) {
      _currentIndex++;
    }

    notifyListeners();
  }

  void deleteSelfieAt(int index) {
    if (index >= 0 && index < _maxSelfies) {
      _capturedSelfies[index] = null;
      _currentIndex = index;
      notifyListeners();
    }
  }
}
