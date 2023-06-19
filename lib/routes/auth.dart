import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_projects/components/layout.dart';
import 'package:one_projects/constants.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutSkel(
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
                    const SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '1Projects',
                  style: TextStyle(fontSize: 70, color: textColor),
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
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Authenticating ...',
              style: TextStyle(color: textSubColor),
            ),
          ),
        ],
      ),
    ));
  }
}
