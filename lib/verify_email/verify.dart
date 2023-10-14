import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/home/home.dart';
import 'package:untitled/utils/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerificationStatus();
  }

  checkEmailVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });

      if (isEmailVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomePageScreen()
        : Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email address'),
            ElevatedButton(
              onPressed: () {
                sendVerificationEmail();
              },
              child: const Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }

  sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      Utils.showSnackBar('Verification email sent.');
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }
}

