import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/models/order.dart';

Logger logger = Logger();

class DatabaseService {
  DatabaseService();

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference<Event> eventsCollection = FirebaseFirestore.instance
      .collection('events')
      .withConverter<Event>(
          fromFirestore: (snapshot, _) => Event.fromMap(snapshot.data()!),
          toFirestore: (event, _) => event.toMap());
  final Query<Order> ordersCollectionGroup =
      FirebaseFirestore.instance.collectionGroup('orders').withConverter<Order>(
            fromFirestore: (snapshot, _) => Order.fromMap(snapshot.data()!),
            toFirestore: (order, _) => order.toMap(),
          );

  Future<List> getOrders(String uid) async {
    List<Order> orders = [];
    List<Event> events = [];
    final results = await ordersCollectionGroup
        .where('userId', isEqualTo: uid)
        .orderBy('orderTime', descending: false)
        .get();

    orders = results.docs.map((doc) {
      Order order = doc.data();
      // orders.add(order);
      return order;
    }).toList();

    for (var i = 0; i < orders.length; i++) {
      Event? event = await getEvent(orders[i].eventId);
      events.add(event!);
    }

    return [orders, events];
  }

  Future<Event?> getEvent(String eventId) async {
    final eventDoc = await eventsCollection.doc(eventId).get();

    if (eventDoc.exists) {
      return eventDoc.data();
    }
  }



  Future<List<Event>> getEvente(String uid) async {
    List<Event> events = [];
    final results = await eventsCollection
        .where('organizerId', isEqualTo: uid)
        .orderBy('orderTime', descending: true)
        .get();

    events = results.docs.map((doc) {
      Event event = doc.data();
      // events.add(event);
      return event;
    }).toList();

    return events;

    
  }
}


