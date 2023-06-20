import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_projects/constants.dart';
import 'package:one_projects/controllers.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final SessionController sc = Get.find<SessionController>();

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
                  Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(sc.oneSession['email']),
                          Text(
                            sc.oneSession['id'],
                            style: defaultAppFont.copyWith(
                                fontSize: 8, height: 2.5),
                          ),
                        ],
                      )),
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
