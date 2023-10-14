import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/forget/forget_password.dart';
import 'package:untitled/register/register.dart';
import 'package:untitled/utils/comp.dart';

import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleAuthMode});

  final VoidCallback toggleAuthMode;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      // Sign in without email verification
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Utils.showSnackBar('Wrong password provided for that user.');
      }
    }
    // Remove the loading dialog after a successful login
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Login Here',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthFormField(
                    labelText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthFormField(
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password must not be empty';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(CupertinoIcons.eye_slash_fill),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      navigateWithBack(context, const ForgetPassword());
                    },
                    child: const Text('Forget Your password'),
                  ),
                  AuthButton(
                    label: 'LOGIN',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        signIn();
                      }
                    },
                  ),
                  AuthToggleLink(
                    title: 'does\'t have an account ?',
                    text: 'Register',
                    onPressed: () {
                      widget.toggleAuthMode();
                    },
                  ),
                  const AuthDivider(),
                  // TextButton(
                  //   onPressed: () async {
                  //     try {
                  //       UserCredential userCredential =
                  //           await FirebaseAuth.instance.signInAnonymously();
                  //       print(userCredential);
                  //     } catch (e) {
                  //       Utils.showSnackBar(
                  //           'An error occurred while signing in anonymously.');
                  //     }
                  //   },
                  //   child: const Text(
                  //     'Guest',
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
