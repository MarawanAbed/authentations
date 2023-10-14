import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/register/register.dart';
import '../utils/utils.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var emailController=TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  forgetPassword()async
  {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    Utils.showSnackBar('Password Reset Email Sent');
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Reset Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Receive an Email to\n'
                'reset your password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                  height:20
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
                height:20
              ),
              AuthButton(
                label: 'Reset Password',
                onPressed: () {
                  if(formKey.currentState!.validate())
                  {
                    forgetPassword();
                  }
                },

              ),

            ],
          ),
        ),
      ),
    );
  }

}
