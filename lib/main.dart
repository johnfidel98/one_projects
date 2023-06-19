import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_projects/routes/auth.dart';
import 'package:one_projects/routes/about.dart';
import 'package:one_projects/routes/project.dart';
import 'package:one_projects/routes/projects.dart';

void main() {
  // check if previous session exists

  runApp(const MainApp(
    initRoute: '/projects',
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initRoute});
  final String initRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initRoute,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/auth', page: () => const AuthPage()),
        GetPage(name: '/project', page: () => const ProjectPage()),
        GetPage(name: '/projects', page: () => const ProjectsPage()),
        GetPage(name: '/about', page: () => const AboutPage()),
      ],
    );
  }
}
