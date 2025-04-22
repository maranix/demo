import 'package:demo/firebase_options.dart';
import 'package:demo/src/app.dart';
import 'package:demo/src/features/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = FirebaseAuthRepository();

  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(authRepository),
      child: const DemoApp(),
    ),
  );
}
