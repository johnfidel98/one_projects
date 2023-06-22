import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_projects/controllers.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, this.projectId}) : super(key: key);

  final String? projectId;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final SessionController sc = Get.find<SessionController>();

  @override
  void initState() {
    super.initState();

    // load project details
    sc.setProject(widget.projectId!);
  }

  setProjectFolder(String path) {}

  setProjectSecrets(String path) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
