import 'package:flutter/material.dart';
import 'package:habit_tracker/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(
      fontFamily: 'Open sans',
    ),
  ));
}
