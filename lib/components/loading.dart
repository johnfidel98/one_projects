import 'package:flutter/material.dart';

class GeneralLoading extends StatelessWidget {
  const GeneralLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width),
        const SizedBox(
          height: 500,
          width: 500,
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ),
      ],
    );
  }
}
