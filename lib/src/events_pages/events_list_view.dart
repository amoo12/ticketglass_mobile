import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/models/order.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/services/database_service.dart';
import 'package:ticketglass_mobile/src/widgets/background.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'order_details.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends ConsumerWidget {
  SampleItemListView({
    Key? key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  }) : super(key: key);

  static const routeName = '/';

  final List<SampleItem> items;

  DatabaseService _db = DatabaseService();

  getOrders(String uid) async {
    // if (uid != null) {
    final orders = await _db.getOrders(uid);
    logger.d(orders);
    // return orders;
    // }

    // }
    // await _db.getOrders(uid);
    // return
  }

  @override
  // void initState() {
  // TODO: implement initState
  // super.initState();
  // getOrders(context);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    logger.d(auth.asData?.value?.uid);
    // if (auth.asData?.value?.uid == null) {
    // return null;
    final uid = auth.asData?.value?.uid;
    // }
    
    return Scaffold(
      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
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
                            return ListView.builder(
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
                                    closedBuilder:
                                        (BuildContext c, VoidCallback action) =>
                                            Container(
                                      width: MediaQuery.of(context).size.width,
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
                                                cacheKey: orders[index]
                                                    .eventId,
                                                imageUrl: events[index].imageUrl == null ? '': events[index].imageUrl.toString(),
                                                    
                                                placeholder: (context, url) =>
                                                    SizedBox(
                                                        height: 20,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.broken_image_outlined, size: 30,),
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
                                                    events[index].eventName , 
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
                                                    timestampToString(events[index].startDate),
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
                                    
                                    
                                    openBuilder:
                                        (BuildContext c, VoidCallback action) =>
                                            SampleItemDetailsView(),
                                    tappable: true,
                                  ),
                                );

                                //  return    Container(
                                //       width: MediaQuery.of(context).size.width,
                                //   padding: EdgeInsets.symmetric(vertical: 5),

                                //       child: GestureDetector(
                                //         onTap: () {
                                //         // Navigate to the details page. If the user leaves and returns to
                                //         // the app after it has been killed while running in the
                                //         // background, the navigation stack is restored.
                                //         Navigator.restorablePushNamed(
                                //           context,
                                //           SampleItemDetailsView.routeName,
                                //         );
                                //         },
                                //         child: Card(

                                //           clipBehavior: Clip.antiAlias,
                                //           elevation: 5,

                                //                          child: Column(
                                //                            crossAxisAlignment: CrossAxisAlignment.start,
                                //                            children: [
                                //                              Hero(
                                //                                                          tag: index,

                                //                                child: Container(
                                //                                  width: MediaQuery.of(context).size.width,
                                //                                  height: 150,
                                //                                  // image here
                                //                                  child: CachedNetworkImage(
                                //                                    height: 150,
                                //                                    fit: BoxFit.cover,
                                //                                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/ticketglass-test-696c3.appspot.com/o/events_Images%2FE17DRqZVUAUWCqT.jpg?alt=media&token=18201175-9522-4ce8-ad5e-2538f4fafd13',
                                //                                    placeholder: (context, url) =>
                                //                                        CircularProgressIndicator(),
                                //                                    errorWidget: (context, url, error) =>
                                //                                        Icon(Icons.error),
                                //                                  ),
                                //                                ),
                                //                              ),
                                //                              Container(
                                //                               //  eventDetails here
                                //                               height: 50,
                                //                               padding: EdgeInsets.symmetric(horizontal: 10),
                                //                               child:Column(
                                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                                 children:  [
                                //                                    Text(
                                //                                     "Event Name"
                                //                                     ,style: TextStyle(
                                //                                       fontSize: 20,
                                //                                       fontWeight: FontWeight.bold,
                                //                                       color: Colors.blueGrey[800]
                                //                                     ),
                                //                                     overflow: TextOverflow.ellipsis,
                                //                                   ),

                                //                                    Text('Jan 29th 2022',
                                //                                   style: TextStyle(
                                //                                     fontSize: 15,
                                //                                     fontWeight: FontWeight.w500,
                                //                                     color: Colors.grey,
                                //                                   ),
                                //                                   ),

                                //                                 ],
                                //                               ),
                                //                              ),
                                //                            ],
                                //                          ),
                                //                                 ),
                                //       ),
                                //       );

                                //  ListTile(
                                //   title: Text('SampleItem ${item.id}'),
                                //   leading: const CircleAvatar(
                                //     // Display the Flutter Logo image asset.
                                //     foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                                //   ),
                                //   onTap: () {
                                //     // Navigate to the details page. If the user leaves and returns to
                                //     // the app after it has been killed while running in the
                                //     // background, the navigation stack is restored.
                                //     Navigator.restorablePushNamed(
                                //       context,
                                //       SampleItemDetailsView.routeName,
                                //     );
                                // }
                                // );
                              },
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




