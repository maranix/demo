import 'package:demo/src/features/auth/data/auth_repository.dart';
import 'package:demo/src/features/auth/domain/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

final class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  final GoogleSignIn _googleSignIn;
  final firebase_auth.FirebaseAuth _auth;

  @override
  User? get currentUser {
    if (_auth.currentUser == null) return null;

    return User.fromFirebaseAuth(_auth.currentUser!);
  }

  @override
  Stream<User?> authStateChanges() => firebase_auth.FirebaseAuth.instance
      .authStateChanges()
      .map(_mapFirebaseUserToUser);

  @override
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user == null) return null;

    return User.fromFirebaseAuth(userCredential.user!);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _auth.signOut(),
    ], eagerError: true);
  }

  User? _mapFirebaseUserToUser(firebase_auth.User? user) {
    if (user != null) return User.fromFirebaseAuth(user);
    return null;
  }
}
