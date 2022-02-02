import 'dart:convert';
import 'dart:io';
// import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart' as logger;
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/models/order.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/services/database_service.dart';
import 'package:ticketglass_mobile/src/user_pages/ticket_details.dart';
import 'package:ticketglass_mobile/src/widgets/connection_snackbar.dart';
import 'package:ticketglass_mobile/src/widgets/custom_icons.dart';
import 'package:ticketglass_mobile/src/widgets/ticket_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

logger.Logger _logger = logger.Logger();

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
                  : Image.asset('assets/images/Asset.png').image,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  event.imageUrl != null
                      ? Colors.black.withOpacity(0.6)
                      : Colors.black.withOpacity(0.0),
                  BlendMode.srcATop),
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
                                        _logger.i('tapped'),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TicketDetails(),
                                                settings: RouteSettings(
                                                  name: TicketDetails.routeName,
                                                  arguments: {
                                                    'order': order,
                                                  },
                                                )))
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
                                    // display correct qr code based on event status
                                    child: event.isScanOpen()
                                        ? order.scanned == true
                                            ? qrPlaceholder(error: false)
                                            : QrCodeWidget(
                                                event: event, order: order)
                                        : order.scanned == true
                                            ? qrPlaceholder(error: false)
                                            : Stack(
                                                children: [
                                                  QrImage(
                                                    data: '000',
                                                    version: 2,
                                                    dataModuleStyle:
                                                        QrDataModuleStyle(
                                                            dataModuleShape:
                                                                QrDataModuleShape
                                                                    .circle),
                                                    foregroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                  ),
                                                  Container(
                                                    // color:  Colors.black.withOpacity(0.5),
                                                    // rounded corners
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.grey
                                                          .withOpacity(0.7),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.15),
                                                            blurRadius: 8,
                                                            spreadRadius: 3,
                                                            blurStyle: BlurStyle
                                                                .normal)
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .lock_outline_rounded,
                                                        color: Colors.grey[600],
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
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

class QrCodeWidget extends ConsumerStatefulWidget {
  const QrCodeWidget({required this.event, required this.order, Key? key})
      : super(key: key);

  final Event event;
  final Order order;
  @override
  _QrCodeWidgetState createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends ConsumerState<QrCodeWidget> {
  late Timer _timer;

  String qrData = '000';
  bool error = false;
  late String? idToken;

  late Future codeFuture;

  DatabaseService db = DatabaseService();

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
  // generate qr code every 20 second
  void startTimer() async {
    const oneSec = Duration(seconds: 20);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        try {
          await fetchQrCode();
        } catch (e) {
          setState(() {
            qrData = '000';
            error = true;
          });
        }
      },
    );
  }

  // fetch qr code
  Future<void> fetchQrCode() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _logger.d('connected', 'connection');
      }
      // TODO: make int separate funcitons for each task
      // get user token to authenticate on the server
      idToken = await ref.read(authStateProvider).value?.getIdToken();

      _logger.d(idToken);
      // generate a new qr code
      final res = await http
          // .post(Uri.http('192.168.10.7:3000', '/api/qr/generate'), body: {
          .post(Uri.http('ticketglass-dev.herokuapp.com', '/api/qr/generate'),
              body: {
            'orderId': widget.order.orderId
          },
              headers: {
            'Authorization': '$idToken',
          });

      if (res.statusCode == 200) {
        //  decoded & print response body
        final data = jsonDecode(res.body);
        _logger.d(data);

        setState(() {
          qrData = data['qrString'] + '_' + widget.order.orderId;
          error = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        });
      } else {
        _logger.e(res.body);

        setState(() {
          qrData = '000';
          error = true;
        });
      }
    } on SocketException catch (_) {
      _logger.d('no connection');
      connectionSnackbar(context, false);

      setState(() {
        qrData = '000';
        error = true;
      });
    } catch (e) {
      _logger.d(e);
      setState(() {
        qrData = '000';
        error = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // future to periodically fetch qr data
    startTimer();
    // future to fetch the first qrcode data only
    codeFuture = fetchQrCode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  // TODO: implement future builder to show loader beferer qr code is generated for the first time

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: codeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _logger.d('future has data');
            return StreamBuilder<Order>(
                stream: db.getOrder(widget.order.orderId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Order order = snapshot.data!;
                    if (order.scanned == true) {
                      _timer.cancel();

                      return qrPlaceholder(error: false);
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        error == false
                            ? QrImage(
                                data: qrData,
                                version: QrVersions.auto,
                                // size: 200.0,
                                // embeddedImage: AssetImage('assets/images/flutter_logo.png'),
                                dataModuleStyle: QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.circle),
                                foregroundColor:
                                    Theme.of(context).colorScheme.secondary,
                              )
                            : qrPlaceholder(error: true)
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return qrPlaceholder(error: true);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          } else if (snapshot.hasError) {
            _logger.d(snapshot.stackTrace, 'code future snapshot error');
            return qrPlaceholder(error: true);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Stack qrPlaceholder({bool error = false}) {
  return Stack(
    children: [
      QrImage(
        data: '000',
        version: 2,
        dataModuleStyle:
            QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
        foregroundColor: error == false ? Colors.green : Colors.amber,
      ),
      Positioned.fill(
        child: Container(
          margin: EdgeInsets.all(2),
          // height: MediaQuery.of(context).size.width * 0.44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  spreadRadius: 3,
                  blurStyle: BlurStyle.normal)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // height: ,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  error == false
                      ? Icons.check_circle_outline_outlined
                      : Icons.error_outline_rounded,
                  color: error == false ? Colors.green : Colors.amber,
                  size: 50,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(error == false ? 'Ticket scanned' : 'Something went wrong!',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
      )
    ],
  );
}
