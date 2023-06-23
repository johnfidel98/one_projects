import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:one_projects/components/loading.dart';
import 'package:one_projects/constants.dart';
import 'package:one_projects/controllers.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, this.projectId}) : super(key: key);

  final String? projectId;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> with WidgetsBindingObserver {
  final SessionController sc = Get.find<SessionController>();
  Map project = {};
  bool settingDir = false;

  @override
  void initState() {
    super.initState();

    // load project details
    sc.getProject(widget.projectId!);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(refreshProject);
  }

  refreshProject(_) async => await sc
      .getProject(widget.projectId!)
      .then((Map? prj) => setState(() => project = prj ?? {}));

  setProjectSecrets(String path) {}

  void pickDirectoryPath() async {
    // get selected dir
    String? pickedDir = await FilePicker.platform.getDirectoryPath();

    if (pickedDir != null) {
      setState(() {
        settingDir = true;
      });
      // update directory path
      Map? updatedProject = await sc
          .runSession(
              "op item edit ${widget.projectId} 'location[text]=$pickedDir' --format json")
          .then((Map raw) {
        if (raw['e'] == 0) {
          // return project
          return json.decode(raw['o']) ?? {};
        }
        return null;
      });

      // update state
      setState(() {
        settingDir = false;
        if (updatedProject != null) {
          project = updatedProject;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            height: 165,
            child: TextButton(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          )),
                    ),
                    const Positioned(
                      left: 18,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                onPressed: () => Get.back()),
          ),
          Expanded(
            child: project.containsKey('id')
                ? ProjectContent(
                    project: project,
                    pathPicker: pickDirectoryPath,
                    settingDir: settingDir,
                  )
                : const GeneralLoading(),
          ),
        ],
      ),
    );
  }
}

class ProjectContent extends StatelessWidget {
  const ProjectContent({
    super.key,
    required this.project,
    required this.pathPicker,
    required this.settingDir,
  });

  final Map project;
  final Function() pathPicker;
  final bool settingDir;

  @override
  Widget build(BuildContext context) {
    List<Map> secrets = [];
    String description = 'No project description found ...', location = '';
    for (Map field in project['fields']) {
      if (field['label'] == 'notesPlain') {
        // extract markdown description
        if (field.containsKey('value')) {
          description = field['value'];
        }
      } else if (field['label'] == 'location') {
        // extract folder location
        location = field['value'];
      } else if (field['type'] == 'REFERENCE') {
        // use as secret
        secrets.add(field);
      }
    }

    return Container(
      color: contrastColor,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Text("${project['vault']['name']} Vault"),
                    ],
                  ),
                  Text(
                    "ID: ${project['id']}",
                    style: defaultAppFont.copyWith(fontSize: 12),
                  ),
                ],
              ),
              Text(
                project['title'],
                style: defaultAppFont.copyWith(fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Icon(Icons.update, size: 18),
                    ),
                    Text('Version ${project["version"].toString()}'),
                    const SizedBox(width: 15),
                    const Text('-'),
                    const SizedBox(width: 15),
                    Text(
                        "Updated : ${timeago.format(DateTime.parse(project['updated_at']))}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                child: Text(
                  'Location',
                  style: defaultAppFont.copyWith(fontSize: 25),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: pathPicker,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    decoration: BoxDecoration(
                      color: mainLightColor,
                      border: Border.all(width: 0.5, color: mainColor),
                    ),
                    child: Text(
                      settingDir
                          ? 'Updating Location ...'
                          : location.isNotEmpty
                              ? location
                              : 'Click To Set Location ...',
                      style: defaultAppFont.copyWith(
                        fontStyle: location.isNotEmpty
                            ? FontStyle.normal
                            : FontStyle.italic,
                        color: location.isNotEmpty ? null : Colors.black,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                child: Text(
                  'Description',
                  style: defaultAppFont.copyWith(fontSize: 25),
                ),
              ),
              Container(
                color: Colors.grey[100],
                height: description.isEmpty ? 100 : 300,
                width: MediaQuery.of(context).size.width,
                child: Markdown(data: description),
              ),
              secrets.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Secrets',
                              style: defaultAppFont.copyWith(fontSize: 25),
                            ),
                          ),
                          Text(location.isNotEmpty
                              ? 'Install selected secrets on set location [ $location ] into a .env file. If the file already exists, it will be updated!'
                              : 'Kindly set location to install the secrets below ...'),
                        ],
                      ),
                    )
                  : const SizedBox(height: 20),
              if (secrets.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: secrets.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ProjectSecret(
                      data: secrets[index],
                      installLocation: location,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectSecret extends StatefulWidget {
  const ProjectSecret({
    super.key,
    required this.data,
    required this.installLocation,
  });

  final Map data;
  final String installLocation;

  @override
  State<ProjectSecret> createState() => _ProjectSecretState();
}

class _ProjectSecretState extends State<ProjectSecret> {
  final SessionController sc = Get.find<SessionController>();
  bool updatingSecret = false;

  Future<void> createFileInDirectory(String content) async {
    // Get the application directory
    Directory directory = Directory(widget.installLocation);

    // Define the file name and path
    String filePath = path.join(directory.path, '.env.1projects');

    // Create the file
    File file = File(filePath);
    await file.create();

    // write content to the file
    String fileContent = content;
    await file.writeAsString(fileContent);
  }

  void updateSecret() async {
    setState(() {
      updatingSecret = true;
    });

    // get secret details
    Map? item = await sc
        .runSession("op item get ${widget.data['value']} --format json")
        .then((Map raw) {
      if (raw['e'] == 0) {
        // return project
        return json.decode(raw['o']) ?? {};
      }
      return null;
    });

    if (item != null) {
      // extract item fields
      String content = '';
      for (Map f in item['fields']) {
        if (f.containsKey('value') && f['purpose'] != 'NOTES') {
          content +=
              '${item["category"]}_${f["label"].toString().toUpperCase()}=${f["value"]}\n';
        }
      }
      // update .env file
      await createFileInDirectory(content);
    } else {
      // notify user
      Get.defaultDialog(
        title: 'Missing Item',
        content: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
              'Couldn\'t find the referenced item "${widget.data["label"]}" in your 1Password vault!'),
        ),
      );
    }
    setState(() {
      updatingSecret = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: mainColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.password),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 190,
                      child: Text(
                        widget.data['label'],
                        style: defaultAppFont.copyWith(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              updatingSecret
                  ? const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Material(
                      child: TextButton(
                        onPressed: updateSecret,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.vertical_align_bottom),
                            Text(
                              'Install',
                              style: defaultAppFont.copyWith(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
