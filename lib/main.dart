import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizo/menu_path_page.dart';
import 'package:quizo/models/menu_path.dart';
import 'package:quizo/quiz_page.dart';
import 'package:quizo/theme.dart';
import 'package:quizo/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://yrdwbddabgzvqvhrixsb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlyZHdiZGRhYmd6dnF2aHJpeHNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTc1MDYzMTcsImV4cCI6MjAzMzA4MjMxN30.F1Z9vA91-AWAuLLqCl-4NezMtiun-WMddnvRa1zdqPg',
  );

  runApp(const QuizoApp());
}

class QuizoApp extends StatefulWidget {
  const QuizoApp({super.key});

  @override
  State<QuizoApp> createState() => _QuizoAppState();
}

class _QuizoAppState extends State<QuizoApp> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Roboto Flex", "Roboto Flex");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Quizo',
      themeMode: ThemeMode.light,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: MenuPathPage(
        init: true,
        user: Supabase.instance.client.auth.currentUser,
      ),
    );
  }
}
