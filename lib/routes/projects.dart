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
    double topbarHeight = 70;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: topbarHeight,
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    color: mainColor,
                  ),
                ),
                TextButton(
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
                    child: Icon(
                      refreshing ? Icons.more_horiz : Icons.sync,
                      color: Colors.black87,
                    )),
              ],
            ),
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
                () => Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          sc.oneSession['email'],
                          style: defaultAppFont.copyWith(color: Colors.black),
                        ),
                        Text(
                          sc.oneSession['id'],
                          style: defaultAppFont.copyWith(
                              fontSize: 8, height: 2.0, color: Colors.black87),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.unfold_more, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                loading
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  topbarHeight,
                              width: MediaQuery.of(context).size.width),
                          const SizedBox(
                            height: 300,
                            width: 300,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 80),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 3,
                                child: Obx(
                                  () => sc.projects.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount: sc.projects.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              ProjectCard(
                                            project: sc.projects[index],
                                          ),
                                        )
                                      : const EmptyProjects(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            )),
      ),
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
                      const SizedBox(height: 30),
                      Text(
                        widget.project['TITLE'],
                        style: defaultAppFont.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 15),
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
          child: Icon(icon, color: Colors.black87),
        ),
        Text(label),
      ],
    );
  }
}
