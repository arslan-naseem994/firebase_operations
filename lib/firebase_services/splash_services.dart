import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/view/auth/login_screen.dart';
import 'package:firebases/view/upload_data__to_firebase/upload_image.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const LoginScreen())));
      });
    }
    if (user == null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const LoginScreen())));
      });
    }
  }
}
