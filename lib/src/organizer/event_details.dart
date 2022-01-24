import 'package:flutter/material.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/widgets/buttons.dart';
import 'package:ticketglass_mobile/src/widgets/customt_tooltip.dart';

class EventDetails extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  EventDetails({Key? key}) : super(key: key);

  static const routeName = '/event_details';
  late final Event event;
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
                            columnWidths: {
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
                                        'stars',
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
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                      context: context, text: 'Scan tickets', onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
