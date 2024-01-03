import 'package:flutter/material.dart';
import 'shopping_list.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Zakupów',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingList(),
    );
  }
}
