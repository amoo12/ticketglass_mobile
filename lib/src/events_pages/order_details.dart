import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as logger;
import 'package:ticketglass_mobile/src/events_pages/events_list_view.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/models/order.dart';
import 'package:ticketglass_mobile/src/widgets/custom_icons.dart';
import 'package:ticketglass_mobile/src/widgets/ticket_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';


logger.Logger log = logger.Logger();

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({Key? key}) : super(key: key);
// get random integer
// dynamic
  late Event event;
  late Order order;

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    // log.i(event);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    event = args['event'] as Event;
    order = args['order'] as Order;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBody: true,

      appBar: AppBar(
        // title: Text(event.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: event.imageUrl != null
                  ? CachedNetworkImageProvider(
                      event.imageUrl.toString(),
                      // 'https://firebasestorage.googleapis.com/v0/b/ticketglass-test-696c3.appspot.com/o/events_Images%2FE17DRqZVUAUWCqT.jpg?alt=media&token=18201175-9522-4ce8-ad5e-2538f4fafd13',
                      cacheKey: order.eventId,
                      maxHeight: MediaQuery.of(context).size.height.toInt(),
                      maxWidth: MediaQuery.of(context).size.width.toInt(),
                    )
                  : CachedNetworkImageProvider(
                      'assets/images/flutter_logo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.srcATop),
            ),
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TicketSvg()),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.7,
                      // color: Colors.yellow[50],
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.eventName,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 22,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  event.address.toString(),
                                                  // 'asfjlksfjalskjflkaj al;skfhas hasfaljh fsdhfkljh skdjhfjk',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              timestampToString(
                                                  event.startDate),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () => {
                                        log.i('tapped'),
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.transparent,
                                          border: Border.all(
                                            // color: ,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.9),
                                            width: 1.3,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  order.quantities!
                                                      .reduce((a, b) => a + b)
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                Transform.rotate(
                                                  angle: 45 *
                                                      3.1415926535897932 /
                                                      180,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 22,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                Icon(
                                                  CustomIcons.ticket_alt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'More details',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.9),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            Divider(
                              thickness: 1,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    // round corners
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            spreadRadius: 3,
                                            blurStyle: BlurStyle.outer)
                                      ],
                                    ),
                                    child: QrCodeWidget(
                                        event: event, order: order),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Show this QR code at the venue',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              )
            ],
          )),
      // ),
    );
  }
}

class QrCodeWidget extends StatefulWidget {
  const QrCodeWidget({required this.event, required this.order, Key? key})
      : super(key: key);

  final Event event;
  final Order order;
  @override
  _QrCodeWidgetState createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  // call function every 5 second
  late Timer _timer;
  int _count = 0;

  // create a funciton to call every 5 second
  // late Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 30);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        // if (_start == 0) {
        //   setState(() {
        //     timer.cancel();
        //   });
        // } else {
        // TODO: make api call to generate qr code hash
        log.d(_start);
        setState(() {
          _start--;
        });
        // }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // _incrementCounter();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImage(
          data: _start.toString(),
          version: 2,
          // size: 200.0,
          // embeddedImage: AssetImage('assets/images/flutter_logo.png'),
          foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
