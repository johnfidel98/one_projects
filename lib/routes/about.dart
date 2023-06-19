import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_projects/components/layout.dart';
import 'package:one_projects/constants.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutSkel(
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
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1Projects',
                          style: TextStyle(fontSize: 30, color: textColor)),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text('Map and sync your projects respectively.',
                            style:
                                TextStyle(fontSize: 18, color: textSubColor)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Text(
                '1Projects allows you to map your 1Password credentials to the respective project folders. From here you can set instructions (for new members) on how to get the credentials as well as similarly set them up.',
                style: TextStyle(fontSize: 14, color: textColor, height: 1.5)),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(30.0),
            color: const Color.fromARGB(25, 0, 0, 0),
            child: const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Nanda',
                        style: TextStyle(fontSize: 20, color: textColor)),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Developed By',
                          style: TextStyle(fontSize: 12, color: textSubColor)),
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
    );
  }
}
