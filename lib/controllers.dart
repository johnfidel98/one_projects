import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

class SessionController extends GetxController {
  RxMap oneSession = RxMap({'email': '', 'id': ''});
  RxList<Map> projects = RxList([]);
  RxList<String> processedProjectIds = RxList([]);
  RxMap project = RxMap({});

  RxList procedures = RxList([]);
  RxList commands = RxList([]);
  RxList<Map> outputs = RxList([]);

  late Process process;

  Future init() async {
    // init process
    process = await Process.start('bash', [], runInShell: true);

    // monitor commands
    process.stdout.transform(utf8.decoder).listen((String output) {
      outputs.add({'o': output, 'e': 0});
    });

    process.stderr.transform(utf8.decoder).listen((String output) {
      outputs.add({'o': output, 'e': 1});
    });

    return;
  }

  Future<Map> runSession(String command) async {
    // log command
    commands.add(command);

    // send command
    process.stdin.writeln(command);

    // wait for response
    int c = 0;
    while (commands.length != outputs.length) {
      await Future.delayed(const Duration(seconds: 1));
      c += 1;

      // repeat command after 50 sec
      if (c > 50) {
        // reset c
        c = 0;

        // re-send command
        process.stdin.writeln(command);
      }
    }
    return outputs.last;
  }

  Future<bool> checkSession() async =>
      // whoami: Get information about a signed-in account
      await runSession('op whoami').then((Map response) {
        // check command response
        if (response['e'] == 0) {
          // extract login details
          List<String> fields = response['o'].toString().split('\n');

          oneSession['email'] = fields[1].split(': ')[1].trim();
          oneSession['id'] = fields[2].split(': ')[1].trim();
          return true;
        }
        return false;
      });

  Future<Map> signIn() async =>
      // signin: Sign in to a 1password account
      await runSession('op signin');

  Future listProjects() async {
    // List items
    Map raw = await runSession('op item list --categories "Secure Note"');

    if (raw['e'] == 0) {
      Map fields = {};

      bool readyTitles = false;
      // process projects map
      for (String p in raw['o'].toString().trim().split('\n')) {
        int ix = 0;
        Map data = {};
        // split by 2 or more spaces
        for (String f in p.split(RegExp(r' {2,}'))) {
          if (!readyTitles) {
            // process titles
            fields[ix] = f;
          } else {
            // process fields
            data[fields[ix]] = f;
          }

          ix += 1;
        }

        readyTitles = true;

        if (data.containsKey('ID')) {
          if (!processedProjectIds.contains(data['ID'])) {
            // add to projects
            projects.add(data);
            processedProjectIds.add(data['ID']);
          } else {
            // replace existing ones
            int ix = processedProjectIds.indexOf(data['ID']);
            projects.removeAt(ix);
            projects.insert(ix, data);
          }
        }
      }
    }
  }
}
