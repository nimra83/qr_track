import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/utils/routes.dart';
import 'package:food_saver/screens/splash_screen.dart';
import 'package:feature_discovery/feature_discovery.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyD2VSSY6rGcaOL7QQ0gX0cSkfIm1rTMKQw',
        appId: '1:512953012186:android:3ba35c539c3e4c28e37ae3',
        messagingSenderId: '512953012186',
        projectId: 'food-saver-369e8',
        storageBucket: 'gs://food-saver-369e8.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: MaterialApp(
        title: 'Food Saver',
        theme: ThemeData(),
        debugShowCheckedModeBanner: false,
        initialRoute: MySplash.routename,
        routes: routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}
