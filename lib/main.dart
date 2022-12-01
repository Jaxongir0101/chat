import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled3/chat_page.dart';
import 'package:untitled3/mainview.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MessageView()),
    ],
    child: const MyApp(),
  ),
  );;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: GroupItems(),
    );
  }
}
