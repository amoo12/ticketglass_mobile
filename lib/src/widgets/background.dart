import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundSvg extends StatelessWidget {
  const BackgroundSvg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/background.svg',
      alignment: Alignment.topCenter,
      color: Theme.of(context).colorScheme.primaryVariant,
    );
  }
}
