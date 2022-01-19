import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView(  { Key? key}) : super(key: key);
// get random integer



  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              'https://firebasestorage.googleapis.com/v0/b/ticketglass-test-696c3.appspot.com/o/events_Images%2FE17DRqZVUAUWCqT.jpg?alt=media&token=18201175-9522-4ce8-ad5e-2538f4fafd13',
            ),
            fit: BoxFit.cover,
             colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.srcATop
               ),
            ),
          ),
        child: Text('More Information Here'),
        ),
      // ),
    );
  }
}
