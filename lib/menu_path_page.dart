import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizo/constants.dart';
import 'package:quizo/models/menu_path.dart';
import 'package:quizo/quiz_page.dart';

class MenuPathPage extends StatefulWidget {
  const MenuPathPage({super.key, required this.init, this.path});

  final bool init;
  final MenuPath? path;

  @override
  State<MenuPathPage> createState() => _MenuPathPageState();
}

class _MenuPathPageState extends State<MenuPathPage> {
  MenuPath currentPath = const MenuPath(
    uuid: '',
    appUuid: null,
    parentUuid: null,
    name: '',
    index: 0,
    children: [],
  );

  Future<MenuPath> fetchMenu() async {
    final response =
        await Dio().get('$BASE_URL/applications/$APPLICATION_UUID/menus');

    final data = (response.data as List<dynamic>).map(
      (e) {
        return MenuPath(
          uuid: e['uuid'] ?? '',
          name: e['name'] ?? '',
          index: e['index'] ?? 0,
          appUuid: e['appUuid'],
          parentUuid: e['parentUuid'],
          children: [],
        );
      },
    );

    List<MenuPath> mapToMenuPathChildren(String? parentUuid) {
      var currentLevelMenus =
          data.where((element) => element.parentUuid == parentUuid).toList();

      currentLevelMenus.sort((a, b) => a.index.compareTo(b.index));

      currentLevelMenus = currentLevelMenus.map((menu) {
        return menu.copyWith(children: mapToMenuPathChildren(menu.uuid));
      }).toList();

      return currentLevelMenus;
    }

    return MenuPath(
      uuid: '',
      name: '',
      index: 0,
      appUuid: null,
      parentUuid: null,
      children: mapToMenuPathChildren(null),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.init) {
      fetchMenu().then(
        (value) {
          setState(() {
            currentPath = value;
          });
        },
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
          widget.init ? 'Quizo' : widget.path!.name,
          style: GoogleFonts.robotoFlex(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final data = await fetchMenu();

          setState(() {
            currentPath = data;
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

            return;
          }

          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, _, __) {
                return QuizPage(
                  uuid: path.uuid,
                  title: path.name,
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
                path.name,
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
