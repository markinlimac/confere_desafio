import 'package:confere/screens/product_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Produtos',
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.dark),
        primaryColor: Color(0xff0075C4),
      ),
      home: ProductList(),
    );
  }
}