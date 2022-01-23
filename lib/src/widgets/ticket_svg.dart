import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TicketSvg extends StatelessWidget {
  const TicketSvg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/ticket.svg',
      alignment: Alignment.topCenter,
      color: Colors.white.withOpacity(0.95),
      height: MediaQuery.of(context).size.height * 0.7,
    );
  }
}
