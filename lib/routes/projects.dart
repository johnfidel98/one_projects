import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_projects/components/layout.dart';
import 'package:timeago/timeago.dart' as timeago;
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
      body: LayoutSkel(
        sideArea: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset('assets/images/icon.png', height: 180),
                  ),
                  Text(
                    '1Projects',
                    style: defaultAppFont.copyWith(
                      fontSize: 40,
                      color: contrastColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      thickness: 0.5,
                      height: 100,
                      color: contrastColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        style: const ButtonStyle(
                          side: MaterialStatePropertyAll(
                            BorderSide(color: contrastColor, width: 0.5),
                          ),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          ),
                        ),
                        child: Row(
                          children: [
                            refreshing
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: contrastColor,
                                    ),
                                  )
                                : const Icon(
                                    Icons.sync,
                                    color: contrastColor,
                                    size: 20,
                                  ),
                            SizedBox(width: refreshing ? 8 : 5),
                            Text(
                              'Reload Projects',
                              style: defaultAppFont.copyWith(
                                fontSize: 20,
                                height: 1.1,
                                color: contrastColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                () => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            sc.oneSession['email'],
                            style:
                                defaultAppFont.copyWith(color: contrastColor),
                          ),
                          Text(
                            sc.oneSession['id'],
                            style: defaultAppFont.copyWith(
                                fontSize: 8, height: 2.0, color: contrastColor),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.unfold_more, color: contrastColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        mainArea: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Stack(
              children: [
                Obx(
                  () => sc.projects.isNotEmpty
                      ? SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: sc.projects.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ProjectCard(
                              project: sc.projects[index],
                            ),
                          ),
                        )
                      : const EmptyProjects(),
                ),
                if (loading)
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width),
                      const SizedBox(
                        height: 300,
                        width: 300,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ],
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
                      Text(widget.project['vault']['name']),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        widget.project['title'],
                        style: defaultAppFont.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 3.0),
                                child: Icon(Icons.update, size: 18),
                              ),
                              Text(
                                  'Version ${widget.project["version"].toString()}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 18),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text(timeago.format(DateTime.parse(
                                    widget.project['updated_at']))),
                              ),
                            ],
                          ),
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
