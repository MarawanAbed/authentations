import 'package:flutter/material.dart';

void navigateWithoutBack(BuildContext context,Widget screen) {
  Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => screen));
}

void navigateWithBack(BuildContext context,Widget screen) {
  Navigator.push(context, MaterialPageRoute(
      builder: (context) => screen));
}