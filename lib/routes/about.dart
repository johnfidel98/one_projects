import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_projects/components/layout.dart';
import 'package:one_projects/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutSkel(
        mainArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/1Password_favicon.svg',
                    height: 100,
                    width: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1Projects',
                            style: defaultAppFont.copyWith(
                                fontSize: 30, color: textColor)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                              'Map and sync your projects respectively.',
                              style: defaultAppFont.copyWith(
                                  fontSize: 18, color: textSubColor)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                  '1Projects allows you to map your 1Password credentials to the respective project folders. From here you can set instructions (for new members) on how to get the credentials as well as similarly set them up.',
                  style: defaultAppFont.copyWith(
                      fontSize: 14, color: textColor, height: 1.5)),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(30.0),
              color: const Color.fromARGB(25, 0, 0, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Nanda',
                          style: defaultAppFont.copyWith(
                              fontSize: 20, color: textColor)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Developed By',
                            style: defaultAppFont.copyWith(
                                fontSize: 12, color: textSubColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        sideArea: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
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
                                  color: contrastColor,
                                )),
                          ),
                          const Positioned(
                            left: 18,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: contrastColor,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => Get.back()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
