import 'package:flutter/material.dart';

final snackBar = SnackBar(
  backgroundColor: Colors.red,
  action: SnackBarAction(
    label: 'Dismiss',
    textColor: Colors.white,
    onPressed: () {},
  ),
  duration: Duration(days: 365),
  content: Text('No internet Connection'),
);

connectionSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
