import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/services/database_service.dart';
import 'package:ticketglass_mobile/src/settings/settings_view.dart';
import 'package:ticketglass_mobile/src/widgets/customt_tooltip.dart';

class EventsList extends ConsumerStatefulWidget {
  const EventsList({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends ConsumerState<EventsList> {
  late Future<List> eventsList;

  final db = DatabaseService();
  // ignore: prefer_typing_uninitialized_variables
  late final uid;

  Future<List> getEvents(String uid) async {
    final List orders = await db.getEvents(uid);
    return orders;
  }

  Future<void> _pullRefresh() async {
    List list = await db.getEvents(uid);
    setState(() {
      eventsList = Future.value(list);
    });
  }

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authStateProvider);
    uid = auth.asData?.value?.uid;
    eventsList = getEvents(uid);
  }

  @override
  Widget build(BuildContext context) {
    // final auth = ref.watch(authStateProvider);
    // final String uid = auth.asData!.value!.uid;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('My Events'),
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
        actions: [
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
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700]),
                    ),
                    CustomToolTip(
                      child: Text(
                        'Status',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[700]),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder<List<Event>>(
                  future: db.getEvents(uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Event> events = [];
                      events = snapshot.data!;
                      if (events.isEmpty) {
                        return Center(
                          child: Text('No events yet'),
                        );
                      }
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: _pullRefresh,
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  events[index].eventName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(' Starts at: ' +
                                    timestampToString(
                                        events[index].startDate.toString())),
                                trailing: CustomToolTip(
                                  child: Icon(Icons.circle,
                                      color: events[index].getEventStatus() ==
                                              'Expired'
                                          ? Colors.grey
                                          : events[index].getEventStatus() ==
                                                  'Live'
                                              ? Colors.green
                                              : events[index]
                                                          .getEventStatus() ==
                                                      'Scannable'
                                                  ? Colors.amber
                                                  : Colors.red),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/event_details',
                                      arguments: events[index]);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      logger.e(snapshot.stackTrace);
                      return Text("${snapshot.error} ");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
