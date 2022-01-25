import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/services/database_service.dart';
import 'package:ticketglass_mobile/src/settings/settings_view.dart';
import 'package:ticketglass_mobile/src/widgets/customt_tooltip.dart';

class EventsList extends ConsumerWidget {
  EventsList({Key? key}) : super(key: key);

  final db = DatabaseService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final String uid = auth.asData!.value!.uid;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('My Events'),
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
                  future: db.getEvente(uid),
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
                                            : events[index].getEventStatus() ==
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
                      );
                    } else if (snapshot.hasError) {
                      logger.e(snapshot.stackTrace);
                      return Text("${snapshot.error} ");
                    } else {
                      return Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
