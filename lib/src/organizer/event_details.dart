import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/widgets/buttons.dart';
import 'package:ticketglass_mobile/src/widgets/custom_toast.dart';
import 'package:ticketglass_mobile/src/widgets/customt_tooltip.dart';
import 'package:http/http.dart' as http;
import 'package:ticketglass_mobile/src/widgets/progress_indicator.dart';

Logger logger = Logger();

class EventDetails extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  EventDetails({Key? key}) : super(key: key);

  static const routeName = '/event_details';
  late Event event;
  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)?.settings.arguments as Event;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(event.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Theme.of(context).colorScheme.primaryVariant),
                Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.blueGrey[50]),
              ],
            ),
          ),
          Container(
            // TODO: change to appbar height

            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 1,
                    color: Colors.blueGrey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                event.eventName,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey[800]),
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomToolTip(
                                child: Icon(Icons.circle,
                                    color: event.getEventStatus() == 'Expired'
                                        ? Colors.grey
                                        : event.getEventStatus() == 'Live'
                                            ? Colors.green
                                            : event.getEventStatus() ==
                                                    'Scannable'
                                                ? Colors.amber
                                                : Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: const {
                              0: FlexColumnWidth(1.5),
                              1: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Text(
                                        'starts',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey[800]),
                                      ),
                                    ),
                                    Text(
                                      timestampToString(event.startDate),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[800]),
                                    ),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Text(
                                        'Ends',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey[800]),
                                      ),
                                    ),
                                    Text(
                                      timestampToString(event.endDate),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[800]),
                                    ),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Text(
                                        'Booking Starts',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey[800]),
                                      ),
                                    ),
                                    Text(
                                      timestampToString(event.bookingStartDate),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[800]),
                                    ),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Text(
                                        'Booking Ends',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey[800]),
                                      ),
                                    ),
                                    Text(
                                      timestampToString(event.bookingEndDate),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[800]),
                                    ),
                                  ]),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Text(
                //   event.eventName,
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primaryVariant,
                                
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QRViewExample(
                                          eventId: event.id.toString()),
                                    ));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.qr_code_scanner_rounded,
                                    size: 100,
                                  ),
                                  Text('Scan tickets')
                                ],
                              ),
                            )

                            //  ButtonWidget(

                            //     context: context,
                            //     text: 'Scan tickets',
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) =>
                            //                 QRViewExample(eventId: event.id.toString()),
                            //           ));
                            //     }),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QRViewExample extends ConsumerStatefulWidget {
  const QRViewExample({required this.eventId, Key? key}) : super(key: key);
  final String eventId;

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends ConsumerState<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late FToast fToast;

  late String? idToken;
  bool error = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      try {
        customProgressIdicator(context);
        idToken = await ref.read(authStateProvider).value?.getIdToken();

        logger.d(idToken);
        // split the qr code into two parts by _ and get the first part
        // and the second part
        final qrString = scanData.code?.split('_')[0];
        final orderId = scanData.code?.split('_')[1];

        // generate a new qr code
        final res = await http.post(
            Uri.http('ticketglass-dev.herokuapp.com', '/api/qr/scan'),
            body: {
              'orderId': orderId,
              'eventId': widget.eventId,
              'qrString': qrString
            },
            headers: {
              'Authorization': '$idToken',
            });

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          logger.d(data);

          if (data['scanned'] == true) {
            // await controller.pauseCamera();
            Navigator.pop(context);
            qrToast(fToast, 'Ticket scanned');
            return Navigator.pop(context);
          }
          logger.e(res.body);
          error = true;
          Navigator.pop(context);
          qrToast(fToast, 'Invalid Ticket');
          return Navigator.pop(context);
        } else {
          logger.e(res.body);
          error = true;
           Navigator.pop(context);
          qrToast(fToast, 'error');
          return Navigator.pop(context);
        }

      } catch (e) {
        logger.e(e);
        error = true;
        Navigator.pop(context);
        qrToast(fToast, 'Not ticket glass ticket');
        return Navigator.pop(context);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }
}
