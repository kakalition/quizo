import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizo/menu_path_page.dart';
import 'package:quizo/models/menu_path.dart';
import 'package:quizo/quiz_page.dart';
import 'package:quizo/theme.dart';
import 'package:quizo/util.dart';

void main() {
  runApp(const QuizoApp());
}

class QuizoApp extends StatelessWidget {
  const QuizoApp({super.key});

  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Roboto Flex", "Roboto Flex");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Quizo',
      themeMode: ThemeMode.light,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: const MenuPathPage(init: true),
    );
  }
}


