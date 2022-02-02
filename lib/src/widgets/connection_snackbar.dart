import 'package:flutter/material.dart';

connectionSnackbar(BuildContext context, bool connected) async {
  final snackBar = SnackBar(
  backgroundColor: connected ? Colors.green: Colors.red,
  action: SnackBarAction(
    label: 'Dismiss',
    textColor: Colors.white,
    onPressed: () {},
  ),
  duration: connected ? Duration(seconds: 1): Duration(days: 365),
  content: Text(connected ? 'Back online':'No internet Connection'),
);


  await Future.delayed(Duration(seconds: 1));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
