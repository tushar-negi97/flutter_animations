import 'dart:async';

import 'package:bloc_app/ecom/cart_screen.dart';
import 'package:bloc_app/ecom/login_screen.dart';
import 'package:bloc_app/ecom/onboarding_screen.dart';
import 'package:bloc_app/ecom/splash_screen.dart';
import 'package:bloc_app/ecom/bottonNavbar.dart';
import 'package:bloc_app/ecom/homescreen.dart';
import 'package:bloc_app/ecom/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rive/rive.dart';

void main() {
  unawaited(RiveFile.initialize());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-commerce Animation POC',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/navigationHome': (context) => const BottomNavigationScreen()
      },
    );
  }
}
