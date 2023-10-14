import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/home/home.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utils/comp.dart';
import 'package:untitled/verify_email/verify.dart';

import '../utils/utils.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.toggleAuthMode});

  final VoidCallback toggleAuthMode;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isVisible = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> register() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {

      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()),
        );
      } else {
        Utils.showSnackBar('Password and confirm password do not match.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          Utils.showSnackBar('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          Utils.showSnackBar('The account already exists for that email.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        Utils.showSnackBar(e.toString());
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
                    'Register Here',
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
                  const SizedBox(
                    height: 20,
                  ),
                  AuthFormField(
                    labelText: 'Confirm Password', // Add this field
                    prefixIcon: Icons.lock, // You can change the icon as needed
                    controller: confirmPasswordController, // Use the new controller
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password must not be empty';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
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
                  const SizedBox(
                    height: 20,
                  ),
                  AuthButton(
                    label: 'Register',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        register();
                      }
                    },
                  ),
                  AuthToggleLink(
                    title: 'Already have an account?',
                    text: 'Login',
                    onPressed: () {
                      widget.toggleAuthMode();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;
  final Widget? suffixIcon;

  const AuthFormField({
    super.key,
    this.obscureText = false,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AuthToggleLink extends StatelessWidget {
  final String text;
  final String title;
  final VoidCallback onPressed;

  const AuthToggleLink({
    super.key,
    required this.text,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        TextButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ],
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 3,
      thickness: 4,
      color: Colors.deepPurple,
    );
  }
}



