import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizo/constants.dart';
import 'package:quizo/models/menu_path.dart';
import 'package:quizo/quiz_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuPathPage extends StatefulWidget {
  const MenuPathPage({
    super.key,
    required this.init,
    this.path,
    this.user,
  });

  final bool init;
  final MenuPath? path;
  final User? user;

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

  User? currentUser;

  Future<MenuPath> fetchMenu() async {
    final response =
        await Dio().get('$BASE_URL/applications/$APPLICATION_UUID/menus');

    final data = (response.data as List<dynamic>).map(
      (e) {
        return MenuPath(
          uuid: e['uuid'] ?? '',
          name: e['name'] ?? '',
          index: int.tryParse(e['index']) ?? 0,
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

    currentUser = widget.user;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                final user = await _nativeGoogleSignIn();
                setState(() {
                  currentUser = user;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_2_outlined,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.user == null
                        ? 'Belum Login'
                        : widget.user?.email ?? '-',
                    style: GoogleFonts.robotoFlex(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                  menuPath: path,
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

Future<User?> _nativeGoogleSignIn() async {
  const webClientId =
      '705823016887-kvkjeggudbr5j87k6tfrunkin90ftfet.apps.googleusercontent.com';
  const mobileClientId =
      '705823016887-lop5f0nducif9qjipnfhb7acrvfn6cap.apps.googleusercontent.com';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: mobileClientId,
    serverClientId: webClientId,
  );

  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No Access Token found.';
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }

  final user = await Supabase.instance.client.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );

  return user.user;
}
