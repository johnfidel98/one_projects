import 'package:get/get.dart';
import 'package:process_run/shell.dart';

ShellLinesController controller = ShellLinesController();
Shell session = Shell(stdout: controller.sink, verbose: false);

class SessionController extends GetxController {
  RxList projects = RxList([]);
  RxMap project = RxMap({});

  RxList procedures = RxList([]);

  Future<Map> runSession(String commands) async {
    // whoami: Get information about a signed-in account

    controller.stream.listen((event) {
      // Handle output

      // ...
      // If needed kill the shell
      session.kill();
    });
    try {
      await session.run(commands);
    } on ShellException catch (_) {
      // We might get a shell exception
    }
    return {};
  }

  Future<Map> checkInstallation() async {
    // check if 1assword CLI is installed
    return {};
  }

  Future<Map> checkSession() async {
    // whoami: Get information about a signed-in account
    return {};
  }

  Future<Map> signIn() async {
    // signin: Sign in to a 1password account
    return {};
  }
}
