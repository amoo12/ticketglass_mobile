import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/models/order.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/services/database_service.dart';
import 'package:ticketglass_mobile/src/widgets/background.dart';

import '../settings/settings_view.dart';
import 'order_details.dart';


/// Displays a list of SampleItems.
class OrdersList extends ConsumerStatefulWidget {
  const OrdersList({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

@override
  _OrdersListState createState() => _OrdersListState();

}

class _OrdersListState extends ConsumerState<OrdersList> {
  final DatabaseService _db = DatabaseService();

  late Future<List> ordersList;

  // ignore: prefer_typing_uninitialized_variables
  late final uid;

  Future<List> getOrders(String uid) async {
    // if (uid != null) {
    final List orders = await _db.getOrders(uid);
    // logger.d(orders);
    // return orders;
    // }
    return orders;
    // }
    // await _db.getOrders(uid);
    // return
  }

  Future<void> _pullRefresh() async {
    List list = await _db.getOrders(uid);
    setState(() {
      ordersList = Future.value(list);
    });
  }

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authStateProvider);
    uid = auth.asData?.value?.uid;
    ordersList = getOrders(uid);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundSvg(),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: const Text(
                            'Upcoming Events',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Navigate to the settings page. If the user leaves and returns
                            // to the app after it has been killed while running in the
                            // background, the navigation stack is restored.
                            Navigator.restorablePushNamed(
                              context,
                              SettingsView.routeName,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder<List>(
                        future: _db.getOrders(uid!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                           List<Order> orders  = snapshot.data![0];
                           List<Event>  events = snapshot.data![1];
                            return RefreshIndicator(
                              onRefresh: _pullRefresh,
                              child: ListView.builder(
                                // Providing a restorationId allows the ListView to restore the
                                // scroll position when a user leaves and returns to the app after it
                                // has been killed while running in the background.
                                restorationId: 'sampleItemListView',
                                itemCount: orders.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // final item = items[index];

                                  return AnimatedContainer(
                                    // color: Colors.transparent,
                                    duration: Duration(milliseconds: 300),
                                    // margin: EdgeInsets.only(bottom: _hideNavBar ? 0 : 56),
                                    child: OpenContainer(
                                      // closedShape: ,
                                      closedColor: Colors.transparent,
                                      closedElevation: 0.0,
                                      // closedShape: const RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.all(Radius.circular(50))),
                                      // transitionDuration: Duration(milliseconds: 500),
                                      closedBuilder: (BuildContext c,
                                              VoidCallback action) =>
                                          Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // padding: EdgeInsets.symmetric(vertical: 5),

                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            // side: BorderSide(color: Colors.white70, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 150,
                                                // image here
                                                child: CachedNetworkImage(
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                  cacheKey:
                                                      orders[index].eventId,
                                                  imageUrl:
                                                      events[index].imageUrl ==
                                                              null
                                                          ? ''
                                                          : events[index]
                                                              .imageUrl
                                                              .toString(),
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                          height: 20,
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator())),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                            Image.asset(
                                                              'assets/images/Asset.png',
                                                              fit: BoxFit.cover,
                                                            )
                                                ),
                                              ),
                                              Container(
                                                //  eventDetails here
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // event name
                                                    Text(
                                                      events[index].eventName,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blueGrey[800]),
                                                      // overflow:
                                                      // TextOverflow.ellipsis,
                                                    ),
                                                    // event start date
                                                    Text(
                                                      timestampToString(
                                                          events[index]
                                                              .startDate),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      routeSettings: RouteSettings(
                                        name: SampleItemDetailsView.routeName,
                                        arguments: {
                                          'event': events[index],
                                          'order': orders[index],
                                          // "money": 'money is funny'
                                        },
                                      ),

                                      openBuilder: (BuildContext c,
                                              VoidCallback action) =>
                                          SampleItemDetailsView(),
                                      tappable: true,
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error"),
                            );
                          } else {
                            return Center(
                              child: SizedBox(
                                  height: 20,
                                  child: CircularProgressIndicator()),
                            );
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// convert timestamp to local date string




