import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_projects/components/layout.dart';
import 'package:one_projects/constants.dart';
import 'package:one_projects/controllers.dart';
import 'package:one_projects/routes/projects.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with WidgetsBindingObserver {
  final SessionController sc = Get.find<SessionController>();
  bool loading = true;
  String state = 'Authenticating ...';
  late Timer retryTimer;

  @override
  void initState() {
    super.initState();

    // avoid not initialized error
    retryTimer = Timer(const Duration(milliseconds: 1), () {});

    // run commands after init
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => authenticate());
  }

  navProjects() =>
      // route to projects
      Get.offAll(() => const ProjectsPage());

  Future authenticate() async =>
      // attempt signin
      await sc.signIn().then((Map resp) {
        if (resp['e'] == 0) {
          navProjects();
        }

        // calculate retry
        Random random = Random();
        int retryTime = random.nextInt(20) + 5;

        // update state
        setState(() {
          loading = false;
          state = 'Authentication Failed! Retrying in $retryTime sec ...';
        });

        retryTimer = Timer(Duration(seconds: retryTime), () async {
          // update state
          setState(() {
            loading = true;
            state = 'Retrying authentication ...';
          });

          // check if signedin
          await sc.checkSession().then((bool loggedIn) async {
            if (loggedIn) {
              navProjects();
            } else {
              // retry authenticate
              await authenticate();
            }
          });
        });
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutSkel(
          mainArea: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/1Password_favicon.svg',
                        height: 120,
                        width: 120,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: loading
                            ? const CircularProgressIndicator(
                                strokeWidth: 0.5,
                              )
                            : null,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '1Projects',
                      style: defaultAppFont.copyWith(
                          fontSize: 70, color: textColor),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Divider(
                thickness: 0.5,
                height: 40,
                color: Color.fromARGB(200, 26, 24, 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                state,
                style:
                    defaultAppFont.copyWith(color: textSubColor, fontSize: 20),
              ),
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    if (retryTimer.isActive) {
      retryTimer.cancel();
    }
    super.dispose();
  }
}
