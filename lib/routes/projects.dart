import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_projects/constants.dart';
import 'package:one_projects/controllers.dart';
import 'package:one_projects/routes/about.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final SessionController sc = Get.find<SessionController>();

  handleSelected(String sel) async {
    if (sel == 'about') {
      // navigate to about page
      Get.to(() => const AboutPage());
    } else {
      // exit app
      Get.defaultDialog(
        title: 'Exit App',
        content: const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text('Are you sure you want to close 1Projects app?'),
        ),
        onConfirm: () =>
            // exit app
            exit(0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: contrastColor,
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    onSelected: handleSelected,
                    itemBuilder: (BuildContext context) {
                      return const [
                        PopupMenuItem(
                          value: 'about',
                          child: MenuItem(label: 'About', icon: Icons.help),
                        ),
                        PopupMenuItem(
                          value: 'exit',
                          child: MenuItem(label: 'Exit', icon: Icons.logout),
                        ),
                      ];
                    },
                    child: Obx(
                      () => Container(
                        color: mainLightColor,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(sc.oneSession['email']),
                                Text(
                                  sc.oneSession['id'],
                                  style: defaultAppFont.copyWith(
                                      fontSize: 8, height: 2.5),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.unfold_more),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Projects',
                    style: defaultAppFont.copyWith(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 30),
            ],
          )),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(icon),
        ),
        Text(label),
      ],
    );
  }
}
