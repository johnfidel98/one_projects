import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:one_projects/routes/auth.dart';
import 'package:one_projects/routes/about.dart';
import 'package:one_projects/routes/projects.dart';

void main() {
  // check if previous session exists

  runApp(const MainApp(
    initRoute: '/auth',
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initRoute});
  final String initRoute;

  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      initialRoute: initRoute,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/auth', page: () => const AuthPage()),
        GetPage(name: '/projects', page: () => const ProjectsPage()),
        GetPage(name: '/about', page: () => const AboutPage()),
      ],
    );
  }
}
