import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_projects/constants.dart';
import 'package:one_projects/controllers.dart';
import 'package:one_projects/routes/about.dart';
import 'package:one_projects/routes/project.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with WidgetsBindingObserver {
  final SessionController sc = Get.find<SessionController>();
  bool loading = true;
  bool refreshing = false;

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
  void initState() {
    super.initState();

    // run commands after init
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => sc.listProjects().then((_) => setState(() => loading = false)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.grey[100],
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
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset('assets/images/icon.png', height: 40),
                  ),
                  Text(
                    '1Projects',
                    style: defaultAppFont.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  IconButton(
                      iconSize: 18,
                      onPressed: () async {
                        // refresh projects
                        setState(() {
                          refreshing = true;
                        });

                        await sc.listProjects();

                        setState(() {
                          refreshing = false;
                        });
                      },
                      icon: Icon(refreshing ? Icons.more_horiz : Icons.sync)),
                ],
              ),
              const Divider(thickness: 1, height: 30),
              loading
                  ? const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Obx(
                          () => sc.projects.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: sc.projects.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          ProjectCard(
                                    project: sc.projects[index],
                                  ),
                                )
                              : const EmptyProjects(),
                        ),
                      ),
                    ),
            ],
          )),
    );
  }
}

class EmptyProjects extends StatelessWidget {
  const EmptyProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Icon(Icons.folder, size: 80),
        ),
        Text('No Projects (Secret Notes) found!'),
      ],
    );
  }
}

class ProjectCard extends StatefulWidget {
  const ProjectCard({Key? key, required this.project}) : super(key: key);
  final Map project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProjectPage(projectId: widget.project['ID'])),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: Listener(
          child: Card(
            color: isHovered ? mainLightColor : contrastColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "ID: ${widget.project['ID']}",
                        style: defaultAppFont.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project['TITLE'],
                        style: defaultAppFont.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SvgPicture.asset(
                                  'assets/images/vault.svg',
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              Text(widget.project['VAULT']),
                            ],
                          ),
                          Text(widget.project['EDITED']),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
