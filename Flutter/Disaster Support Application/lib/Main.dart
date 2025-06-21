import 'package:flutter/material.dart';
import 'page/home_page.dart';

void main() {
  runApp(AfetDestekApp());
}

class AfetDestekApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Afet Destek',  
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            
            backgroundColor: Colors.blue, // Buton rengi
            foregroundColor: Colors.white, // Buton yazı rengi
            ),
        ),
        ),
      home: HomePage(),
    );
  }
}