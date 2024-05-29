import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final brightness = View.of(context).platformDispatcher.platformBrightness;

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

class MenuPathPage extends StatefulWidget {
  const MenuPathPage({super.key, required this.init, this.path});

  final bool init;
  final MenuPath? path;

  @override
  State<MenuPathPage> createState() => _MenuPathPageState();
}

class _MenuPathPageState extends State<MenuPathPage> {
  late MenuPath currentPath;

  @override
  void initState() {
    super.initState();

    if (widget.init) {
      currentPath = const MenuPath(
        uuid: '0',
        title: '',
        description: '',
        children: [
          MenuPath(
            uuid: '1',
            title: 'Kelas 7 SMP',
            description: '',
            children: [
              MenuPath(
                uuid: '1a',
                title: 'Ilmu Pengetahuan Sosial Semester 1',
                description: '',
                children: [],
              ),
              MenuPath(
                uuid: '1b',
                title: 'Ilmu Pengetahuan Sosial Semester 2',
                description: '',
                children: [],
              ),
            ],
          ),
          MenuPath(
            uuid: '2',
            title: 'Kelas 8 SMP',
            description: '',
            children: [
              MenuPath(
                uuid: '2a',
                title: 'Kimia Semester 3',
                description: '',
                children: [],
              ),
              MenuPath(
                uuid: '2b',
                title: 'Kimia Semester 4',
                description: '',
                children: [],
              ),
            ],
          ),
          MenuPath(
            uuid: '3',
            title: 'Kelas 9 SMP',
            description: '',
            children: [
              MenuPath(
                uuid: '3a',
                title: 'Fisika Semester 5',
                description: '',
                children: [],
              ),
              MenuPath(
                uuid: '3b',
                title: 'Fisika Semester 6',
                description: '',
                children: [],
              ),
            ],
          ),
        ],
      );
    } else {
      currentPath = widget.path!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.init ? 'Quizo' : widget.path!.title,
          style: GoogleFonts.robotoFlex(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Daftar Course',
                style: GoogleFonts.robotoFlex(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return MenuPathTile(
                  path: currentPath.children[index],
                );
              },
              separatorBuilder: (context, index) {
                if ((index - 1) != currentPath.children.length) {
                  return const Divider(
                    height: 0,
                    thickness: 0.5,
                  );
                }

                return const SizedBox();
              },
              itemCount: currentPath.children.length,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPathTile extends StatelessWidget {
  const MenuPathTile({
    super.key,
    required this.path,
  });

  final MenuPath path;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (path.children.isNotEmpty) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, _, __) {
                  return MenuPathPage(
                    init: false,
                    path: path,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );

            return;
          }

          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, _, __) {
                return QuizPage(
                  uuid: path.uuid,
                  title: path.title,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  )
                      .chain(
                        CurveTween(
                          curve: Curves.easeInOutCubicEmphasized,
                        ),
                      )
                      .animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.05),
                ),
                child: Icon(
                  Icons.circle,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                path.title,
                style: GoogleFonts.robotoFlex(
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
