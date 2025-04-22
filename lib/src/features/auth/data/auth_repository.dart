import 'package:demo/src/features/auth/domain/user_model.dart';

abstract interface class AuthRepository {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> signInWithGoogle();

  Future<void> signOut();
}
