import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CustomToolTip extends StatelessWidget {
  const CustomToolTip({required this.child, this.content, Key? key})
      : super(key: key);

  final Widget child;
  final Widget? content;
  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
        child: child,
        content: content == null
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          // Icon(Icons.circle, color: Colors.green),
                          Text(
                            'Event status:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.circle, color: Colors.green),
                          Text(
                            'Booking open',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.circle, color: Colors.amber),
                          Text(
                            'Time to scan ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.circle, color: Colors.red),
                          Text(
                            'Booking Closed',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.circle, color: Colors.grey),
                          Text(
                            'Ended',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
            : content!);
  }
}
