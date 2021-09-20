import 'dart:async';

import 'package:chatquick/onboardingcomp/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatquick/home.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink.shade200,
          accentColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.pink.shade200,
            iconTheme: IconThemeData(color: Colors.white,size: 30),
          ),
        ),
        home:Loading()
    )
    );
  });
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Home();
  }
}
