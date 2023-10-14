import 'package:flutter/material.dart';
import 'package:untitled/login/login.dart';
import 'package:untitled/register/register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(toggleAuthMode: toggleAuthMode)
        : RegisterScreen(toggleAuthMode: toggleAuthMode);
  }
}
