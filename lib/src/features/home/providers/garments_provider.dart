import 'dart:isolate';

import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/home/data/fashion_repository.dart';
import 'package:demo/src/features/home/domain/garment_item_model.dart';
import 'package:flutter/widgets.dart';

final class GarmentsProvider extends ChangeNotifier {
  GarmentsProvider({required FashionRepository repository})
    : _repository = repository;

  final FashionRepository _repository;

  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error State
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final Map<String, GarmentItem> _garmentMap = {};

  final Set<String> _topwearGarments = {};
  List<GarmentItem> get topwearGarments =>
      _topwearGarments.map((id) => _garmentMap[id]).nonNulls.toList();

  final Set<String> _bottomwearGarments = {};
  List<GarmentItem> get bottomwearGarments =>
      _bottomwearGarments.map((id) => _garmentMap[id]).nonNulls.toList();

  String? _selectedTopwearGarmentId;
  GarmentItem? get selectedTopwearGarment =>
      _garmentMap[_selectedTopwearGarmentId];

  String? _selectedBottomwearGarmentId;
  GarmentItem? get selectedBottomwearGarment =>
      _garmentMap[_selectedBottomwearGarmentId];

  Future<void> getAllGarments() async {
    _setLoading();
    try {
      final response = await Isolate.run(
        _repository.getAllGarments,
        debugName: 'GarmentsProvider: getAllGarments',
      );

      // Male garments
      _addTopGarments(response.male.top);
      _addBottomGarments(response.male.bottom);

      // Female garments
      _addTopGarments(response.female.top);
      _addBottomGarments(response.female.bottom);
      _resetError();
    } catch (_) {
      _setError(AppStrings.UNKNOWN_ERROR_OCCURRED);
    } finally {
      _resetLoading();
    }
  }

  void _addTopGarments(List<GarmentItem> items) {
    for (final item in items) {
      _garmentMap[item.id] = item;
      _topwearGarments.add(item.id);
    }
  }

  void _addBottomGarments(List<GarmentItem> items) {
    for (final item in items) {
      _garmentMap[item.id] = item;
      _bottomwearGarments.add(item.id);
    }
  }

  void _setLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _resetLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _resetError() {
    _errorMessage = null;
    notifyListeners();
  }

  void updateSelectedTopwearGarment(String id) {
    _selectedTopwearGarmentId = id;
    notifyListeners();
  }

  void updateSelectedBottomwearGarment(String id) {
    _selectedBottomwearGarmentId = id;
    notifyListeners();
  }

  void resetSelectedGarments() {
    _selectedTopwearGarmentId = null;
    _selectedBottomwearGarmentId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _garmentMap.clear();
    _topwearGarments.clear();
    _bottomwearGarments.clear();

    _selectedTopwearGarmentId = null;
    _selectedBottomwearGarmentId = null;

    super.dispose();
  }
}
