import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/auth/auth_page.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/home/home.dart';
import 'package:untitled/utils/utils.dart';
import 'package:untitled/verify_email/verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user.emailVerified) {
              return const HomePageScreen(); // Navigate to home page if email is verified
            } else {
              return const VerifyEmailPage(); // Navigate to verification page if email is not verified
            }
          } else {
            return const AuthPage(); // Navigate to the authentication page if the user is not logged in
          }
        },
      ),
    );
  }
}
