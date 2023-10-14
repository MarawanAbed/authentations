import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Singed In as',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(user.email!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: MaterialButton(
                onPressed: ()async {
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
