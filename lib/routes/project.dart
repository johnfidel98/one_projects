import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, this.projectId}) : super(key: key);

  final String? projectId;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  void initState() {
    super.initState();

    // load project details
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
