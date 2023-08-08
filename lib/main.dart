import 'package:flutter/material.dart';
import 'package:mitr_app/home_page.dart';
import 'package:mitr_app/pallete.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mitr App',
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Pallete.whiteColor,
          appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
      )
      ),


      home: const HomePage(),
    );
  }
}
