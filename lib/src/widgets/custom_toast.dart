import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(FToast fToast, String message, [int duration = 1]) {
  Widget toast = Container(
    // width: MediaQuery.of(context).size.width * 0.9,
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.amberAccent.shade100.withOpacity(0.9)),
    child: Row(
      children: [
        Flexible(
          child: Text(
            message,
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: duration),
  );
}



qrToast(FToast fToast, String message, [int duration = 1]) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      
      boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        // color: Colors.greenAccent.shade100.withOpacity(0.9)),
        color: Colors.white.withOpacity(0.9)),

        height: 140,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            message,
            style: TextStyle(color: Colors.grey.shade800,
  fontWeight: FontWeight.w700,
  fontSize: 20,
            ),
          ),

        ),

  SizedBox(width: 10,),

       message == 'Ticket scanned' ? Icon(Icons.check_circle_outline, color: Colors.green, size: 80,):
        Icon(Icons.error, color: Colors.red, size: 80,),
      ],
    ),
  );

  fToast.showToast(
    
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: duration),
  );
}
