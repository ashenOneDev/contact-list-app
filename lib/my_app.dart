import 'package:flutter/material.dart';

import 'pages/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColorDark: Colors.blue),
        home: const MainPage());
  }
}
