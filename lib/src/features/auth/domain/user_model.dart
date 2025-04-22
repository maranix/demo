import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User extends Equatable {
  const User({required this.id});

  final String id;

  static User fromFirebaseAuth(firebase_auth.User firebaseUser) {
    return User(id: firebaseUser.uid);
  }

  @override
  List<Object> get props => [id];
}
