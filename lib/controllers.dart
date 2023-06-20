import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

class SessionController extends GetxController {
  RxMap oneSession = RxMap({'email': '', 'id': ''});
  RxList projects = RxList([]);
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
    while (commands.length != outputs.length) {
      await Future.delayed(const Duration(seconds: 1));
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
}
