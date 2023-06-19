import 'package:flutter/material.dart';
import 'package:one_projects/constants.dart';

class LayoutSkel extends StatelessWidget {
  const LayoutSkel({
    super.key,
    required this.mainArea,
    this.sideArea,
  });

  final Widget mainArea;
  final Widget? sideArea;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: mainColor,
            child: sideArea,
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            color: contrastColor,
            child: mainArea,
          ),
        ),
      ],
    );
  }
}
