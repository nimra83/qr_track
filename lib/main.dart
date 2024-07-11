// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/services/theme_service.dart';
import 'package:food_saver/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyAt_xf4dQfN8S7T97FpKrPYzm-aBPhDNcE',
        appId: '1:1059766292331:android:2f93582fe8142c0d38862e',
        messagingSenderId: '1059766292331',
        projectId: 'qr-track-d7650',
        storageBucket:
            'https://console.firebase.google.com/project/qr-track-d7650/storage/qr-track-d7650.appspot.com/files'),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeService.instance,
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Qr Track',
            theme: themeService.currentThemeMode == 'Light Theme'
                ? ThemeData.light()
                : ThemeData.dark(),
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
