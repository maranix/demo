import 'dart:async';

import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/auth/auth.dart';
import 'package:flutter/material.dart';

enum AuthState { initial, signedIn, signedOut }

final class AuthProvider extends ChangeNotifier {
  AuthProvider(AuthRepository repository) : _repository = repository {
    _authStateStream = _repository.authStateChanges().listen(_authStateChanges);
  }

  final AuthRepository _repository;

  late final StreamSubscription<User?> _authStateStream;

  // User
  User? _user;
  User? get user => _user;

  // Auth State
  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error State
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle() async {
    _setLoading();
    try {
      await _repository.signInWithGoogle();
      _resetError();
    } catch (e) {
      _setError(AppStrings.SOMETHING_WENT_WRONG_ERROR_TITLE);
    } finally {
      _resetLoading();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _setLoading();
    try {
      await _repository.signOut();
    } catch (e) {
      _setError(AppStrings.SOMETHING_WENT_WRONG_ERROR_TITLE);
    } finally {
      _resetLoading();
      notifyListeners();
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

  void _authStateChanges(User? user) {
    if (user == null) {
      _state = AuthState.signedOut;
    } else {
      _state = AuthState.signedIn;
    }

    _user = user;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateStream.cancel();
    super.dispose();
  }
}
